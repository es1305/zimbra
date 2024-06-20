#!/bin/bash
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

input=in.txt
excl='(^spam\..*@|^ham\..*@|^virus-quarantine.*@|^galsync.*@)'
gd='(mail.ru|list.ru|inbox.ru|bk.ru|gmail.com|yandex|rambler|outlook.com|msn.com|live.com|icloud.com|me.com)'

if [[ -e $input ]]; then
  i=$(cat $input | grep "@" | sort | uniq | wc -l)
  echo "Found $i spammer's addresses in file"
  cat $input | grep "@" | sort | uniq | while read addr; do
    for acct in $(zmprov -l gaa | grep -E -v $excl | sort); do
      echo "Searching in $acct for $addr"
      for msg in $(zmmailbox -z -m "$acct" s -l 999 -t message "from:$addr" |
        awk '{ if (NR!=1) {print}}' | grep -v -e Id -e "--" -e "^$" | awk '{ print $2 }'); do
        echo "Moving "$msg" from "$acct" to Junk"
        zmmailbox -z -m $acct mm $msg /Junk
      done
    done
  done
  cat /opt/zimbra/conf/postfix_reject_sender >/tmp/list_tmp
  cat $input | awk -F'@' '{print $2}' | sort | uniq | awk '{print $0" REJECT"}' >>/tmp/list_tmp
  cat /tmp/list_tmp | sort | uniq | grep -E -v $gd >/opt/zimbra/conf/postfix_reject_sender
  su - zimbra -c '/opt/zimbra/common/sbin/postmap /opt/zimbra/conf/postfix_reject_sender'
  :>$input
  echo "Finished!"
else
  echo "File $input not found!"
fi
