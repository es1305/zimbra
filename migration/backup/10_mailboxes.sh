#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/mailbox_data
mkdir -p $dir && cd $dir

for user in $(cat ../accounts/users.txt); do
  echo "Exporting mailbox $user"
  zmmailbox -z -m $user getRestURL '/?fmt=tgz' > $user.tgz
done
