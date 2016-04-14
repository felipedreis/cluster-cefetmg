#!/bin/bash

cd /tmp
mkdir -p /opt/java

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u74-b02/jdk-8u74-linux-x64.rpm
rpm  -i --prefix=/opt/java jdk-8u73-b02-linux-x64.rpm
rm -f jdk-8u73-b02-linux-x64.rpm

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.rpm
rpm  -i --prefix=/opt/java jdk-7u79-linux-x64.rpm
rm -f jdk-7u79-linux-x64.rpm

rocks create package /opt/java java

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls java-*)

mv java-* $RPM_CONTRIB_DIR

#copy modules
cp $BASE_DIR/Modules/jdk7 /etc/modulefiles/
cp $BASE_DIR/Modules/jdk8 /etc/modulefiles/
