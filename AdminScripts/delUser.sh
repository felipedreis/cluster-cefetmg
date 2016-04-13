#!/bin/bash

if [ $# != 1 ];then
	echo "$0 usuario"
	exit
fi

userdel $1
rm -rf /export/home/$1

#Retira o usuario do alias
user=$1":"
sed -i "/^$user/d" /etc/aliases

#Recarrega os alias
newaliases
service postfix reload

rocks sync users
