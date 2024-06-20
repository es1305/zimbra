#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/filters

for file in $dir/in/*; do
  filter=$(cat "$file")
  acc=$(basename $file)
  echo "Restoring incoming filters for $acc..."
  zmprov ma $acc zimbraMailSieveScript "$filter"
done

for file in $dir/out/*; do
  filter=$(cat "$file")
  acc=$(basename $file)
  echo "Restoring outgoing filters for $acc..."
  zmprov ma $acc zimbraMailOutgoingSieveScript "$filter"
done
