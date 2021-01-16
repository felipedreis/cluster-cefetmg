#!/bin/bash
log="${LOG_DIR}/11_valgrind.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/valgrind
cd /tmp/valgrind

major=3
minor=15
micro=0

version=$major.$minor.$micro
pkg_name=valgrind-$version

lecho "Baixando Valgrind $version"
wget https://sourceware.org/pub/valgrind/$pkg_name.tar.bz2 &>> $log

if [ ! -f $pkg_name.tar.bz2 -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do VALGRIND"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xjf $pkg_name.tar.bz2 &>> $log
cd $pkg_name

lecho "\nConfigurando $pkg_name"
./configure --prefix=/opt/valgrind &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do Valgrind"
  exit 1
fi
secho "Valgrind configurado com sucesso"

lecho "\nInstalando Valgrind"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o Valgrind"
        exit 1
fi
secho "Valgrind instalado com sucesso"

lecho "\nCriando pacote"
rocks create package /opt/valgrind valgrind release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do Valgrind"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls valgrind-*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf valgrind/

echo "Log completo em $log"

exit 0

