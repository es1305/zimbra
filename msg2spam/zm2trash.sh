#!/bin/bash
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

input=in.txt
excl='(^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'

if [[ -e $input ]]; then
  i=$(cat $input | grep "@" | sort | uniq | wc -l)
  echo "Found $i addresses in file"
  cat $input | grep "@" | sort | uniq | while read addr; do
    for acct in $(zmprov -l gaa | grep -E -v $excl | sort); do
      echo "Searching in $acct for $addr"
      for msg in $(zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr" |
        awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "--" -e "^$" | awk '{ print $2 }'); do
          echo "Removing "$msg" from "$acct""
          /opt/zimbra/bin/zmmailbox -z -m $acct dm $msg
      done
    done
  done
:>$input
else
  echo "File $input not found!"
fi
