#!/usr/bin/env bash

log='/var/log/syslog'

tail -f "$log" | \
while read line ; do
        string=`printf "$line" | awk -F ':' '{ print$4 }'`
        (
                IFS='|'
                array=( $string )
                username="${array[0]// }"
                state=${array[2]}
                action=${array[4]}
                file=${array[5]}

                if [[ -f "/mnt/data/folders/test/$file" && "$username" == "test" && "$state" == "open" && "$file" != "." && "$file" != Просмотрено.* && "$action" == "r" ]] ; then
                        while true ; do
                                search=`smbstatus -L | grep "$file"`
                                if [[ "$search" ]] ; then
                                        printf "FAIL ZANYAT, POVTORYAU...\n"
                                        continue
                                else
                                        printf "$file was renamed to Просмотрено.$file\n" >> log.file
                                        mv /mnt/data/folders/test/"$file" /mnt/data/folders/test/"Просмотрено.$file"
                                        break
                                fi
                        done
                fi
        )
done
