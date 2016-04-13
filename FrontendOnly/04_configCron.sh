#!/bin/bash
#coloca scripts no crontab
BASEDIR2=$(pwd);
BASEDIR="/root"

if [ -z $(crontab -l | grep "userExpiryMail") ];then
	crontab -l > /tmp/newcron
	echo "0 0 * * * $BASEDIR/Admin/userExpiryMail.sh" >> /tmp/newcron
	crontab < /tmp/newcron
	if [ $? -ne 0 ];then
		echo "Nao foi possivel adicionar o script userExpiryMail.sh ao cron" &>2;
		exit 1;
	fi
fi

if [ -z $(crontab -l | grep "alertQuota") ];then
	crontab -l > /tmp/newcron
	echo "0 0 * * * $BASEDIR/Admin/alertQuota.sh" >> /tmp/newcron
	crontab < /tmp/newcron
	if [ $? -ne 0 ];then
		echo "Nao foi possivel adicionar o script alertQuota.sh ao cron" &>2;
		exit 1;
	fi
fi

#cria parasta Scrips mas por em quando fica em /root/Admin
#copia scripts Admin para /root
cp -r $BASEDIR2/Admin /root/

crontab -l
echo "Scripts de cota e expiracao de conta habilitados no Cron"
