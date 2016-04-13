
CUCKOO_OS=""
CUCKOO_OS_BIT=""
CUCKOO_DIR=""


case $(uname -m) in
    x86_64 | amd64 )
        CUCKOO_OS_BIT=64
    ;;
    i386 )
        CUCKOO_OS_BIT=32
    ;;
esac

if [ -z "$CUCKOO_OS_BIT" ]
then
    echo "ERROR: Current system architecture has not been supported"
    exit 1
fi


case $(uname -s) in
    Linux )
        CUCKOO_OS="linux"
        CUCKOO_DIR="$(realpath "$(readlink -f "$(dirname "$0")")")"
    ;;
    Darwin )
        CUCKOO_OS="macosx"
        CUCKOO_DIR="$(cd "$(dirname "$0")" && pwd -P)"
    ;;
    NetBSD )
        CUCKOO_OS="netbsd"
        CUCKOO_DIR="$(readlink -f "$(dirname "$0")")"
    ;;
    OpenBSD )
        CUCKOO_OS="openbsd"
        CUCKOO_DIR="$(readlink -f "$(dirname "$0")")"
    ;;
    FreeBSD )
        CUCKOO_OS="freebsd"
        CUCKOO_DIR="$(readlink -f "$(dirname "$0")")"
    ;;
esac

if [ -z "$CUCKOO_OS" ]
then
    echo "ERROR: Current system does not supported"
    exit 1
fi

if [ -z "$CUCKOO_DIR" ]
then
    echo "ERROR: Current directory has not been defined"
    exit 1
fi


sh "${CUCKOO_DIR}/${CUCKOO_OS_BIT}/${CUCKOO_OS}-$(basename "$0")"