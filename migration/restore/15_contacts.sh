#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8
export $(grep -v '^#' .env | xargs)

dir=/migration/zimbra/contacts
cd $dir

for file in $dir/*; do
  zip=$(basename "$file")
  acc=$(echo ${zip%.*})
  echo "Restoring contacts for $acc..."
  zmmailbox -z -m $acc -t 0 postRestURL "/?fmt=zip" $zip
done

echo "\nRestoring global address list"
galsync=$(zmprov -l gaa | grep -E ^galsync.*@)
zmmailbox -z -m $galsync -t 0 postRestURL "/?fmt=zip" ../_InternalGAL.zip

for acc in $(cat ../accounts/users.txt); do
  echo "Grant GAL's view access to $acc..."
  zmmailbox -z -m "$acc" cm --view contact -F# \
  "$galdir" $galsync /_InternalGAL
done
