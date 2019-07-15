#!/bin/bash

mkdir -p /tmp/xvfb
cd /tmp/xvfb

yum --enablerepo="base" install --downloadonly --downloaddir=./ xorg-x11-server-Xvfb.x86_64 xorg-x11-xkb-utils.x86_64
yum localinstall *.rpm

for pack in $(ls *.rpm);do
	$BASE_DIR/AuxScripts/addPackExtend.sh $pack
done

cd /tmp
rm -rf xvfb
