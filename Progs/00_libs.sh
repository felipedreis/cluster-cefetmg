#!/bin/bash

mkdir /tmp/libs
cd /tmp/libs


yum --enablerepo="base, epel" --downloadonly --downloaddir=./ install blas-devel.i686 blas-devel.x86_64 blas.i686 blas.x86_64 
yum --enablerepo="base, epel" --downloadonly --downloaddir=./ install atlas.i686 atlas.x86_64 
yum --enablerepo="base, epel" --downloadonly --downloaddir=./ install lapack.i686 lapack.x86_64 lapack-devel.x86_64 lapack-devel.i686

rpm -i *.rpm

for pack in $(ls *.rpm);do
	$BASE_DIR/AuxScripts/addPackExtend.sh $pack
done

mv * $RPM_CONTRIB_DIR

cd ..
rm -rf libs
