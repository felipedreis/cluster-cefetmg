#!/bin/bash

#script para a criaçao de direorio no storage para usuaio
#pede nome do usuario e quota
if [ $# -ne 3 ]; then 
	echo "./createDirStorage user tamquota(bytes) limitequota"
	exit 1
fi


mkdir /state/partition1/storage/home/${1}-st
chown -R $1:$1 /state/partition1/storage/home/${1}-st
ln -s /mnt/storage/home/${1}-st /export/home/${1}/${1}-st

setquota $1 $2 $3 0 0 /state/partition1/storage
