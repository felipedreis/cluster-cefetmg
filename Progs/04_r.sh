#!/bin/bash
log="${LOG_DIR}/${0%sh}log"
touch $log && echo "" > $log
source base.sh

mkdir -p /tmp/r
cd /tmp/r

major=3
minor=6
micro=1

version=$major.$minor.$micro
pkg_name=R-$version

#download the latest stable version of R

lecho "Baixando R $version"
wget https://cloud.r-project.org/src/base/R-$major/$pkg_name.tar.gz &>> $log

if [ ! -f $pkg_name.tar.gz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do R"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xf $pkg_name.tar.gz &>> $log

# configure and install R in /opt/R path
lecho "\nConfigurando $pkg_name"
cd ${pkg_name%.tar.gz}
./configure --prefix=/opt/R --without-x &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do R"
  exit 1
fi
secho "R configurado com sucesso"

lecho "\nInstalando R"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o R"
        exit 1
fi
secho "R instalado com sucesso"

#create package and copy it to rocks contrib dir
cd .. 
rm $pkg_name.tar.gz

lecho "\nCriando pacote"
rocks create package /opt/R R release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do R"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls R-*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso."

cd /tmp
rm -rf r

echo "Log completo em $log"

exit 0
