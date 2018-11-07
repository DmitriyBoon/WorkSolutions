#!/bin/sh

IPT="/sbin/iptables"

start_fw()
{

    # Сбросить правила и удалить цепочки.
    $IPT -F
    $IPT -X
    
    # Тут пишем наши правила для iptables.
    $IPT -P INPUT ACCEPT
    $IPT -P FORWARD ACCEPT
    $IPT -P OUTPUT ACCEPT
    
}


case "$1" in
start)  echo -n "Starting firewall: iptables"
        start_fw
        echo "." 
        ;;
stop)   echo -n "Stopping firewall: iptables"
        iptables -F
        iptables -X
        echo "."
        ;;
save)   echo -n "Saving firewall: iptables"
        iptables-save > /etc/iptables.up.rules
        echo "."
        ;;    
restart) echo -n "Restarting firewall: iptables"
        iptables -F
        iptables -X
        start_fw
        echo "."
        ;;
reload|force-reload) echo -n "Reloading configuration files for firewall: iptables"
        echo "."
        ;;
*)      echo "Usage: /etc/init.d/rc.iptables start|stop|restart|reload|force-reload"
        exit 1 
        ;;
esac
exit 0
