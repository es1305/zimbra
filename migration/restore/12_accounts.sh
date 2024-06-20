#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra
cd $dir

for i in $(cat accounts/users.txt); do
  echo "\nProcessing $i"
  pass=$(cat /dev/urandom | base64 | head -c 8)
  cn=$(grep cn: details/$i.txt | awk -F ': ' '{print $2}')
  displayName=$(grep displayName: details/$i.txt | awk -F ': ' '{print $2}')
  givenName=$(grep givenName: details/$i.txt | awk -F ': ' '{print $2}')
  initials=$(grep initials: details/$i.txt | awk -F ': ' '{print $2}')
  sn=$(grep sn: details/$i.txt | awk -F ': ' '{print $2}')
  shadowpass=$(cat passwords/$i.shadow)
  echo "Restoring the user..."
  zmprov ca $i "$pass" cn "$cn" displayName "$displayName" givenName "$givenName" initials "$initials" sn "$sn"
  echo "Recovering a password..."
  zmprov ma $i userPassword "$shadowpass"
done

echo "\nRestoration of admin rights..."
for i in $(cat accounts/admins.txt); do
  zmprov ma $i zimbraIsAdminAccount TRUE
  echo "The user $i now has admin rights"
done
