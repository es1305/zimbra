# Installing a Letsencrypt certificate for Zimbra

## TL;DR
Используется [ACME Shell script](https://acme.sh) и метод подтверждения на сервере DNS [Cloudflare](https://cloudflare.com).

## Установка acme.sh 

```bash
apt install socat

curl https://get.acme.sh | sh -s email=es1305@gmail.com
```
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

## Выпуск и установка сертификата
Для взаимодействи с API Cloudflare необходимы [Api Token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) или [Global API key](https://developers.cloudflare.com/fundamentals/api/get-started/keys/). Их нужно добавить в переменные окружения:

```bash
export CF_Key="04c5##############################"
export CF_Email="admin@domain.tld"
```
(для Global API key)

### Получение сертификата (domain & wildcard):

```bash
~/.acme.sh/acme.sh --issue --dns dns_cf -d domain.tld -d *.domain.tld
```

### Установка:

```bash
mkdir -p /opt/zimbra/ssl/letsencrypt \
~/.acme.sh/acme.sh --install-cert -d domain.tld \
--preferred-chain "ISRG Root X1" \
--cert-file /opt/zimbra/ssl/letsencrypt/cert.pem  \
--key-file /opt/zimbra/ssl/letsencrypt/privkey.pem  \
--ca-file /opt/zimbra/ssl/letsencrypt/chain.pem \
--reloadcmd "/root/scripts/zmcert.sh"
```
(проверьте путь до скрипта в последней строке)
