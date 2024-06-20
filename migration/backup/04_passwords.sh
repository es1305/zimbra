#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/passwords
mkdir -p $dir && cd $dir

for user in $(cat ../accounts/users.txt); do
  echo "Exporting shadow password for $user"
  zmprov -l ga $user userPassword |
  grep userPassword |
  awk '{print $2}' > $user.shadow
done
