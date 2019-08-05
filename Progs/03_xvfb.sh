#!/bin/bash

downloader() {
	for package in $2
	do
		yumdownloader --enablerepo="$1" --downloaddir=. -q -e 0 $package
		if [ $? != 0 ]; then
			echo "[ERRO] Falha no download do pacote $package"
			exit 1
		fi
		echo "[SUCESSO] Download com sucesso do pacote $package"
	done
}

mkdir -p /tmp/xvfb
cd /tmp/xvfb

echo "Baixando Xvfb"
downloader "base, epel" "xorg-x11-server-Xvfb.x86_64 xorg-x11-xkb-utils.x86_64"

echo -e "\nInstalando pacotes"
yum -q -y -e 0 localinstall *.rpm

for package in $(ls *.rpm); do
	rpm --quiet --query --queryformat "" ${package%.rpm} #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
	if [ $? != 0 ]; then
                echo "[ERRO] Falha na instalação do pacote $package"
        	exit 1
        fi
	$BASE_DIR/AuxScripts/addPackExtend.sh $package
	echo "[SUCESSO] Pacote $package instalado e movido com sucesso."
done

cd /tmp
rm -rf xvfb

exit 0
