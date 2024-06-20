#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/aliases
cd $dir

for user in $(cat ../accounts/users.txt); do
  if [ -f "$user.txt" ]; then
    echo "\nProcessing $user..."
    for alias in $(grep '@' $user.txt); do
      zmprov aaa $user $alias
      echo "Restored alias $alias"
    done
  fi
done
