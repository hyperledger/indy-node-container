import os
import select
import socket
from typing import List

from common.version import InvalidVersionError

from indy_common.constants import UPGRADE_MESSAGE, RESTART_MESSAGE, MESSAGE_TYPE
from stp_core.common.log import getlogger, Logger

from indy_common.version import (
    SourceVersion, src_version_cls
)
from indy_common.config_util import getConfig
from indy_common.config_helper import ConfigHelper
from indy_common.util import compose_cmd
from indy_node.utils.node_control_utils import NodeControlUtil


TIMEOUT = 600
BACKUP_FORMAT = 'zip'
BACKUP_NUM = 10
TMP_DIR = '/tmp/.indy_tmp'
LOG_FILE_NAME = 'node_control.log'

logger = getlogger()

class NodeControlTool:
    MAX_LINE_SIZE = 1024

    def __init__(
            self,
            timeout: int = TIMEOUT,
            backup_format: str = BACKUP_FORMAT,
            test_mode: bool = False,
            backup_target: str = None,
            files_to_preserve: List[str] = None,
            backup_dir: str = None,
            backup_name_prefix: str = None,
            backup_num: int = BACKUP_NUM,
            hold_ext: str = '',
            config=None):
        self.config = config or getConfig()

        self.test_mode = test_mode
        self.timeout = timeout or TIMEOUT

        self.hold_ext = hold_ext.split(" ")

        config_helper = ConfigHelper(self.config)
        self.backup_dir = backup_dir or config_helper.backup_dir
        self.backup_target = backup_target or config_helper.genesis_dir

        self.tmp_dir = TMP_DIR
        self.backup_format = backup_format

        _files_to_preserve = [self.config.lastRunVersionFile, self.config.nextVersionFile,
                              self.config.upgradeLogFile, self.config.lastVersionFilePath,
                              self.config.restartLogFile]

        self.files_to_preserve = files_to_preserve or _files_to_preserve
        self.backup_num = backup_num

        _backup_name_prefix = '{}_backup_'.format(self.config.NETWORK_NAME)

        self.backup_name_prefix = backup_name_prefix or _backup_name_prefix
        self._enable_file_logging()

        self._listen()

        self.start()

    def _enable_file_logging(self):
        path_to_log_file = os.path.join(self.config.LOG_DIR, LOG_FILE_NAME)
        Logger().enableFileLogging(path_to_log_file)

    def _listen(self):
        # Create a TCP/IP socket
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.setblocking(0)

        # Bind the socket to the port
        self.server_address = ('0.0.0.0', 30003)

        logger.info('Node control tool is starting up on {} port {}'.format(*self.server_address))
        self.server.bind(self.server_address)

        # Listen for incoming connections
        self.server.listen(1)

    def _call_restart_node_script(self):
        logger.info('Restarting indy')
        cmd = compose_cmd(['/opt/controller/restart_indy_node'])
        NodeControlUtil.run_shell_script(cmd, timeout=self.timeout)

    def _call_upgrade_node_script(self):
        logger.info('Upgrading indy')
        cmd = compose_cmd(['/opt/controller/upgrade_indy'])
        NodeControlUtil.run_shell_script(cmd, timeout=self.timeout)

    def _upgrade(
            self,
            new_src_ver: SourceVersion,
            pkg_name: str,
            migrate=True,
            rollback=True
    ):
        try:
            self._call_upgrade_node_script()
        except Exception as ex:
            logger.error("Upgrade fail: " + ex.args[0])

    def _restart(self):
        try:
            self._call_restart_node_script()
        except Exception as ex:
            logger.error("Restart fail: " + ex.args[0])

    def _process_data(self, data):
        import json
        try:
            command = json.loads(data.decode("utf-8"))
            logger.debug("Decoded ", command)
            if command[MESSAGE_TYPE] == UPGRADE_MESSAGE:
                pkg_name = command['pkg_name']
                upstream_cls = src_version_cls(pkg_name)
                try:
                    new_src_ver = upstream_cls(command['version'])
                except InvalidVersionError as exc:
                    logger.error(
                        "invalid version {} for package {} with upstream class {}: {}"
                        .format(command['version'], pkg_name, upstream_cls, exc)
                    )
                else:
                    self._upgrade(new_src_ver, pkg_name)
            elif command[MESSAGE_TYPE] == RESTART_MESSAGE:
                self._restart()
        except json.decoder.JSONDecodeError as e:
            logger.error("JSON decoding failed: {}".format(e))
        except Exception as e:
            logger.error("Unexpected error in _process_data {}".format(e))

    def start(self):
        # Sockets from which we expect to read
        readers = [self.server]

        # Sockets to which we expect to write
        writers = []
        errs = []

        while readers:
            # Wait for at least one of the sockets to be ready for processing
            logger.debug('Waiting for the next event')
            readable, writable, exceptional = select.select(
                readers, writers, errs)
            for s in readable:
                if s is self.server:
                    # A "readable" server socket is ready to accept a
                    # connection
                    connection, client_address = s.accept()
                    logger.debug('New connection from {} on fd {}'
                                 .format(client_address, connection.fileno()))
                    connection.setblocking(0)
                    readers.append(connection)
                else:
                    data = s.recv(8192)
                    if data:
                        logger.debug(
                            'Received "{}" from {} on fd {}'
                            .format(data, s.getpeername(), s.fileno()))
                        self._process_data(data)
                    else:
                        logger.debug('Closing socket with fd {}'
                                     .format(s.fileno()))
                        readers.remove(s)
                        s.close()
