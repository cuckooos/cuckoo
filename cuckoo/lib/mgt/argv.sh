#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Options definition
cuckoo_args()
{
    ARGS_SHORT="s:irbqd:c:lxD:C:LXWUZwzQA:O:a:o:v:m:K:T:S:M:p:f:e:FNt:P:Vh"
    ARGS_LONG="setup:,install,run,qemu-build,qemu-delete,iso-download:,iso-copy:,iso-list,iso-delete,hd-download,hd-copy,hd-list,hd-delete,config-create,config-update,config-delete,desktop-create,desktop-delete,qemu-system,qemu-arch,qemu-os-name:,arch:,os-name:,dist-version:,memory-size:,cpu-cores:,cpu-threads:,cpu-sockets:,cdrom-add:,boot-cdrom:,boot-floppy:,smb-dir:,full-screen,no-daemonize,hd-type:,opts-add:,version,help"
    OPTS="$(getopt -o "${ARGS_SHORT}" -l "${ARGS_LONG}" -a -- "$@" 2>/dev/null)"
    if [ $? -gt 0 ]
    then
        cuckoo_error "Invalid option(s) value"
    fi

    eval set -- "$OPTS"

    # Options parsing
    while [ $# -gt 0 ]
    do
        case $1 in
        -- )
            shift 1
        ;;

    # Actions

        --setup | -s )
            CUCKOO_ACTION="setup"
            if [ -d "$2" ]
            then
                CUCKOO_SETUP_DIR="${2}/"
                QEMU_ACTION="copy"
            else
                cuckoo_error "Directory '$2' does not exist for setup"
            fi
            shift 2
        ;;
        --install | -i )
            CUCKOO_ACTION="install"
            shift 1
        ;;
        --run | -r )
            CUCKOO_ACTION="run"
            shift 1
        ;;
        --qemu-build | -b )
            QEMU_ACTION="build"
            shift 1
        ;;
        --qemu-delete | -q )
            QEMU_ACTION="delete"
            shift 1
        ;;
        --iso-download | -d )
            CUCKOO_ACTION="iso-setup"
            CUCKOO_ISO_FILE_PATH="$2"
            CUCKOO_ISO_FILE_NET="yes"
            shift 2
        ;;
        --iso-copy | -c )
            CUCKOO_ACTION="iso-setup"

            if [ -f "$2" ]
            then
                CUCKOO_ISO_FILE_PATH="$2"
                CUCKOO_ISO_FILE_NET=""
            else
                cuckoo_error "ISO file '$2' does not exist"
            fi
            shift 2
        ;;
        --iso-list | -l )
            CUCKOO_ACTION="iso-list"
            shift 1
        ;;
        --iso-delete | -x )
            CUCKOO_ACTION="iso-delete"
            shift 1
        ;;
        --hd-download | -D )
            CUCKOO_ACTION="hd-setup"
            CUCKOO_HD_FILE_PATH="$2"
            CUCKOO_HD_FILE_NET="yes"
            shift 2
        ;;
        --hd-copy | -C )
            CUCKOO_ACTION="hd-setup"

            if [ -f "$2" ]
            then
                CUCKOO_HD_FILE_PATH="$2"
                CUCKOO_HD_FILE_NET=""
            else
                cuckoo_error "HD file '$2' does not exist"
            fi
            shift 2
        ;;
        --hd-list | -L )
            CUCKOO_ACTION="hd-list"
            shift 1
        ;;
        --hd-delete | -X )
            CUCKOO_ACTION="hd-delete"
            shift 1
        ;;
        --config-create | -W )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="create"
            shift 1
        ;;
        --config-update | -U )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="update"
            shift 1
        ;;
        --config-delete | -Z )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="delete"
            shift 1
        ;;
        --desktop-create | -w )
            CUCKOO_ACTION="desktop"
            CUCKOO_DIST_VERSION_DESKTOP="create"
            shift 1
        ;;
        --desktop-delete | -z )
            CUCKOO_ACTION="desktop"
            CUCKOO_DIST_VERSION_DESKTOP="delete"
            shift 1
        ;;

    # Arguments

        --qemu-system | -Q )
            QEMU_ACTION="run-system"
            shift 1
        ;;
        --qemu-arch | -A )
            case "$2" in
                x86 | x86_64 )  # See QEMU_ARCH_LIST
                    QEMU_ARCH="$2"
                ;;
                * )
                    cuckoo_error "QEMU architecture '$2' does not supported"
                ;;
            esac
            shift 2
        ;;
        --qemu-os-name | -O )
            case "$2" in
                linux | macosx | windows )  # See QEMU_OS_LIST
                    QEMU_OS="$2"
                ;;
                * )
                    cuckoo_error "QEMU OS '$2' does not supported"
                ;;
            esac
            shift 2
        ;;
        --arch | -a )
            case "$2" in
                x86 | x86_64 )  # See CUCKOO_ARCH_LIST
                    CUCKOO_ARCH="$2"
                ;;
                * )
                    cuckoo_error "OS architecture '$2' does not supported"
                ;;
            esac
            shift 2
        ;;
        --os-name | -o )
            case "$2" in
                linux | netbsd | freebsd | openbsd | macosx | windows )  # See CUCKOO_OS_LIST
                    CUCKOO_OS="$2"
                ;;
                * )
                    cuckoo_error "OS '$2' does not supported"
                ;;
            esac
            shift 2
        ;;
        --dist-version | -v )
            CUCKOO_DIST_VERSION="$2"
            shift 2
        ;;
        --memory-size | -m )
            CUCKOO_MEMORY_SIZE="$2"
            shift 2
        ;;
        --cpu-cores | -K )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_CORES_MAX ]
            then
                CUCKOO_CPU_CORES=$2
            else
                cuckoo_error "Invalid value CPU cores '$2'"
            fi
            shift 2
        ;;
        --cpu-threads | -T )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_THREADS_MAX ]
            then
                CUCKOO_CPU_THREADS=$2
            else
                cuckoo_error "Invalid value CPU threads '$2'"
            fi
            shift 2
        ;;
        --cpu-sockets | -S )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_SOCKETS_MAX ]
            then
                CUCKOO_CPU_SOCKETS=$2
            else
                cuckoo_error "Invalid value CPU sockets '$2'"
            fi
            shift 2
        ;;
        --cdrom-add | -M )
            if [ -f "$2" ]
            then
                CUCKOO_ADD_CDROM_FILE="$2"
            else
                cuckoo_error "CDROM file '$2' does not exist (adding)"
            fi
            shift 2
        ;;
        --boot-cdrom | -p )
            if [ -f "$2" ]
            then
                CUCKOO_BOOT_CDROM_FILE="$2"
            else
                cuckoo_error "CDROM file '$2' does not exist"
            fi
            shift 2
        ;;
        --boot-floppy | -f )
            if [ -f "$2" ]
            then
                CUCKOO_BOOT_FLOPPY_FILE="$2"
            else
                cuckoo_error "Floppy Disk file '$2' does not exist"
            fi
            shift 2
        ;;
        --smb-dir | -e )
            if [ -d "$2" ]
            then
                CUCKOO_SMB_DIR="$2"
            else
                cuckoo_error "SMB directory '$2' does not exist"
            fi
            shift 2
        ;;
        --full-screen | -F )
            CUCKOO_FULL_SCREEN="yes"
            shift 1
        ;;
        --no-daemonize | -N )
            CUCKOO_DAEMONIZE_NO="yes"
            shift 1
        ;;
        --hd-type | -t )
            case "$2" in
                ide | scsi | virtio )
                    CUCKOO_HD_TYPE="$2"
                ;;
                * )
                    cuckoo_error "HD type '$2' does not supported"
                ;;
            esac
            shift 2
        ;;
        --opts-add | -P )
            CUCKOO_OPTS_EXT="$2"
            shift 2
        ;;
        --version | -V )
            CUCKOO_ENV_NO="yes"

            cuckoo_variables

            echo "Cuckoo version: $(cat "${CUCKOO_ETC_VERSION_FILE}")"
            exit 0
        ;;
        --help | -h )
            cuckoo_help
            exit 0
        ;;
        * )
            cuckoo_error "Invalid option(s)"
        ;;
        esac
    done
}
