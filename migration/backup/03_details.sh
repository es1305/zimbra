#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/details
mkdir -p $dir && cd $dir

for user in $(cat ../accounts/users.txt); do
  echo "Exporting account details for $user"
  zmprov ga $user cn displayName givenName initials sn |
  tee $user.txt
done
