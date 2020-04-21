setup:
	bash deployment/configure/configure.sh

images:
	docker image build . -f deployment/docker/Dockerfile-arch --build-arg SYSTEM=archlinux:latest -t artudi54/shellrc:archlinux
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=debian:buster -t artudi54/shellrc:debian-buster
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=debian:bullseye -t artudi54/shellrc:debian-bullseye
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:18.04 -t artudi54/shellrc:ubuntu-18.04
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:19.10 -t artudi54/shellrc:ubuntu-19.10
	docker image build . -f deployment/docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:20.04 -t artudi54/shellrc:ubuntu-20.04

all: setup images

