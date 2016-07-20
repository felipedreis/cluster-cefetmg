#!/bin/bash

if [ ! $# -eq 4 ] && [ ! $# -eq 1 ];then
	echo "$0 usuario email data_de_expiracao(aaaa-mm-dd) account"
	echo -e "\t\t\tou"
	echo "$0 lista_de_usuarios"
	exit
fi

if [ $# -eq 4 ];then

	user=$1
	email=$2
	expDate=$3
	account=$4
	#Adiciona usuario (-e $3 define a data de expiracao da conta) ($1 nome do usuario)
	useradd -e $expDate $user
	userkey=$(mkpasswd)
	echo ${userkey} | passwd --stdin $user
	chage -d 0 $user

	#Adiciona usuario ao grupo default
	usermod -a -G cluster $user

	#Adiciona alias (usuario/email)
	echo -e "$user:\t$email" >> /etc/aliases

	#Recarrega os alias
	newaliases
	service postfix reload

	#Define a cota. 4GB soft - 5GB hard
	setquota $user 4194304 5242880 0 0 /state/partition1

	#Copia o sbatch para o home do usuario
	cp /root/script /export/home/$user
	chown $user:$user /export/home/$user/script

	#Arquivo de configuracao para o Blast
	echo "[NCBI]
	Data=/opt/bio/ncbi/data/

	[mpiBLAST]
	Shared=$BLASTDB
	Local=$BLASTDB" > /export/$user/.ncbirc
	chown $user:$user /export/$user/.ncbirc

	#Diretório temporário para o t_coffee
	mkdir -p /export/$user/.t_coffee/tmp
	chown -R $user:$user /export/$user/.t_coffee

	echo -e "Usuario: $user \nSenha: $userkey" | mailx -s "Usuario_Cluster" $user

	rocks sync users

	sacctmgr add user $user Account=$account Fairshare=parent
	rocks sync config
	scontrol reconfigure
else
	IFS=$'\n'
	for line in $(cat $1);do
		user=$(echo $line | cut -d"," -f1)
		email=$(echo $line | cut -d"," -f2)
		expDate=$(echo $line | cut -d"," -f3)
		account=$(echo $line | cut -d"," -f4)

		useradd -e $expDate $user
		userkey=$(mkpasswd)
		echo ${userkey} | passwd --stdin $user
		chage -d 0 $user

		usermod -a -G cluster $user

		echo -e "$user:\t$email" >> /etc/aliases
		newaliases
		service postfix reload

		setquota $user 4194304 5242880 0 0 /state/partition1

		cp /root/script /export/home/$user
		chown $user:$user /export/home/$user/script

		#Arquivo de configuracao para o Blast
		echo "[NCBI]
		Data=/opt/bio/ncbi/data/

		[mpiBLAST]
		Shared=$BLASTDB
		Local=$BLASTDB" > /export/$user/.ncbirc
		chown $user:$user /export/$user/.ncbirc

		#Diretório temporário para o t_coffee
		mkdir -p /export/$user/.t_coffee/tmp
		chown -R $user:$user /export/$user/.t_coffee

		echo -e "Usuario: $user \nSenha: $userkey" | mailx -s "Usuario_Cluster" $user

		sacctmgr add user $user Account=$account Fairshare=parent
	done

	rocks sync users

	rocks sync config
	scontrol reconfigure
fi
