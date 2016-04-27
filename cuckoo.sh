#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)/cuckoo}"


. "${CUCKOO_DIR}/lib/manage.sh" $@
