#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8
export $(grep -v '^#' .env | xargs)

dir=/migration/zimbra/domains
mkdir -p $dir && cd $dir

zmprov gad | sort | grep -v "$domain" | tee domains.txt
