#!/bin/sh
wget -q -O /tmp/ISRG-X1.pem https://letsencrypt.org/certs/isrgrootx1.pem.txt || return 1
cat /tmp/ISRG-X1.pem >>/opt/zimbra/ssl/letsencrypt/chain.pem

if [ ! -d /opt/zimbra/ssl/zimbra/commercial ]; then
  mkdir -p /opt/zimbra/ssl/zimbra/commercial
else
  cp -f /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
  sed -i '/^$/d' /opt/zimbra/ssl/letsencrypt/*.pem
fi

chown -R zimbra:zimbra /opt/zimbra/ssl

if su - zimbra -c 'zmcertmgr verifycrt comm \
  /opt/zimbra/ssl/letsencrypt/privkey.pem \
  /opt/zimbra/ssl/letsencrypt/cert.pem \
  /opt/zimbra/ssl/letsencrypt/chain.pem'; then
  su - zimbra -c 'zmcertmgr deploycrt comm \
    /opt/zimbra/ssl/letsencrypt/cert.pem \
    /opt/zimbra/ssl/letsencrypt/chain.pem \
    && zmcontrol restart'
else
  exit 1
fi
