# К startup.sh
кидаем его в /etc/init.d
назначаем для него права:
   chmod 775 your_script_name
и помещаем в автозагрузку:
   update-rc.d your_script_name defaults

Всё! теперь его можно применить /etc/init.d/your_script_name start
после перезагрузки, естественно, правила тоже применятся.
