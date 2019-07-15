#!/bin/bash

mkdir -p /tmp/java
cd /tmp/java

mkdir -p /opt/java

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/12.0.1+12/69cfe15208a647278a19ef0990eea691/jdk-12.0.1_linux-x64_bin.rpm
if [ ! -f jdk-12.0.1_linux-x64_bin.rpm ];then
	echo "Falha ao baixar o arquivo de instalação do JDK12 64 bits"
	exit 1
fi
rpm -i --prefix=/opt/java jdk-12.0.1_linux-x64_bin.rpm

yum check

rm -f jdk-12.0.1_linux-x64_bin.rpm

rocks create package /opt/java java

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls java-*.rpm)

cd /tmp
rm -rf java
