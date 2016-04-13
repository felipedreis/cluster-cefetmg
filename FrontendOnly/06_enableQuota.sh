#!/bin/bash

#Este script habilita a cota. Precisa ser rodado apenas UMA vez no sistema (frontend).

#O fstab define se um determinado ponto de montagem pode possuir limitacoes de cotas.

#A cota sera' habilitada para a particao "mountPoint"
mountPoint="/state/partition1"

echo "Habilitando cota de disco"

cat /etc/fstab | awk -v MP=${mountPoint} '{
	#Se o ponto de montagem lido do fstab for igual ao parametro (mountPoint)
	if($2 == MP){
		aux=0;
		i=split($4,mountOP,",");
		for(j=1;j<=i;j++){
			if(mountOP[j] == "usrquota")
				aux++;
			if(mountOP[j] == "grpquota")
				aux++;
		}
		#Se aux == 0, o ponto de montagem ainda nao possui limitacao de cota habilitada.				
		#Habilita ponto de montagem
		if(aux == 0){			
			mOps=$4",usrquota,grpquota";
			cmd="cp /etc/fstab /etc/fstab.orig";
			system(cmd);
			cmd="cat /dev/null > /etc/fstab";
			system(cmd);
			while(getline line < "/etc/fstab.orig"){
				if(line != $0){
					cmd="echo "line" >> /etc/fstab";
					system(cmd);
				}else{
					cmd="echo "$1"\t"$2"\t\t"$3"\t"mOps"\t"$5"\t"$6" >> /etc/fstab";
					system(cmd);
				}
			}
		}
	}
}'

mount -o remount $mountPoint

#Cria os arquivos quota.user e quota.group, se nao existirem
quotacheck -cvug $mountPoint

#Habilita cota
quotaon -avug

echo "Cota de disco habilitada"
