# Настройки fail2ban для Zimbra

## Zimbra
Для отображения в логах реальных IP (особенно если у вас прокси вынесен отдельно), рекомендуется выполнить

```bash
zmprov mcf +zimbraMailTrustedIP 127.0.0.1
zmprov mcf +zimbraMailTrustedIP ALL_ZIMBRA_OR_PROXY_IP
```

## Fail2ban
Для локальных настроек используется файл `jail.local` или папка `jail.d`.
Мой файл `jail.local` с некоторыми пояснениями:

```bash
bantime  = 360m
findtime = 30m
maxretry = 3

ignoreip = 127.0.0.0/8 ZIMBRA_OR_PROXY_IP/32 YOUR_LOCAL_SUBNET ETC...
```

Здесь всё понятно. Срок блокировки, временной диапазон для поиска ошибок в логах, количество ошибок до блокировки.
Никогда не блокировать следующие адреса: localhost, адреса Zimbra (mailbox & proxy), локальную подсеть, что-то ещё.

```bash
[sshd]
enabled  = true
port     = ssh
logpath  = %(sshd_log)s
backend  = %(sshd_backend)s
maxretry = 1
```

Встроенное правило для ssh. Я использую [tcpwrapper](https://www.securitylab.ru/glossary/tcp_wrapper_/) для ограничения доступа к ssh только с определённых адресов, поэтому блокировка происходит после 1-й попытки (`maxretry = 1`).

```bash
[postfix]
enabled = true
mode    = aggressive
port    = smtp,smtps,submission
logpath = %(postfix_log)s
backend = %(postfix_backend)s

[postfix-sasl]
enabled = true
filter  = postfix[mode=auth]
port    = smtp,smtps,submission,imap,imaps,pop3,pop3s
logpath = %(postfix_log)s
backend = %(postfix_backend)s
```

Так же встроенные фильтры fail2ban. 2-й фильтр выделен для контроля попыток авторизации SASL. Если вас активно атакуют (идёт подбор паролей), добавьте `maxretry = 1` и выполните `systemctl fail2ban reload` для применения настроек. (Однажды я забыл вернуть эту настройку обратно. Никто и не заметил...)

```bash
[zimbra-web]
enabled  = true
port     = http,https
logpath  = /opt/zimbra/log/mailbox.log
```

Это правило контролирует попытки авторизации в web-интерфейсе Zimbra. Фильтр нужно скопировать в папку `/etc/fail2ban/filter.d`. Те же рекомендации для противодействия bruteforce attack.

```bash
[recidive]
enabled   = true
logpath   = /var/log/fail2ban.log
banaction = %(banaction_allports)s
bantime   = 1w
findtime  = 1d
maxretry  = 2
```

Правило для блокирования рецидивистов на длительный срок. Для его использования необходимо увеличить срок очистки базы `dbpurgeage` в `fail2ban.conf`:

```bash
dbpurgeage = 648000
```

И проследите, чтобы `loglevel` не был `DEBUG`.

### Links
* https://github.com/fail2ban/fail2ban
* https://blog.zimbra.com/2022/08/configuring-fail2ban-on-zimbra/
