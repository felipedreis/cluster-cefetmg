#!/bin/bash
log="${LOG_DIR}/${0%sh}log"
touch $log && echo "" > $log
source base.sh

mkdir -p /tmp/trinity
cd /tmp/trinity

major=2
minor=8
micro=5

version=$major.$minor.$micro
pkg_name=trinity-$version

lecho "Baixando Trinity $version"

wget https://github.com/trinityrnaseq/trinityrnaseq/archive/v$version.tar.gz &>> $log

if [ ! -f v$version.tar.gz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do Trinity"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xzf v$version.tar.gz &>> $log

mkdir /opt/trinity-$version
cp -r trinityrnaseq-$version/* /opt/trinity-$version

lecho "\nCriando pacote"
rocks create package /opt/trinity-$version trinity release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do Trinity"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls trinity-*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf trinity

echo "Log completo em $log"

exit 0
