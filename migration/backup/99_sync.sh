#!/bin/sh
export $(grep -v '^#' .env | xargs)

echo "\n  Use a command like the following first to copy SSH key:
  ssh-copy-id -i ~/.ssh/id_rsa.pub root@$newserver"

sleep 2
rsync -a --delete -e ssh --progress /migration/ root@$newserver:/migration/
