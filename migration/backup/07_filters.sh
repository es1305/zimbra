#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/filters
mkdir -p $dir && cd $dir
mkdir in out

for user in $(cat ../accounts/users.txt); do
  echo "Exporting incoming filters for $user"
  zmprov ga $user zimbraMailSieveScript | sed '1d' |
  sed 's/zimbraMailSieveScript: //g' > ./in/$user;
done

for user in $(cat ../accounts/users.txt); do
  echo "Exporting outgoing filters for $user"
  zmprov ga $user zimbraMailOutgoingSieveScript | sed '1d' |
  sed 's/zimbraMailOutgoingSieveScript: //g' > ./out/$user;
done

find $dir -type f -size 1 -delete
