#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/signatures
mkdir -p $dir && cd $dir

for user in $(cat ../accounts/users.txt); do
  echo "\nExporting signature for $user"
  signtxt=$(zmprov ga $user zimbraPrefMailSignature | sed '1d')
  signhtml=$(zmprov ga $user zimbraPrefMailSignatureHTML | sed '1d')

  if [ -n "${signtxt}" ]; then
    echo "$signtxt" | sed 's/zimbraPrefMailSignature: //g' | tee $user
  elif [ -n "${signhtml}" ]; then
    echo "$signhtml" | sed 's/zimbraPrefMailSignatureHTML: //g' | tee $user
  else
    echo "User $user does not have a signature"
  fi

done
