#!/bin/bash
log="${LOG_DIR}/12_mpich.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/mpich
cd /tmp/mpich

major=3
minor=3
micro=1

version=$major.$minor.$micro
pkg_name=mpich-$version

lecho "Baixando MPICH"
wget http://www.mpich.org/static/downloads/$version/mpich-$version.tar.gz &>> $log

if [ ! -f $pkg_name.tar.gz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do MPICH"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz &>> $log
cd $pkg_name

lecho "\nConfigurando $pkg_name"
./configure --prefix=/opt/mpich &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do MPICH"
  exit 1
fi
secho "MPICH configurado com sucesso"

lecho "\nInstalando MPICH"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o MPICH"
        exit 1
fi
secho "MPICH instalado com sucesso"

lecho "\nCriando pacote"
cd ..

rocks create package /opt/mpich mpich release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do MPICH"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls mpich*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf mpich

echo "Log completo em $log"

exit 0

