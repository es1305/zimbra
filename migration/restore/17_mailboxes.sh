#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/mailbox_data
cd $dir

if [ -f ../failed.txt ]; then
  rm ../failed.txt
fi

for mailbox in $(cat ../accounts/users.txt); do
  echo "\nProcessing $mailbox..."
  zmmailbox -z -m $mailbox postRestURL "/?fmt=tgz&resolve=skip" $mailbox.tgz
  if [ $? -gt 0 ]; then
    echo $mailbox >> ../failed.txt
  else
    echo "Done"
  fi
done
