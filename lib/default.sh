
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_ARCH="${CUCKOO_ARCH:=x86_64}"
CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE:=}"
if [ ! -z "$CUCKOO_ISO_FILE" ]
then
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        CUCKOO_DIST_VERSION="$CUCKOO_ISO_FILE"
        CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
    fi
    CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE}.iso"
fi
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=}"
if [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION_DIR=""
else
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi
CUCKOO_CPU_CORES=${CUCKOO_CPU_CORES:=4}
CUCKOO_CPU_THREADS=${CUCKOO_CPU_THREADS:=2}
CUCKOO_CPU_SOCKETS=${CUCKOO_CPU_SOCKETS:=1}
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"
case $CUCKOO_ARCH in
    x86_64 )
        QEMU_CPU_MODEL="qemu64"
    ;;
    * )
        QEMU_CPU_MODEL="qemu32"
    ;;
esac


QEMU_OS="${QEMU_OS:=linux}"
QEMU_ARCH="${QEMU_ARCH:=x86_64}"
QEMU_HD_TYPE="${QEMU_HD_TYPE:=virtio}"
QEMU_CDROM_FILE="${QEMU_CDROM_FILE:=}"
QEMU_SMB_DIR="${QEMU_SMB_DIR:=}"
QEMU_NO_USB="${QEMU_NO_USB:=}"
QEMU_FULL_SCREEN="${QEMU_FULL_SCREEN:=}"
QEMU_NO_DAEMONIZE="${QEMU_NO_DAEMONIZE:=}"
QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=1G}"
QEMU_OPTS="${QEMU_OPTS:=}"