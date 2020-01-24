# Environmental variable fixes for XDG Base Directories for programs 

# TODO
# npm, wget

# CCache
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME"/ccache.config
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine

# Gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# libdvdcss
export DVDCSS_CACHE="$XDG_DATA_HOME"/dvdcss

# libice
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority

# NVIDIA/CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

# python-pylint
export PYLINTHOME="$XDG_CACHE_HOME"/pylint

# xorg-xauth
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority

