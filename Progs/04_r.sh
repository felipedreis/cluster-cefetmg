#!/bin/bash

mkdir -p /tmp/r
cd /tmp/r

major=3
minor=6
micro=1

version=$major.$minor.$micro
pkg_name=R-$version

#download the latest stable version of R

echo "Baixando R $version"
wget -nv https://cloud.r-project.org/src/base/R-$major/$pkg_name.tar.gz

if [ ! -f $pkg_name.tar.gz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do R"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xf $pkg_name.tar.gz

# configure and install R in /opt/R path
echo -e "\nConfigurando $pkg_name"
cd ${pkg_name%.tar.gz}
./configure -q --prefix=/opt/R --without-x

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do R"
  exit 1
fi
echo "[SUCESSO] R configurado com sucesso"

echo -e "\nInstalando R"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o R"
        exit 1
fi
echo "[SUCESSO] R instalado com sucesso"

#create package and copy it to rocks contrib dir
cd .. 
rm $pkg_name.tar.gz

echo -e "\nCriando pacote"
rocks create package /opt/R R release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do R"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls R-*.rpm)
echo "[SUCESSO] Pacote $pkg_name instalado e movido com sucesso."

cd /tmp
rm -rf r

exit 0
