#!/bin/bash
log="${LOG_DIR}/07_python3.4.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

major=3
minor=7
micro=4

version=$major.$minor.$micro
pkg_name=Python-$version
mod_name=python$major.$minor

mkdir -p /tmp/python_$major
cd /tmp/python_$major

lecho "Baixando Python $version"
wget https://www.python.org/ftp/python/$version/$pkg_name.tgz &>> $log

if [ ! -f $pkg_name.tgz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do Python $major"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xf $pkg_name.tgz &>> $log
cd $pkg_name/

lecho "\nConfigurando $pkg_name"
./configure --prefix=/opt/$mod_name &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do Python $major"
  exit 1
fi
secho "Python $major configurado com sucesso"

lecho "\nInstalando Python $major"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o Python $major"
        exit 1
fi
secho "Python $major instalado com sucesso"

ln -s /opt/$mod_name/bin/$mod_name /opt/$mod_name/bin/python

#install pip for python
module load $mod_name

lecho "Baixando pip"
wget https://bootstrap.pypa.io/get-pip.py &>> $log

if [ ! -f get-pip.py -o $? != 0 ];then
        eecho "Falha ao baixar o arquivo do pip"
        exit 1
fi
secho "Download do arquivo do pip efetuado com sucesso"

lecho "\nInstalando pip e bibliotecas uteis do Python $major"
python get-pip.py &>> $log

ln -s /opt/$mod_name/bin/pip$major /opt/$mod_name/bin/pip

for package in numpy pandas scipy sklearn tensorflow biopython
do
        pip install --upgrade $package &>> $log
        if [ $? != 0 ]; then
                eecho "Falha na instalação da biblioteca $package"
                exit 1
        fi
        secho "Biblioteca $package instalada com sucesso"
done

cd ..
rm $pkg_name.tgz

lecho "\nCriando pacote"
rocks create package /opt/$mod_name Python release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do Python $major"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls Python*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf python_$major

echo "Log completo em $log"

exit 0
