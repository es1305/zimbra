# Удаление писем с опциональной блокировкой.

## zm2spam.sh

Все письма по списку адресов из файла `in.txt` переносятся в папку Spam для последующей обработки zmtrainsa по расписанию, домен отправителя блокируется в Postfix (postfix_reject_sender).

### Настройка postfix_reject_sender

`nano /opt/zimbra/common/conf/postfix_reject_sender`

```
spamdomain1.com REJECT
spamdomain1.com REJECT
mydomain.tld REJECT
gooddomain.com OK
er REJECT
```
Свой домен запрещаем для блокировки писем с поддельным заголовком From, разрешаем нужные домены. Последнюю строчку удалите, если вы активно переписываетесь с контрагентами из Эритреи.

Далее внесём изменения в настройки Zimbra:

```bash
su - zimbra
zmprov ms `zmhostname` +zimbraMtaSmtpdSenderRestrictions "check_sender_access lmdb:/opt/zimbra/conf/postfix_reject_sender"
zmmtactl restart
```

и создадим базу для Postfix:

```bash
su - zimbra -c '/opt/zimbra/common/sbin/postmap /opt/zimbra/conf/postfix_reject_sender'
```

Теперь можно использовать скрипт.

## zm2trash.sh
Удаление писем по списку адресов из файла (`in.txt`). Удаляются из всех ящиков.
