# Zimbra, настройки для Postfix

Общие рекомендации по настройке Postfix (не только для Zimbra) сводятся к ограничению Trusted Networks локальными адресами сервера и запрету отправки сообщений без авторизации. Open Relay давно уже не используется как и устаревшие протоколы защиты транспортного уровня (SSL, TLSv<1.2) в новых версиях Zimbra.

## Iptables

Для серверов Zimbra, выполняющих попутно роль шлюза в Internet рекомендуются следующие настройки iptables, запрещающие прямую отправку почты с компьютеров из локальной сети:

```bash
iptables -A OUTPUT -d 127.0.0.1 -p tcp -m tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 25 -m owner --gid-owner mail -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 25 -m owner --uid-owner postfix -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 25 -m owner --uid-owner root -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 25 -j REJECT --reject-with icmp-port-unreachable
```

## Изменение настроек Postfix rejects

Для получения текущего списка ограничений Postfix можно выполнить

```bash
su - zimbra
clear; echo "Server specific flags:"; zmprov gs `zmhostname` | grep reject; echo -e "\nGeneral Settings flags:"; zmprov gacf | grep reject
```

Для изменения настроек исползуется команда `zmprov mcf +ПАРАМЕТР ЗНАЧЕНИЕ`. Например:

```bash
zmprov mcf +zimbraMtaRestriction reject_unauth_destination
```

Рекомендуемые настройки проверок для Postfix:

```bash
zimbraMtaRestriction: reject_invalid_helo_hostname
zimbraMtaRestriction: reject_non_fqdn_helo_hostname
zimbraMtaRestriction: reject_non_fqdn_sender
zimbraMtaRestriction: reject_unauth_destination
zimbraMtaRestriction: reject_unknown_client_hostname
zimbraMtaRestriction: reject_unknown_helo_hostname
zimbraMtaRestriction: reject_unknown_reverse_client_hostname
zimbraMtaRestriction: reject_unknown_sender_domain
zimbraMtaRestriction: reject_unlisted_recipient
zimbraMtaSmtpdClientRestrictions: reject_unauth_pipelining
zimbraMtaSmtpdDataRestrictions: reject_unauth_pipelining
zimbraMtaSmtpdSenderRestrictions: check_sender_access lmdb:/opt/zimbra/conf/postfix_reject_sender
```

Часть настроек можно активировать через админку, настройка `postfix_reject_sender` описана [здесь](https://github.com/es1305/zimbra/tree/main/msg2spam#настройка-postfix_reject_sender).

## Некоторые дополнительные настройки

### Запрет отправки заголовка X-Mailer

`zmprov mcf zimbraSmtpSendAddMailer FALSE`

### Запрет отправки заголовка X-Originating-IP

`zmprov mcf zimbraSmtpSendAddOriginatingIP FALSE`

### Автообновление правил Spamassassin

```bash
zmlocalconfig -e antispam_enable_rule_updates=true
zmlocalconfig -e antispam_enable_restarts=true
zmlocalconfig -e antispam_enable_rule_compilation=true
zmamavisdctl restart
zmmtactl restart
```

### Links
* https://www.postfix.org/postconf.5.html
* https://wiki.zimbra.com/wiki/FromName_Spoofing
