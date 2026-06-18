install:
	bash install.sh

image-arch:
	docker image build . -f docker/Dockerfile --build-arg SYSTEM=archlinux:latest -t artudi54/shellrc:archlinux

image-debian-13:
	docker image build . -f docker/Dockerfile --build-arg SYSTEM=debian:trixie -t artudi54/shellrc:debian-13

image-debian: image-debian-13

image-ubuntu-24.04:
	docker image build . -f docker/Dockerfile --build-arg SYSTEM=ubuntu:24.04 -t artudi54/shellrc:ubuntu-24.04

image-ubuntu-26.04:
	docker image build . -f docker/Dockerfile --build-arg SYSTEM=ubuntu:26.04 -t artudi54/shellrc:ubuntu-26.04

image-ubuntu: image-ubuntu-26.04

images: image-arch image-debian-13 image-ubuntu-24.04 image-ubuntu-26.04

all: install

