FROM ubuntu:16.04

RUN apt update
RUN apt install sudo -y
COPY . root/.config/ShellRc

ENTRYPOINT root/.config/ShellRc/configure.sh
