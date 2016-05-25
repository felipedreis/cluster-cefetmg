#!/bin/bash

mkdir -p /tmp/java
cd /tmp/java

mkdir -p /opt/java

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.rpm
rpm -i --prefix=/opt/java jdk-7u80-linux-x64.rpm
rm -f jdk-7u80-linux-x64.rpm

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.rpm
rpm -i --prefix=/opt/java jdk-8u92-linux-x64.rpm
rm -f jdk-8u92-linux-x64.rpm

yum check

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-i586.tar.gz

tar -xzf jdk-7u80-linux-i586.tar.gz -C /opt/java/jdk1.7.0_80_32bits
tar -xzf jdk-8u92-linux-i586.tar.gz -C /opt/java/jdk1.8.0_92_32bits

rocks create package /opt/java java

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls java-*)

mv java-* $RPM_CONTRIB_DIR

cd /tmp
rm -rf java
