#!/bin/bash

mkdir -p /tmp/gamess
cd /tmp/gamess

wget -c https://www.dropbox.com/sh/miho1ik1va8snmr/AACzbAdMz6QgPBcLVE6wqinqa/gamess-current.tar.gz?dl=0

if [ ! -f gamess-current.tar.gz?dl=0 ];then
	echo "Falha ao baixar o arquivo de instalação do GAMESS"
	exit 1
fi

mv gamess-current.tar.gz?dl=0 gamess-current.tar.gz

tar -xzf gamess-current.tar.gz -C /opt
rm -f gamess-current.tar.gz

cd /opt/gamess

cd /usr/lib64/atlas
ln -s libf77blas.so.3.0 libf77blas.so
ln -s libatlas.so.3.0   libatlas.so

$BASE_DIR/AuxScripts/addPostExtend.sh "ln -s /usr/lib64/atlas/libf77blas.so.3.0 /usr/lib64/atlas/libf77blas.so"
$BASE_DIR/AuxScripts/addPostExtend.sh "ln -s /usr/lib64/atlas/libatlas.so.3.0 /usr/lib64/atlas/libatlas.so"

cd -

cat << EOF > tmp_gamess_input

linux64


00
gfortran
4.4

atlas
/usr/lib64/atlas


sockets
no
EOF

./config < tmp_gamess_input

cd ddi
./compddi
mv ddikick.x ..
cd ..

./compall

./lked gamess 00

sed -i "s|./rungms*|/opt/gamess/rungms|g" runall
sed -i 's|set SCR=.*|set SCR=/tmp|' rungms
sed -i 's|set GMSPATH=.*|set GMSPATH=/opt/gamess|' rungms

cd ..
rocks create package /opt/gamess gamess

$BASE_DIR/AuxScripts/addPackageExtend.sh $(ls gamess*.rpm)

mv gamess*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf gamess