#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/domains
cd $dir

for domain in $(cat domains.txt); do
  echo "\nAdding the domain $domain..."
  zmprov cd $domain zimbraAuthMech zimbra
done
