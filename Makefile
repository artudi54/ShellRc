setup:
	bash deployment/configure/configure.sh

images:
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=debian:buster -t artudi54/shellrc:debian-buster
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:18.04 -t artudi54/shellrc:ubuntu-18.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:19.04 -t artudi54/shellrc:ubuntu-19.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:19.10 -t artudi54/shellrc:ubuntu-19.10

all: setup images

