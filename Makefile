install:
	bash install.sh

image-arch:
	./docker/build-image.sh archlinux:latest artudi54/shellrc:archlinux

test-arch: image-arch
	./docker/run-test.sh artudi54/shellrc:archlinux

image-debian-13:
	./docker/build-image.sh debian:trixie artudi54/shellrc:debian-13

image-debian: image-debian-13

test-debian-13: image-debian-13
	./docker/run-test.sh artudi54/shellrc:debian-13

test-debian: test-debian-13

image-ubuntu-24.04:
	./docker/build-image.sh ubuntu:24.04 artudi54/shellrc:ubuntu-24.04

test-ubuntu-24.04: image-ubuntu-24.04
	./docker/run-test.sh artudi54/shellrc:ubuntu-24.04

image-ubuntu-26.04:
	./docker/build-image.sh ubuntu:26.04 artudi54/shellrc:ubuntu-26.04

image-ubuntu: image-ubuntu-26.04

test-ubuntu-26.04: image-ubuntu-26.04
	./docker/run-test.sh artudi54/shellrc:ubuntu-26.04

test-ubuntu: test-ubuntu-26.04

images: image-arch image-debian-13 image-ubuntu-24.04 image-ubuntu-26.04
test: test-arch test-debian-13 test-ubuntu-24.04 test-ubuntu-26.04

all: install

