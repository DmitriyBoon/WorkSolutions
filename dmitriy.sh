#!/bin/bash

MLOCK=/var/tmp/mlock  
LFM=$(ps aux | grep smb-change-file | wc -l)
killfile() {
if [ $LFM -eq 0 ] 
then
exit
else
rm -f $MLOCK
fi
}
killfile
if [ -f $MLOCK ]; then
 echo Job is already running\!
 exit 
fi
touch $MLOCK

#log=`tail -f /var/log/syslog` 
journalctl --since '-5min' > /home/zigota/flist # формируем лог за последние 5 минут
user="test" # пользователь, пока не используем 
log=/home/zigota/flist  # путь до лога, формируется journalctl -u  smbd > /home/zigota/flist
dir=/mnt/data/folders/test/test # путь до папки, для наблюдения
 
cd "$dir" 
#$log
while read open_file ; do
         if [[ "$open_file" == Просмотрено.* ]] ; then
          echo "Файл был открыт"
         else
           echo "проверяем $open_file"
           if [  -f "$open_file" ]  ; then
        mv "$open_file" "Просмотрено.$open_file"
     fi
    fi
done < <(cut $log -d "|" -f1,3,5,6 | cut -d ":"  -f4 | sort -u | grep "open|r|" | grep test | awk -F "|" '{print $4}' | sed 's/~$.//g' )
