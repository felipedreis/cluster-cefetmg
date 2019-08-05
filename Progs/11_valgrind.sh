#!/bin/bash

mkdir -p /tmp/valgrind
cd /tmp/valgrind

major=3
minor=15
micro=0

version=$major.$minor.$micro
pkg_name=valgrind-$version

echo "Baixando Valgrind $version"
wget -nv https://sourceware.org/pub/valgrind/$pkg_name.tar.bz2

if [ ! -f $pkg_name.tar.bz2 ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do VALGRIND"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xjf $pkg_name.tar.bz2
cd $pkg_name

echo -e "\nConfigurando $pkg_name"
./configure -q --prefix=/opt/valgrind

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do Valgrind"
  exit 1
fi
echo "[SUCESSO] Valgrind configurado com sucesso"

echo -e "\nInstalando Valgrind"
make -s -j8 >/dev/null
make -s install  >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o Valgrind"
        exit 1
fi
echo "[SUCESSO] Valgrind instalado com sucesso"

echo -e "\nCriando pacote"
rocks create package /opt/valgrind valgrind release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do Valgrind"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls valgrind-*.rpm)
echo "[SUCESSO] Pacote $pkg_name criado e movido com sucesso."

cd /tmp
rm -rf valgrind/

exit 0

