#!/bin/bash

downloader() {
	for package in $2
	do
		yumdownloader --enablerepo="$1" --downloaddir=. -q -e 0 $package
		if [ $? != 0 ]; then
			echo "[ERRO] Falha no download do pacote $package"
			exit 1
		fi
	done
	echo "[SUCESSO] Download com sucesso do(s) pacote(s) $2"
}

mkdir /tmp/libs
cd /tmp/libs

# Mathematical libraries
echo "Baixando bibliotecas"
downloader "base, epel" "blas-devel.i686 blas-devel.x86_64 blas.i686 blas.x86_64";
downloader "base, epel" "atlas.i686 atlas.x86_64";
downloader "base, epel" "lapack.i686 lapack.x86_64 lapack-devel.x86_64 lapack-devel.i686";
downloader "base, epel" "libgcc.i686";
downloader "base, epel" "readline.x86_64 readline-devel.x86_64";

# MESA OpenGL libraries
# must use yumdownloader as part of them are already installed, yum --downloadonly may fail

#aparentemente já instalado nos computes, baixar estes pacotes gera um conflito e impede a instalacao das libs
#yumdownloader --enablerepo="base, epel" mesa-libGL.x86_64 mesa-libGL-devel.x86_64 mesa-libGLU.x86_64 mesa-libGLU-devel.x86_64  mesa-libGLw.x86_64  mesa-libGLw-devel.x86_64  freeglut.x86_64  freeglut-devel.x86_64
echo -e "\nInstalando e movendo bibliotecas"
for package in $(ls *.rpm); do
	yum --setopt=protected_multilib=false -q -y -e 0 localinstall $package
	rpm --quiet --query --queryformat "" ${package%.rpm} > /dev/null #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
	if [ $? != 0 ]; then
                echo "[ERRO] Falha na instalação do pacote $package"
        	exit 1
        fi
	$BASE_DIR/AuxScripts/addPackExtend.sh $package
	echo "[SUCESSO] Pacote $package instalado e movido com sucesso."
done

cd ..
rm -rf libs

exit 0
