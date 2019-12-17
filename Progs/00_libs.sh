#!/bin/bash
log="${LOG_DIR}/$0"
touch $log && echo "" > $log
source base.sh

mkdir /tmp/libs
cd /tmp/libs

# Mathematical libraries
lecho "Baixando bibliotecas"
downloader "base, epel" "blas-devel.i686 blas-devel.x86_64 blas.i686 blas.x86_64";
downloader "base, epel" "atlas.i686 atlas.x86_64";
downloader "base, epel" "lapack.i686 lapack.x86_64 lapack-devel.x86_64 lapack-devel.i686";
downloader "base, epel" "libgcc.i686 libgcc.x86_64";
downloader "base, epel" "readline.x86_64 readline-devel.x86_64";
downloader "base, epel" "texinfo.x86_64";

# MESA OpenGL libraries
# must use yumdownloader as part of them are already installed, yum --downloadonly may fail

#aparentemente já instalado nos computes, baixar estes pacotes gera um conflito e impede a instalacao das libs
#yumdownloader --enablerepo="base, epel" mesa-libGL.x86_64 mesa-libGL-devel.x86_64 mesa-libGLU.x86_64 mesa-libGLU-devel.x86_64  mesa-libGLw.x86_64  mesa-libGLw-devel.x86_64  freeglut.x86_64  freeglut-devel.x86_64
lecho "\nInstalando e movendo bibliotecas"
for package in $(ls *.rpm); do
	yum --setopt=protected_multilib=false -y localinstall $package &>> $log
	rpm --query --queryformat "" ${package%.rpm} &>> $log #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
	if [ $? != 0 ]; then
                eecho "Falha na instalação do pacote $package"
        	exit 1
        fi
	$BASE_DIR/AuxScripts/addPackExtend.sh $package &>> $log
	secho "Pacote $package instalado e movido com sucesso"
done

cd ..
rm -rf libs

echo "Log completo em $log"

exit 0
