#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8
export $(grep -v '^#' .env | xargs)

dir=/migration/zimbra
cd $dir
mkdir report briefcase contacts

for user in $(cat accounts/users.txt); do
  echo "\nExporting account resourses for $user"

  zmmailbox -z -m $user gaf |
  tee $dir/report/$user.txt

  curl -s -u $admin:$pass \
  -o /$dir/briefcase/$user.zip \
  https://$oldserver:7071/home/$user/Briefcase?fmt=zip

  curl -s -u $admin:$pass \
  -o /$dir/contacts/$user.zip \
  https://$oldserver:7071/home/$user/Contacts?fmt=zip
done

galsync=$(zmprov -l gaa | grep -E ^galsync.*@)

echo "\nExporting global address list"

curl -s -u $admin:$pass \
  -o /$dir/_InternalGAL.zip \
  https://$oldserver:7071/home/$galsync/_InternalGAL?fmt=zip

find $dir -type f -empty -delete
