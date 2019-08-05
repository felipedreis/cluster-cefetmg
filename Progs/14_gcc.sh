#!/bin/bash

cd /tmp

major=9
minor=1
micro=0

version=$major.$minor.$micro
pkg_name=gcc-$version

echo "Baixando GCC $version"

wget -nv http://mirrors.concertpass.com/gcc/releases/$pkg_name/$pkg_name.tar.gz

if [ ! -f $pkg_name.tar.gz ]; then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do GCC"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz
cd $pkg_name

./contrib/download_prerequisites
cd ..
mkdir build
cd build

echo -e "\nConfigurando $pkg_name"
../$pkg_name/configure -q --prefix=/opt/gcc --enable-languages=c,c++,fortran,go --disable-multilib

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do GCC"
  exit 1
fi
echo "[SUCESSO] GCC configurado com sucesso"

echo -e "\nInstalando GCC"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o GCC"
        exit 1
fi
echo "[SUCESSO] GCC instalado com sucesso"

echo -e "\nCriando pacote"
rocks create package /opt/gcc gcc release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do GCC"
        exit 1
fi
echo "[SUCESSO] Pacote $pkg_name criado e movido com sucesso."

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls gcc-*.rpm)

exit 0
