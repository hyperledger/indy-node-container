# Current network
NETWORK_NAME = "ssi4de"

# Directory to store ledger.
LEDGER_DIR = '/var/lib/indy'

# Directory to store keys.
KEYS_DIR = '/var/lib/indy'

# Directory to store genesis transactions files.
GENESIS_DIR = '/var/lib/indy'

# Directory to store backups.
BACKUP_DIR = '/var/lib/indy/backup'

# Directory to store plugins.
PLUGINS_DIR = '/var/lib/indy/plugins'

# Directory to store node info.
NODE_INFO_DIR = '/var/lib/indy'

# For running indy >= 1.13 in a legacy network (i.e. including revocation transactions written by indy nodes < 1.13)
REV_STRATEGY_USE_COMPAT_ORDERING=True

## Logging
# 0 means everything
logLevel = 1

# Enable/Disable stdout logging
enableStdOutLogging = True

# Directory to store logs. You might want to mount this in order to access the log files from outside the container.
LOG_DIR = '/var/log/indy'

# Hostname of the controller 
controlServiceHost='indy_node_controller'
