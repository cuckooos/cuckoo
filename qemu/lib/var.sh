#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


if [ -z "$QEMU_DIR" ]
then
    echo "ERROR: QEMU directory (variable QEMU_DIR) has not been defined"
    exit 1
fi


if [ -z "$QEMU_ENV_NO" ]
then
    . "${QEMU_DIR}lib/env.sh"
fi


QEMU_ARCH="${QEMU_ARCH:=x86_64}"
QEMU_HD_TYPE="${QEMU_HD_TYPE:=virtio}"
QEMU_CPU_CORES=${QEMU_CPU_CORES:=4}
QEMU_CPU_THREADS=${QEMU_CPU_THREADS:=2}
QEMU_CPU_SOCKETS=${QEMU_CPU_SOCKETS:=1}
QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=1G}"
QEMU_CDROM_FILE="${QEMU_CDROM_FILE:=}"
QEMU_SMB_DIR="${QEMU_SMB_DIR:=}"
QEMU_FULL_SCREEN="${QEMU_FULL_SCREEN:=}"
QEMU_DAEMONIZE_NO="${QEMU_DAEMONIZE_NO:=}"
QEMU_ENABLE_KVM_NO="${QEMU_ENABLE_KVM_NO:=}"


case "$QEMU_ARCH" in
    x86_64 )
        QEMU_ARCH_BIN_FILE="$QEMU_ARCH"
        QEMU_CPU_MODEL="qemu64"
    ;;
    x86 )
        QEMU_ARCH_BIN_FILE="i386"
        QEMU_CPU_MODEL="qemu32"
    ;;
esac


QEMU_BIN_FILE="bin/qemu-system-${QEMU_ARCH_BIN_FILE}"
QEMU_TMP_DIR="${TMPDIR:=/tmp}/qemu/"
QEMU_LIB_DIR="${QEMU_DIR}lib/"
if [ -z "$QEMU_SYSTEM" ]
then
    QEMU_BIN_DIR="${QEMU_DIR}bin/"
    QEMU_BIN_ARCH_DIR="${QEMU_BIN_DIR}${QEMU_ARCH}/"
    QEMU_BIN_ARCH_OS_DIR="${QEMU_BIN_ARCH_DIR}${QEMU_OS}/"
    QEMU_BIN_ARCH_OS_VERSION_FILE="${QEMU_BIN_ARCH_OS_DIR}VERSION"
    QEMU_BIN_ARCH_OS_VERSION="$(cat "$QEMU_BIN_ARCH_OS_VERSION_FILE" 2> /dev/null)"

    if [ -z "$QEMU_BIN_ARCH_OS_VERSION" ]
    then
        QEMU_BIN_ARCH_OS_VERSION_DIR=""
    else
        QEMU_BIN_ARCH_OS_VERSION_DIR="${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION}/"
    fi
else
    QEMU_BIN_FILE="$(basename "$QEMU_BIN_FILE" 2> /dev/null)"
    QEMU_BIN_DIR="$(dirname "$(which "$QEMU_BIN_FILE")" 2> /dev/null)/"
    QEMU_BIN_ARCH_DIR=""
    QEMU_BIN_ARCH_OS_DIR=""
    QEMU_BIN_ARCH_OS_VERSION_FILE=""
    QEMU_BIN_ARCH_OS_VERSION="$("${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -version 2> /dev/null)"
    QEMU_BIN_ARCH_OS_VERSION_DIR=""
fi
QEMU_BUILD_DIR="${QEMU_DIR}build/"
QEMU_BUILD_ARCH_DIR="${QEMU_BUILD_DIR}${QEMU_ARCH}/"
QEMU_BUILD_ARCH_OS_FILE="${QEMU_BUILD_ARCH_DIR}${QEMU_OS}.sh"
QEMU_OPTS_EXT="${QEMU_OPTS_EXT:=}"
QEMU_TITLE="${QEMU_TITLE:=$QEMU_BIN_ARCH_OS_VERSION}"
