#!/bin/bash
log="${LOG_DIR}/08_cmake.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/cmake
cd /tmp/cmake

major=3
minor=15
micro=1

version=$major.$minor.$micro
pkg_name=cmake-$version

lecho "Baixando CMake $version"
wget https://cmake.org/files/v$major.$minor/$pkg_name.tar.gz &>> $log

if [ ! -f $pkg_name.tar.gz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do CMAKE"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xf $pkg_name.tar.gz &>> $log

lecho "\nConfigurando $pkg_name"
cd $pkg_name
./configure --prefix=/opt/cmake &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do CMake"
  exit 1
fi
secho "CMake configurado com sucesso"

lecho "\nInstalando CMake"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o CMake"
        exit 1
fi
secho "CMake instalado com sucesso"

lecho "\nCriando pacote"
rocks create package /opt/cmake cmake release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do CMake"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cmake-*.rpm)

secho "Pacote $pkg_name instalado e movido com sucesso"

cd /tmp 
rm -rf cmake

echo "Log completo em $log"

exit 0
