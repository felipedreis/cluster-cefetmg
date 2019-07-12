#!/bin/bash

mkdir /tmp/libs
cd /tmp/libs

# Mathematical libraries
yumdownloader --enablerepo="base, epel" --downloadonly --downloaddir=./ blas-devel.i686 blas-devel.x86_64 blas.i686 blas.x86_64 
yumdownloader --enablerepo="base, epel" --downloadonly --downloaddir=./ atlas.i686 atlas.x86_64 
yumdownloader --enablerepo="base, epel" --downloadonly --downloaddir=./ lapack.i686 lapack.x86_64 lapack-devel.x86_64 lapack-devel.i686
yumdownloader --enablerepo="base, epel" --downloadonly --downloaddir=./ libgcc.i686

# MESA OpenGL libraries
# must use yumdownloader as part of them are already installed, yum --downloadonly may fail

#aparentemente já instalado nos computes, baixar estes pacotes gera um conflito e impede a instalacao das libs
#yumdownloader --enablerepo="base, epel" mesa-libGL.x86_64 mesa-libGL-devel.x86_64 mesa-libGLU.x86_64 mesa-libGLU-devel.x86_64  mesa-libGLw.x86_64  mesa-libGLw-devel.x86_64  freeglut.x86_64  freeglut-devel.x86_64

yum --setopt=protected_multilib=false localinstall *.rpm

for pack in $(ls *.rpm);do
	$BASE_DIR/AuxScripts/addPackExtend.sh $pack
done

cd ..
rm -rf libs
