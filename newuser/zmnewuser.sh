#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

galsync=$(zmprov -l gaa | grep -E ^galsync.*@)
galdir='/Общие контакты'

cat newusers.txt | while read -r acc; do
  echo "\nFound new account $acc..."
  zmprov ga $acc cn displayName givenName initials sn |
    tee /tmp/$acc.txt

  echo "Grant GAL's view access to $acc..."
  zmmailbox -z -m "$acc" cm --view contact -F# \
    "$galdir" $galsync /_InternalGAL

  echo "\nCreating signature template for $acc..."
  givenName=$(grep givenName: /tmp/$acc.txt | awk -F ': ' '{print $2}')
  sn=$(grep sn: /tmp/$acc.txt | awk -F ': ' '{print $2}')
  sign=$(cat ./template.html | sed "s/Иван Иванов/$givenName $sn/g")

  zmprov csig $acc "template" zimbraPrefMailSignatureHTML "$sign"
  rm /tmp/$acc.txt
done

:>newusers.txt
echo "Done!"
