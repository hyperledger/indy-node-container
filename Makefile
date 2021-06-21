all: buster ubuntu

buster_base:
	docker build -f "build/Dockerfile.base.buster" -t indy-node-container/base:buster build

buster: buster_base
	docker build -f "build/Dockerfile.buster" -t indy-node-container/indy_node:buster --build-arg BASE=python:3.6-slim-buster --build-arg BUILDER_BASE=indy-node-container/base:buster build

ubuntu_base:
	docker build -f "build/Dockerfile.base.ubuntu18" -t indy-node-container/base:ubuntu build

ubuntu: ubuntu_base
	docker build -f "build/Dockerfile.ubuntu18" -t indy-node-container/indy_node:ubuntu --build-arg BASE=ubuntu:18.04 --build-arg BUILDER_BASE=indy-node-container/base:ubuntu build

clean_buster_base:
	-docker image rm indy-node-container/base:buster

clean_buster:
	-docker image rm indy-node-container/indy_node:buster

clean_ubuntu_base:
	-docker image rm indy-node-container/base:ubuntu

clean_ubuntu:
	-docker image rm indy-node-container/indy_node:ubuntu

clean: clean_buster clean_buster_base clean_ubuntu clean_ubuntu_base


# all check targets require a local trivy installation - see https://aquasecurity.github.io/trivy/

check_buster:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/buster.html indy-node-container/indy_node:buster
#	-xdg-open trivy-reports/buster.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:buster

check_ubuntu:
	mkdir -p trivy-reports
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL --format template --template "@trivy/html.tpl" -o trivy-reports/ubuntu.html indy-node-container/indy_node:ubuntu
#	-xdg-open trivy-reports/ubuntu.html
	-trivy image --ignore-unfixed --severity HIGH,CRITICAL indy-node-container/indy_node:ubuntu
