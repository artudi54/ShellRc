ARG SYSTEM=archlinux:latest
FROM $SYSTEM

RUN if command -v pacman >/dev/null 2>&1; then \
        pacman -Sy --noconfirm sudo which shadow; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update && apt-get install -y sudo which passwd; \
    fi

RUN useradd -m -s /bin/bash shelluser \
    && echo 'shelluser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/shelluser

COPY . /home/shelluser/.config/ShellRc
RUN chown -R shelluser:shelluser /home/shelluser/.config

ENV LANG=C.UTF-8
ENV TERM=xterm-256color
WORKDIR /home/shelluser
ENTRYPOINT ["/home/shelluser/.config/ShellRc/docker/entrypoint.sh"]
CMD []
