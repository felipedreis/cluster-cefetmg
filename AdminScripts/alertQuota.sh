#!/bin/bash

#Colocar este script no cron. Verifica se o usuario excedeu a cota em disco.

for user in $(cat /etc/passwd | cut -d":" -f1);do
	if [ $(id -u $user) -ge 500 ];then
		quota -u $user | awk -v USER=${user} '{
			if (NR == 3){
				#print USER
				#print int($2);
				if(int($2) >= $3 && int($2) < $4){
					cmd="echo \"Aviso: espaco em disco proximo do limite maximo.\" | mailx -s Cota "USER;
					#print cmd;
					system(cmd);
				}else if(int($2) == $4){
					cmd="echo \"Voce atingiu seu limite maximo de espaço em disco!\" | mailx -s Cota "USER;
					#print cmd;
					system(cmd);
				}
			}
		}'
	fi
done
