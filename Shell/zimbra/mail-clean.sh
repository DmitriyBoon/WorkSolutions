#!/bin/bash

DOMAIN_NAME="mail.offenso.ru"     # имя домена почты
EMAIL=/tmp/email.list           # список email адресов, существующих в Zimbra
# список ID сообщений, которые мы хотим удалить
MESID=/tmp/mesid.list           
JUNKID=/tmp/Junkid.list
DRAFTS=/tmp/Draftsid.list

log=/var/log/mail-clean.log

/opt/zimbra/bin/zmprov -l gaa $DOMAIN_NAME | sort > $EMAIL  # выгружаем почту с Zimbra сортируем и записываем в фаил 

#узнаём  ID
cat $EMAIL
for i in $(cat $EMAIL);
 do
echo "$i"  
  /opt/zimbra/bin/zmmailbox -z -m $i s -l 999 in:Inbox | grep `date -d '-7 day' +%m/%d/%y`| sed -e "s/^\s\s*//" | sed -e "s/\s\s*/ /g" | cut -d" " -f2 > $MESID
  /opt/zimbra/bin/zmmailbox -z -m $i s -l 999 in:Junk | grep `date -d '-7 day' +%m/%d/%y`| sed -e "s/^ss*//" | sed -e "s/ss*/ /g" | cut -d" " -f2 > $JUNKID
  /opt/zimbra/bin/zmmailbox -z -m $i s -l 999 in:Drafts | grep `date -d '-7 day' +%m/%d/%y`| sed -e "s/^ss*//" | sed -e "s/ss*/ /g" | cut -d" " -f2 > $DRAFTS
# Удаляем inbox
  cat $MESID
  for a in $(cat $MESID | grep ^- | sed s/-//g )
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteMessage $a
  done
 
  for a in $(cat $MESID | sed /-/d)
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteConversation $a
  done
# Удаляем корзину
  for a in $(cat $JUNKID | grep ^- | sed s/-//g )
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteMessage $a
  done
 
  for a in $(cat $JUNKID | grep /-/d)
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteConversation $a
  done
# Удаляем черновики
  for a in $(cat $DRAFTS | grep ^- | sed s/-//g )
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteMessage $a
  done
 
  for a in $(cat $DRAFTS | grep /-/d)
  do
  /opt/zimbra/bin/zmmailbox -z -m $i deleteConversation $a
  done

RES=$?
if [ "$RES" == "0" ]; then echo `date` "[Ok]" >> $log ; else echo `date` "[Error]" >> $log ; fi
done
