#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/mailbox_data
cd $dir

NORMAL=''
RED=''

if tty -s; then
  NORMAL="$(tput sgr0)"
  RED="$(tput setaf 1)"
fi

cat ../failed.txt | while read -r mailbox; do
  echo "Processing $mailbox..."
  zmmailbox -z -m $mailbox postRestURL "/?fmt=tgz&resolve=skip" $mailbox.tgz
  if [ $? -gt 0 ]; then
    echo "${RED}We need another iteration\nRun this script again!${NORMAL}"
  else
    sed -i "/$mailbox/d" ../failed.txt
    echo "Done"
  fi
done
