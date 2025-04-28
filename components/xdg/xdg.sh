# Environmental variable fixes for XDG Base Directories for programs 

# TODO
# wget, xorg-auth

# Breezy
export BRZ_LOG="$XDG_CACHE_HOME/breezy/brz.log"
export BRZ_HOME="$XDG_CONFIG_HOME/breezy"

# Cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# CCache
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME"/ccache.config
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine

# GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# GTK
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# KDE4
export KDEHOME="$XDG_CONFIG_HOME"/kde

# Leiningen
export LEIN_HOME="$XDG_DATA_HOME"/lein

# libdvdcss
export DVDCSS_CACHE="$XDG_DATA_HOME"/dvdcss

# libice
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority

# mednafen
export MEDNAFEN_HOME="$XDG_CONFIG_HOME/mednafen"

# mplayer
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"

# nuget
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages

# NVIDIA/CUDA
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

# nvm
export NVM_DIR="$XDG_DATA_HOME"/nvm

# python-pylint
export PYLINTHOME="$XDG_CACHE_HOME"/pylint

