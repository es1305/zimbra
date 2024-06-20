#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/aliases
mkdir -p $dir && cd $dir

for user in $(cat ../accounts/users.txt); do
  echo "Exporting aliases for $user"
  zmprov ga $user | grep zimbraMailAlias |
  awk '{print $2}' > $user.txt
done

find $dir -type f -empty -delete
