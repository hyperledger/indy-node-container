# Copyright 2020-2021 by all parties listed in the NOTICE file
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# The default make goal is ubuntu20
.DEFAULT_GOAL := ubuntu20

all: bullseye ubuntu20 controller

bullseye:
	docker build -f "build/Dockerfile.debian11" -t indy-node-container/indy_node:bullseye ./build

ubuntu20:
	docker build -f "build/Dockerfile.ubuntu20" -t indy-node-container/indy_node:ubuntu20 ./build

.PHONY: controller
controller:
	docker build controller -t indy-node-container/indy_node_controller

clean_bullseye:
	-docker image rm indy-node-container/indy_node:bullseye

clean_ubuntu20:
	-docker image rm indy-node-container/indy_node:ubuntu20

clean_controller:
	-docker image rm indy-node-container/indy_node_controller

clean: clean_bullseye clean_ubuntu20 clean_controller


# all check targets require a local trivy installation - see https://aquasecurity.github.io/trivy/

check_bullseye:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/bullseye.html indy-node-container/indy_node:bullseye
#	-xdg-open trivy-reports/bullseye.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:bullseye

check_ubuntu20:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/ubuntu20.html indy-node-container/indy_node:ubuntu20
#	-xdg-open trivy-reports/ubuntu20.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:ubuntu20

check_controller:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/node_controller.html indy-node-container/indy_node_controller
#	-xdg-open trivy-reports/node_controller.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node_controller
