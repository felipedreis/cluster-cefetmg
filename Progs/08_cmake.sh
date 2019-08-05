#!/bin/bash

mkdir -p /tmp/cmake
cd /tmp/cmake

major=3
minor=15
micro=1

version=$major.$minor.$micro
pkg_name=cmake-$version

echo "Baixando CMake $version"
wget -nv https://cmake.org/files/v$major.$minor/$pkg_name.tar.gz

if [ ! -f $pkg_name.tar.gz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do CMAKE"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xf $pkg_name.tar.gz

echo -e "\nConfigurando $pkg_name"
cd $pkg_name
./configure --prefix=/opt/cmake

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do CMake"
  exit 1
fi
echo "[SUCESSO] CMake configurado com sucesso"

echo -e "\nInstalando CMake"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o CMake"
        exit 1
fi
echo "[SUCESSO] CMake instalado com sucesso"

echo -e "\nCriando pacote"
rocks create package /opt/cmake cmake release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do CMake"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cmake-*.rpm)

echo "[SUCESSO] Pacote $pkg_name instalado e movido com sucesso."

cd /tmp 
rm -rf cmake

exit 0
