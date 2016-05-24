#!/bin/bash
##########################################################################
#
# Script de ...
# 18/06/2015
# Autores:	Juan Lopes Ferreira, 
#	    	Gilmar Pereira de Acantara
#			Felipe Duarte dos Reis
#
##########################################################################

# Script para executar instalacao do frontend
# Este script sera' executado uma unica vez, apos a instalacao do Rocks

#Armazena o local onde o script esta' armazenado
BASEDIR=$(pwd)

#vars
LOG_DIR="$BASEDIR/Logs"
SCRIPT_DIR="$BASEDIR/Progs"
FRONT_ONLY="$BASEDIR/FrontendOnly"
CHKP_FILE="$BASEDIR/checkpoint"

export BASE_DIR=$BASEDIR

if [ $(id -u) -ne "0" ];then
	echo "Este script deve ser executado com o usuario root"
	echo "\"Great scripts come with great responsabilities...\" - Uncle Juan"
	exit 1
fi


echo -e "\t\t***********DEPLOY CLUSTER F37 - DECOM***************\n 
	\nEsse script irá configurar  todo a ambiente, é nescessário que seja executado fora do /state/partition
	\nDeseja proceder ? (Y, N)"
read reb #Coisa do Gilms

if [ $reb == 'Y' ]; then
    echo -e "Execucao do Deploy iniciada!!!\n\n"
else
    echo -e "Execuçao do Deploy cancelada\n"
	exit 0;
fi

cd $BASE_DIR
. env.config

if [ ! -d ./Logs ];then
	mkdir Logs
fi

if [ ! -f ./checkpoint ];then
	touch ./checkpoint
fi

#Prepara o extend-compute.xml
if [ ! -f /export/rocks/install/site-profiles/$ROCKS_VER/nodes/extend-compute.xml ];then
	cp "/export/rocks/install/site-profiles/$ROCKS_VER/nodes/skeleton.xml" "/export/rocks/install/site-profiles/$ROCKS_VER/nodes/extend-compute.xml"
	sed -i 's/python/bash/g' /export/rocks/install/site-profiles/$ROCKS_VER/nodes/extend-compute.xml
fi

## Atualiza yum
yum --enablerepo="base" update yum

#grupo default para evitar ssh nos computes
groupadd cluster

#### Executa scripts do Frontend
for script in $(ls $FRONT_ONLY) ;do
	if [ -z $(cat $CHKP_FILE | grep $script) ];then
	
		if [ ! -d "$LOG_DIR/$script" ];then
			mkdir -p "$LOG_DIR/$script"
		else
			rm -rf $LOG_DIR/$script/*
		fi
		
		LOG="$LOG_DIR/$script"
		
		touch $LOG_DIR/$script/{ERR,STDOUT}
		
		echo -e "\nExec script : $FRONT_ONLY/$script" 
		sh $FRONT_ONLY/$script 2>> "$LOG/ERR" >> "$LOG/STDOUT"
		
		if [ $? -ne "0" ];then
			echo "Falha ao executar o script $script"
			exit 1
		else
			echo $script >> "$CHKP_FILE"
			echo "Instalacao do -- $script -- concluida com sucesso"
		fi
	fi
done


#### Executa scripts
for script in $(ls $SCRIPT_DIR) ;do
	if [ -z $(cat $CHKP_FILE | grep $script) ];then
	
		if [ ! -d "$LOG_DIR/$script" ];then
			mkdir -p "$LOG_DIR/$script"
		else
			rm -rf $LOG_DIR/$script/*
		fi
		
		LOG="$LOG_DIR/$script"
		
		touch $LOG_DIR/$script/{ERR,STDOUT}
		
		echo -e "\nExec script : $SCRIPT_DIR/$script" 
		sh $SCRIPT_DIR/$script 2>> "$LOG/ERR" >> "$LOG/STDOUT"
		
		if [ $? -ne "0" ];then
			echo "Falha ao executar o script $script"
			exit 1
		else
			echo $script >> "$CHKP_FILE"
			echo "Instalacao do -- $script -- concluida com sucesso"
		fi
	fi
done

cd /export/rocks/install
rocks create distro

echo -e "\n\nInstalacao concluida seu lindo !!!!\n";
echo "Os programas abaixo foram instalados"
cat $BASEDIR/checkpoint


echo -e "\n\nO sistema deve ser reiniciado para que o processo seja concluido \nREBOOT ? (Y, N)"
read reb

if [ $reb == 'Y' ]; then
    echo "Opcao (Y) Reboot acionado..."
    reboot;
else
	echo -e "Opcao (!=Y) selecionada!\nNao esqueca de reiniciar o Cluster..."
fi


