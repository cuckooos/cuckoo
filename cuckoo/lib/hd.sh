
if [ ! -d "$CUCKOO_HD_ARCH_OS_CLEAN_DIR" ]
then
    echo "ERROR: Directory '${CUCKOO_HD_ARCH_OS_CLEAN_DIR}' does not exist"
    exit 1
fi


if [ -z "$CUCKOO_DIST_VERSION" ]
then
    for hd_file in $(ls "$CUCKOO_HD_ARCH_OS_DIR")
    do
        if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${hd_file}" ]
        then
            rm -f "${CUCKOO_HD_ARCH_OS_DIR}${hd_file}"
        fi
    done
else
    rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
    mkdir -p "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
fi


for hd_file in $(ls "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}")
do
    if [ -f "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" ]
    then
        cp "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}"
    fi
done
