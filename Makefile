setup:
	bash configure.sh

images:
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:16.04 -t artudi54/shellrc:ubuntu-16.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:18.04 -t artudi54/shellrc:ubuntu-18.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:18.10 -t artudi54/shellrc:ubuntu-18.10
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:19.04 -t artudi54/shellrc:ubuntu-19.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:19.10 -t artudi54/shellrc:ubuntu-19.10

all: setup images
