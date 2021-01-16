#!/bin/bash
log="${LOG_DIR}/05_octave.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/octave
cd /tmp/octave

major=5
minor=1
micro=0

version=$major.$minor.$micro
pkg_name=octave-$version
lecho "Baixando Octave $version"
wget http://ftp.gnu.org/gnu/octave/$pkg_name.tar.gz &>> $log

if [ ! -f $pkg_name.tar.gz -o $? != 0 ];then
	eecho "Falha ao baixar o arquivo de instalação do OCTAVE"
	exit 1
fi
secho "Download do pacote $pkg_name efetuado com sucesso"

lecho "\nDescompactando $pkg_name"
tar -xzf $pkg_name.tar.gz &>> $log

# Compila o octave. No passo de config ele checa a existencia de libblas
# e liblapack, ambas devem existir no /usr/lib com o nome libblas.so e liblapack.so
lecho "\nConfigurando $pkg_name"
cd $pkg_name
./configure --prefix=/opt/octave &>> $log

if [ $? != 0 ]; then
  eecho "Falha na configuração do Octave"
  exit 1
fi
secho "Octave configurado com sucesso"

lecho "\nInstalando Octave"
make -j8 &>> $log
make install &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o Octave"
        exit 1
fi
secho "Octave instalado com sucesso"

cd ..
rm $pkg_name.tar.gz

lecho -e "\nCriando pacote"
rocks create package /opt/octave octave release=1 version=$major.$minor.$micro &>> $log

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do Octave"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls octave-*.rpm)
secho "Pacote $pkg_name criado e movido com sucesso"

cd /tmp
rm -rf octave

echo "Log completo em $log"

exit 0
