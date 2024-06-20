#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/signatures
cp template.html $dir
cd $dir

for file in $dir/*; do
  sign=$(cat $file)
  acc=$(basename $file)

  echo "\nRestoring signature for $acc..."

  if grep -q "<div>" $file; then
    zmprov csig $acc "default" zimbraPrefMailSignatureHTML "$sign"
  else
    zmprov csig $acc "default" zimbraPrefMailSignature "$sign"
  fi

  echo "Assign this signature for default and forward mail..."
  id=$(zmprov ga $acc zimbraSignatureId | grep -v '#' | awk '{print $2}')
  zmprov ma $acc zimbraPrefDefaultSignatureId $id
  zmprov ma $acc zimbraPrefForwardReplySignatureId $id
done

for acc in $(cat ../accounts/users.txt); do
  givenName=$(grep givenName: ../details/$acc.txt | awk -F ': ' '{print $2}')
  sn=$(grep sn: ../details/$acc.txt | awk -F ': ' '{print $2}')
  sign=$(cat $dir/template.html | sed "s/Иван Иванов/$givenName $sn/g")

  echo "\nCreating signature template for $acc..."
  zmprov csig $acc "template" zimbraPrefMailSignatureHTML "$sign"
done
