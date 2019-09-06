#!/bin/bash
log="${LOG_DIR}/${0%sh}log"
touch $log && echo "" > $log
source base.sh

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

lecho "Baixando $pkg_name"
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/12.0.2+10/e482c34c86bd4bf8b56c0b35558996b9/jdk-12.0.2_linux-x64_bin.rpm &>> $log

if [ ! -f $pkg_name -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do JDK$major 64 bits"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nInstalando Java"
rpm -i --prefix=/opt/java $pkg_name &>> $log
rpm --query --queryformat "" jdk-$version &>> $log #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
if [ $? != 0 ]; then
        eecho "Falha na instalação do pacote $pkg_name"
  	exit 1
fi
secho "Pacote $pkg_name instalado com sucesso"

#yum check &>> $log

rm -f $pkg_name

lecho "\nCriando pacote"
rocks create package /opt/java java release=1 version=$major.$minor.$micro &>> $log

if [ ! -f java-$version-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do Java"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls java-*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf java

echo "Log completo em $log"

exit 0
