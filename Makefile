install:
	bash install.sh

image-arch:
	docker image build . -f docker/Dockerfile-arch --build-arg SYSTEM=archlinux:latest -t artudi54/shellrc:archlinux

images:
	image-arch
	docker image build . -f docker/Dockerfile-debian --build-arg SYSTEM=debian:buster -t artudi54/shellrc:debian-buster
	docker image build . -f docker/Dockerfile-debian --build-arg SYSTEM=debian:bullseye -t artudi54/shellrc:debian-bullseye
	docker image build . -f docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:22.04 -t artudi54/shellrc:ubuntu-22.04
	docker image build . -f docker/Dockerfile-debian --build-arg SYSTEM=ubuntu:24.04 -t artudi54/shellrc:ubuntu-24.04

all: install

