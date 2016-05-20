#!/bin/bash
#coloca scripts no crontab
BASEDIR="/root"

if [ -z $(crontab -l | grep "userExpiryMail") ];then
	crontab -l > /tmp/newcron
	echo "0 0 * * * $BASEDIR/AdminScripts/userExpiryMail.sh" >> /tmp/newcron
	crontab < /tmp/newcron
	if [ $? -ne 0 ];then
		echo "Nao foi possivel adicionar o script userExpiryMail.sh ao cron" &>2;
		exit 1;
	fi
fi

if [ -z $(crontab -l | grep "alertQuota") ];then
	crontab -l > /tmp/newcron
	echo "0 0 * * * $BASEDIR/AdminScripts/alertQuota.sh" >> /tmp/newcron
	crontab < /tmp/newcron
	if [ $? -ne 0 ];then
		echo "Nao foi possivel adicionar o script alertQuota.sh ao cron" &>2;
		exit 1;
	fi
fi

mkdir -p /root/AdminScripts
#cria parasta Scrips mas por em quando fica em /root/Admin
#copia scripts Admin para /root
cp $BASE_DIR/AdminScripts/* /root/AdminScripts

crontab -l
echo "Scripts de cota e expiracao de conta habilitados no Cron"
