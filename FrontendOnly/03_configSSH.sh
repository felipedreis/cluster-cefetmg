#!/bin/bash
#troca porta do SSH e desabilita login como root

sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
if [ $? -ne 0 ];then
	echo "Ocorreu um erro na substituicao da porta do SSH" &>2;
	exit 1;
fi
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
if [ $? -ne 0 ];then
	echo "Ocorreu um erro ao desabilitar login SSH como usuário Root" &>2;
	exit 1;
fi

echo "SSH configurado"
