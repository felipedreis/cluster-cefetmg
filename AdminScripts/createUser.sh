#!/bin/bash

if [ ! $# -eq 3 || ! $# -eq 1 ];then
	echo "$0 usuario email data_de_expiracao(aaaa-mm-dd)"
	echo -e "\t\t\tou"
	echo "$0 lista_de_usuarios"
	exit
fi

if [ $# -eq 3 ];then
	#Adiciona usuario (-e $3 define a data de expiracao da conta) ($1 nome do usuario)
	useradd -e $3 $1
	userkey=$(mkpasswd)
	echo ${userkey} | passwd --stdin $1
	chage -d 0 $1

	#Adiciona usuario ao grupo default
	usermod -a -G cluster $1

	#Adiciona alias (usuario/email)
	echo -e "$1:\t$2" >> /etc/aliases

	#Recarrega os alias
	newaliases
	service postfix reload

	#Define a cota. 4GB soft - 5GB hard
	setquota $1 4194304 5242880 0 0 /state/partition1

	#Copia o sbatch para o home do usuario
	cp /root/script /export/home/$1
	chown $1:$1 /export/home/$1/script

	#cotas de BD

	echo -e "Usuario: $1 \nSenha: $userkey" | mailx -s "Usuario_Cluster" $1

	rocks sync users

	sacctmgr add user $1 DefaultAccount=cluster
	rocks sync config
	scontrol reconfigure
else
	IFS=$'\n'
	for line in $(cat $1);do
		user=$(echo $line | cut -d"," -f1)
		email=$(echo $line | cut -d"," -f2)
		expDate=$(echo $line | cut -d"," -f3)

		useradd -e $3 $1
		userkey=$(mkpasswd)
		echo ${userkey} | passwd --stdin $1
		chage -d 0 $1

		usermod -a -G cluster $1

		echo -e "$1:\t$2" >> /etc/aliases
		newaliases
		service postfix reload

		setquota $1 4194304 5242880 0 0 /state/partition1

		cp /root/script /export/home/$1
		chown $1:$1 /export/home/$1/script

		#cotas de BD

		echo -e "Usuario: $1 \nSenha: $userkey" | mailx -s "Usuario_Cluster" $1

		sacctmgr add user $1 DefaultAccount=cluster
	done

	rocks sync users

	rocks sync config
	scontrol reconfigure
fi