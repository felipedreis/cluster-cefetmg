#!/bin/bash

mkdir -p /tmp/mpich
cd /tmp/mpich

major=3
minor=3
micro=1

version=$major.$minor.$micro
pkg_name=mpich-$version

echo "Baixando MPICH"
wget -nv http://www.mpich.org/static/downloads/$version/mpich-$version.tar.gz

if [ ! -f $pkg_name.tar.gz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do MPICH"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz
cd $pkg_name

echo -e "\nConfigurando $pkg_name"
./configure -q --prefix=/opt/mpich

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do MPICH"
  exit 1
fi
echo "[SUCESSO] MPICH configurado com sucesso"

echo -e "\nInstalando MPICH"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o MPICH"
        exit 1
fi
echo "[SUCESSO] MPICH instalado com sucesso"

echo -e "\nCriando pacote"
cd ..

rocks create package /opt/mpich mpich release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do MPICH"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls mpich*.rpm)
echo "[SUCESSO] Pacote $pkg_name criado e movido com sucesso."

cd /tmp
rm -rf mpich

exit 0

