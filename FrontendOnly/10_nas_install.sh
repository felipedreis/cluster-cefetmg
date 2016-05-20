#!/bin/bash

xterm -e insert-ethers
#wait $!

echo -e "\n#NAS" >> /etc/fstab
echo -e "nas-0-0:/export/data1\t/export/home\tnfs\trsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab

mount -a

rocks set attr Info_HomeDirSrv "nas-0-0"
rocks set attr Info_HomeDirLoc "/export/data1"

rocks sync host sharedkey
rocks sync config
rocks sync users

rocks run host nas-0-0 "$(cat $BASE_DIR/AuxScripts/enableQuota.sh)"
