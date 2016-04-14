#!/bin/bash

if [ $# != 2 ] && [ $# != 3 ];then
	echo "Utilizacao do script"
	echo -e "\t$0 assunto mensagem"
	echo -e "\t\tou"
	echo -e "\t$0 usuario assunto mensagem"
	exit
fi

if [ $# == 2 ];then
	for user in $(cat /etc/passwd | cut -d":" -f1);do
		if [ $(id -u $user) -ge 500 ] && [ $(id -u $user) != 65534 ];then
			echo -e $2 | mailx -s "$1" $user
		fi
	done
elif [ $# == 3 ];then
	echo -e $3 | mailx -s "$2" $1  
fi
