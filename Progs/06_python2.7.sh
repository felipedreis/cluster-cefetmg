#!/bin/bash

mkdir -p /tmp/python_2
cd /tmp/python_2

major=2
minor=7
micro=16

version=$major.$minor.$micro
pkg_name=Python-$version

echo "Baixando Python $version"
wget -nv https://www.python.org/ftp/python/$version/$pkg_name.tgz

if [ ! -f $pkg_name.tgz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do Python $major"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xf $pkg_name.tgz 
cd $pkg_name/

echo -e "\nConfigurando $pkg_name"
./configure -q --prefix=/opt/python$major.$minor

if [ $? != 0 ]; then
  echo "[ERRO] Falha na configuração do Python $major"
  exit 1
fi
echo "[SUCESSO] Python $major configurado com sucesso"

echo -e "\nInstalando Python $major"
make -s -j8 >/dev/null
make -s install >/dev/null

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o Python $major"
        exit 1
fi
echo "[SUCESSO] Python $major instalado com sucesso"

#install pip for python2
module load python$major.$minor

echo "Baixando pip"
wget -nv https://bootstrap.pypa.io/get-pip.py

if [ ! -f get-pip.py ];then
        echo "[ERRO] Falha ao baixar o arquivo do pip"
        exit 1
fi
echo "[SUCESSO] Download do arquivo do pip efetuado com sucesso"

echo -e "\nInstalando pip e bibliotecas uteis do Python $major"
python get-pip.py

for package in numpy pandas scipy sklearn tensorflow biopython
do
	pip install -q --upgrade $package
	if [ $? != 0 ]; then
		echo "[ERRO] Falha na instalação da biblioteca $package"
		exit 1
	fi
	echo "[SUCESSO] Biblioteca $package instalada com sucesso"
done

cd ..
rm $pkg_name.tgz

echo -e "\nCriando pacote"
rocks create package /opt/python$major.$minor Python release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do Python $major"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackageExtend.sh $(ls Python*.rpm)
echo "[SUCESSO] Pacote $pkg_name criado e movido com sucesso."

cd /tmp
rm -rf python_2

exit 0
