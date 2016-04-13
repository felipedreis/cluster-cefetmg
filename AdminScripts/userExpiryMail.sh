#!/bin/bash

#Inserir este script no CRON.

#Envia email antes da conta do usuario expirar

#parametros
daysBeforeExpiry=10;

#converte segundos para dias
day=$(date +%s)
day=$(echo "$day / 86400" | bc)

cat /etc/shadow | awk -F ":" -v DBE=${daysBeforeExpiry} -v DAY=${day} '{
	#Se o 8o. campo for diferente de null
	if($8 != ""){
		if( ( $8 - DAY ) <= DBE && ($8 - DAY) > 0 ){
			cmd = "echo \"Sua conta de usuario no cluster ira expirar em "($8 - DAY)" dias.\" | mailx -s Expiracao_de_conta "$1;
			system(cmd);
			if(( $8 - DAY ) == 4){
				cmd= "echo \"A conta do usuario "$1" expira em 4 dias!\" | mailx -s expiracao_conta bruno.decom@gmail.com"
				system(cmd)
			}
		}
	}
}'
