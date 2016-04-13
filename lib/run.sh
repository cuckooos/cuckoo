
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_OS_BIT=${CUCKOO_OS_BIT:=64}
CUCKOO_CPU_CORES=${CUCKOO_CPU_CORES:=4}
CUCKOO_CPU_THREADS=${CUCKOO_CPU_THREADS:=2}
CUCKOO_CPU_SOCKETS=${CUCKOO_CPU_SOCKETS:=1}
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"
CUCKOO_CURRENT_DIR="$(cd "$(dirname "$0")" && pwd -P)/"

QEMU_NAME="qemu"
QEMU_OS="${QEMU_OS:=linux}"
QEMU_ARCH="${QEMU_ARCH:=x86_64}"
QEMU_HD="${QEMU_HD:=virtio}"
QEMU_CDROM="${QEMU_CDROM:=}"
QEMU_NO_USB="${QEMU_NO_USB:=}"
QEMU_NO_DAEMONIZE="${QEMU_NO_DAEMONIZE:=}"
QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=1G}"
QEMU_VERSION="$(cat ${CUCKOO_CURRENT_DIR}${QEMU_NAME}/${QEMU_OS}/VERSION 2> /dev/null)"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}${QEMU_NAME}/${QEMU_OS}/${QEMU_VERSION}/"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}${QEMU_NAME}/"
QEMU_HD_DIR="${CUCKOO_CURRENT_DIR}hd/${CUCKOO_OS}/"
QEMU_BIN_FILE="bin/${QEMU_NAME}-system-${QEMU_ARCH}"
QEMU_OPTS="${QEMU_OPTS:=}"


##  ENV check

if [ -z "$QEMU_VERSION" ]
then
    echo "ERROR: QEMU version was not defined"
    echo "Please check file '${CUCKOO_CURRENT_DIR}${QEMU_NAME}/${QEMU_OS}/VERSION'"
    exit 1
fi

if [ ! -d "$QEMU_RUN_DIR" ]
then
    echo "ERROR: Directory '${QEMU_RUN_DIR}' does not exist"
    exit 1
fi

if [ ! -f "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
then
    echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
    exit 1
fi


##  Copy in TMP_DIR

"${QEMU_RUN_DIR}${QEMU_BIN_FILE}" -version > /dev/null
if [ ! $? -eq 0 ]
then
    mkdir -p "$QEMU_TMP_DIR"

    if [ -d "$QEMU_TMP_DIR" ]
    then
        cp -rf "$QEMU_RUN_DIR" "$QEMU_TMP_DIR"

        if [ -d "${QEMU_TMP_DIR}${QEMU_VERSION}/" ]
        then
            QEMU_RUN_DIR="${QEMU_TMP_DIR}${QEMU_VERSION}/"
            chmod -R 750 "$QEMU_RUN_DIR"

            if [ ! -x "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
            then
                echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
                exit 1
            fi
        else
            echo "ERROR: Directory '${QEMU_TMP_DIR}${QEMU_VERSION}/' does not exist"
            exit 1
        fi
    else
        echo "ERROR: Directory '${QEMU_TMP_DIR}' does not exist"
        exit 1
    fi
fi


##  QEMU run

# Bootloading and CDROM
QEMU_OPTS="${QEMU_OPTS} -boot order="
if [ -z "$QEMU_CDROM" ]
then
    QEMU_OPTS="${QEMU_OPTS}c"
else
    QEMU_OPTS="${QEMU_OPTS}d -cdrom ${QEMU_CDROM}"
fi

# Memory
QEMU_OPTS="${QEMU_OPTS} -m ${QEMU_MEMORY_SIZE} -balloon virtio"

# CPU
QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_NAME}${CUCKOO_OS_BIT} -smp cpus=$((${CUCKOO_CPU_CORES}*${CUCKOO_CPU_THREADS}*${CUCKOO_CPU_SOCKETS})),cores=${CUCKOO_CPU_CORES},threads=${CUCKOO_CPU_THREADS},sockets=${CUCKOO_CPU_SOCKETS}"

# Drive
for qemu_disk in $(ls $QEMU_HD_DIR)
do
    if [ -f "${QEMU_HD_DIR}${qemu_disk}" ]
    then
        QEMU_OPTS="${QEMU_OPTS} -drive media=disk,if=${QEMU_HD},index=${qemu_disk},file=${QEMU_HD_DIR}${qemu_disk}"
    fi
done

# Screen
QEMU_OPTS="${QEMU_OPTS} -vga std -sdl -display sdl"

# USB
if [ -z "$QEMU_NO_USB" ]
then
    QEMU_OPTS="${QEMU_OPTS} -usb -usbdevice tablet -device piix3-usb-uhci"
fi

# KVM
QEMU_OPTS="${QEMU_OPTS} -enable-kvm"

# Daemonize
if [ -z "$QEMU_NO_DAEMONIZE" ]
then
    QEMU_OPTS="${QEMU_OPTS} -daemonize"
fi

"${QEMU_RUN_DIR}${QEMU_BIN_FILE}" -name " Cuckoo [${CUCKOO_OS_BIT}] -- ${CUCKOO_OS} on ${QEMU_OS} " ${QEMU_OPTS}