#!/bin/bash

mkdir -p /tmp/octave
cd /tmp/octave

major=5
minor=1
micro=0

version=$major.$minor.$micro
pkg_name=octave-$version
echo "Baixando Octave $version"
wget -nv http://ftp.gnu.org/gnu/octave/$pkg_name.tar.gz

if [ ! -f $pkg_name.tar.gz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do OCTAVE"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz

# Compila o octave. No passo de config ele checa a existencia de libblas
# e liblapack, ambas devem existir no /usr/lib com o nome libblas.so e liblapack.so
echo -e "\nConfigurando $pkg_name"
cd $pkg_name
./configure -q --prefix=/opt/octave 

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do Octave"
  exit 1
fi
echo "[SUCESSO] Octave configurado com sucesso"

echo -e "\nInstalando R"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o Octave"
        exit 1
fi
echo "[SUCESSO] Octave instalado com sucesso"

cd ..
rm $pkg_name.tar.gz

echo -e "\nCriando pacote"
rocks create package /opt/octave octave release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do Octave"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls octave-*.rpm)
echo "[SUCESSO] Pacote $pkg_name instalado e movido com sucesso."

cd /tmp
rm -rf octave

exit 0
