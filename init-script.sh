#/bin/bash

IP=$(ip addr show eth0 | grep -w inet | awk '{ print $2}' | cut -d "/" -f1)
HOSTNAME_SUFFIX=`echo -e "${IP}" | cut -d '.' -f 4`
hostname drill-${HOSTNAME_SUFFIX}

/lib/ufw/ufw-init start
ufw allow ssh
ufw disable
/lib/ufw/ufw-init stop

/bin/mkdir /var/run/sshd
/bin/chmod 0755 /var/run/sshd
/bin/sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
nohup /usr/sbin/sshd -D &

sed -i 's/localhost/zookeeper-service/g' /opt/drill/conf/drill-override.conf
sleep 5 ; /opt/drill/bin/drillbit.sh restart

while true; do sleep 5; done