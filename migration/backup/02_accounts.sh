#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8
export $(grep -v '^#' .env | xargs)

dir=/migration/zimbra/accounts
mkdir -p $dir && cd $dir

excl='(^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'

zmprov gaaa | sort | grep -v $admin | tee admins.txt
zmprov -l gaa | sort | grep -E -v $excl | tee users.txt
