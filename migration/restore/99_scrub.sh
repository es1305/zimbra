#!/bin/sh
su - zimbra -c 'zmcontrol stop'
chown -R zimbra:zimbra /opt/zimbra
/opt/zimbra/libexec/zmfixperms --extended --verbose
su - zimbra -c 'zmcontrol start'
