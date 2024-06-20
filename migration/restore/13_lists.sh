#!/bin/sh
export PATH="/opt/zimbra/bin:$PATH"
export LC_CTYPE=ru_RU.UTF-8

dir=/migration/zimbra/lists
cd $dir

for list in $(cat distribution_lists.txt); do
  echo "\nProcessing $list..."
  zmprov cdl $list
  echo "$list is imported"
done

for list in $(cat distribution_lists.txt); do
  echo "\nAdding members to the list $list..."
  for mmbr in $(grep -v '#' $list.txt | grep '@'); do
    zmprov adlm $list $mmbr
    echo "$mmbr"
  done
done
