all: buster ubuntu16 ubuntu18

buster:
	docker build -f "build/Dockerfile.buster" -t indy-node-container/indy_node:buster build

ubuntu16:
	docker build -f "build/Dockerfile.ubuntu16" -t indy-node-container/indy_node:ubuntu16 build

ubuntu18:
	docker build -f "build/Dockerfile.ubuntu18" -t indy-node-container/indy_node:ubuntu18 build

clean_buster:
	-docker image rm indy-node-container/indy_node:buster

clean_ubuntu16:
	-docker image rm indy-node-container/indy_node:ubuntu16

clean_ubuntu18:
	-docker image rm indy-node-container/indy_node:ubuntu18

clean: clean_buster clean_ubuntu16 clean_ubuntu18


# all check targets require a local trivy installation - see https://aquasecurity.github.io/trivy/

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
