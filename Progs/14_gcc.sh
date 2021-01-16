#!/bin/bash
log="${LOG_DIR}/14_gcc.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

cd /tmp

major=9
minor=1
micro=0

version=$major.$minor.$micro
pkg_name=gcc-$version

lecho "Baixando GCC $version"

wget http://mirrors.concertpass.com/gcc/releases/$pkg_name/$pkg_name.tar.gz &>> $log

if [ ! -f $pkg_name.tar.gz -o $? != 0 ]; then
	eecho "Falha ao baixar o arquivo de instalação do GCC"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz &>> $log
cd $pkg_name

./contrib/download_prerequisites &>> $log
cd ..
mkdir build
cd build

lecho "\nConfigurando $pkg_name"
../$pkg_name/configure --prefix=/opt/gcc --enable-languages=c,c++,fortran,go --disable-multilib &>> $log

if [ $? != 0 ]; then
	eecho "Falha na configuração do GCC"
	exit 1
fi
secho "GCC configurado com sucesso"

lecho "\nInstalando GCC"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o GCC"
        exit 1
fi
secho "GCC instalado com sucesso"

lecho "\nCriando pacote"
rocks create package /opt/gcc gcc release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do GCC"
        exit 1
fi
secho "Pacote $pkg_name criado e movido com sucesso"

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls gcc-*.rpm)

echo "Log completo em $log"

exit 0
