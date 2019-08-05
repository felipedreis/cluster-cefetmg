#!/bin/bash

mkdir -p /tmp/trinity
cd /tmp/trinity

major=2
minor=8
micro=5

version=$major.$minor.$micro
pkg_name=trinity-$version

echo "Baixando Trinity $version"

wget -nv https://github.com/trinityrnaseq/trinityrnaseq/archive/v$version.tar.gz

if [ ! -f v$version.tar.gz ];then
	echo "[ERRO] Falha ao baixar o arquivo de instalação do Trinity"
	exit 1
fi
echo "[SUCESSO] Download do pacote $pkg_name efetuado com sucesso"

echo -e "\nDescompactando $pkg_name"
tar -xzf v$version.tar.gz

mkdir /opt/trinity-$version
cp -r trinityrnaseq-$version/* /opt/trinity-$version

echo -e "\nCriando pacote"
rocks create package /opt/trinity-$version trinity release=1 version=$major.$minor.$micro 2>&1 | tail -n 8

if [ ! -f $pkg_name-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do Trinity"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls trinity-*.rpm)
echo "[SUCESSO] Pacote $pkg_name instalado e movido com sucesso."

cd /tmp
rm -rf trinity

exit 0
