#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/lists
mkdir -p $dir && cd $dir

zmprov gadl > distribution_lists.txt

for list in $(cat distribution_lists.txt); do
  echo "Exporting distribution list $list" 
  zmprov gdlm $list > $list.txt
done
