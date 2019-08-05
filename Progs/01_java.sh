#!/bin/bash

mkdir -p /tmp/java
cd /tmp/java

mkdir -p /opt/java

major=12
minor=0
micro=2

# A URL precisa ser alterada manualmente, uma vez que a oracle não disponibiliza links de download genéricos por versão.
# Importante destacar que versões End-Of-License do JDK precisam de uma conta Oracle para efetuar o download, então o link abaixo não funciona para elas.

version=$major.$minor.$micro
pkg_name=jdk-${version}_linux-x64_bin.rpm

echo "Baixando $pkg_name"
wget --no-check-certificate --no-cookies -nv --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/12.0.2+10/e482c34c86bd4bf8b56c0b35558996b9/jdk-12.0.2_linux-x64_bin.rpm
if [ ! -f $pkg_name ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do JDK$major 64 bits"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

rpm -i --prefix=/opt/java $pkg_name

yum check

rm -f $pkg_name

rocks create package /opt/java java

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls java-*.rpm)

cd /tmp
rm -rf java

exit 0
