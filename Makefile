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


# The default make goal is ubuntu18  
.DEFAULT_GOAL := ubuntu18

all: bullseye buster ubuntu16 ubuntu18 ubuntu20 controller

bullseye:
	docker build -f "build/Dockerfile.bullseye" -t indy-node-container/indy_node:bullseye ./build

buster:
	docker build -f "build/Dockerfile.buster" -t indy-node-container/indy_node:buster ./build

ubuntu16:
	docker build -f "build/Dockerfile.ubuntu16" -t indy-node-container/indy_node:ubuntu16 ./build

ubuntu18:
	docker build -f "build/Dockerfile.ubuntu18" -t indy-node-container/indy_node:ubuntu18 ./build

ubuntu20:
	docker build -f "build/Dockerfile.ubuntu20" -t indy-node-container/indy_node:ubuntu20 ./build

.PHONY: controller
controller:
	docker build controller -t indy-node-container/indy_node_controller

clean_bullseye:
	-docker image rm indy-node-container/indy_node:bullseye

clean_buster:
	-docker image rm indy-node-container/indy_node:buster

clean_ubuntu16:
	-docker image rm indy-node-container/indy_node:ubuntu16

clean_ubuntu18:
	-docker image rm indy-node-container/indy_node:ubuntu18

clean_ubuntu20:
	-docker image rm indy-node-container/indy_node:ubuntu20

clean_controller:
	-docker image rm indy-node-container/indy_node_controller

clean: clean_bullseye clean_buster clean_ubuntu16 clean_ubuntu18 clean_ubuntu20 clean_controller


# all check targets require a local trivy installation - see https://aquasecurity.github.io/trivy/

check_bullseye:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/bullseye.html indy-node-container/indy_node:bullseye
#	-xdg-open trivy-reports/bullseye.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:bullseye

check_buster:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/buster.html indy-node-container/indy_node:buster
#	-xdg-open trivy-reports/buster.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:buster

check_ubuntu16:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/ubuntu16.html indy-node-container/indy_node:ubuntu16
#	-xdg-open trivy-reports/ubuntu16.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:ubuntu16

check_ubuntu18:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/ubuntu18.html indy-node-container/indy_node:ubuntu18
#	-xdg-open trivy-reports/ubuntu18.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:ubuntu18

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
