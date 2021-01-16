#!/bin/bash
log="${LOG_DIR}/03_xvfb.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/xvfb
cd /tmp/xvfb

lecho "Baixando Xvfb"
downloader "base, epel" "xorg-x11-server-Xvfb.x86_64 xorg-x11-xkb-utils.x86_64"

lecho "\nInstalando pacotes"
yum -y localinstall *.rpm &>> $log

for package in $(ls *.rpm); do
	rpm --quiet --query --queryformat "" ${package%.rpm} &>> $log #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
	if [ $? != 0 ]; then
                eecho "Falha na instalação do pacote $package"
        	exit 1
        fi
	$BASE_DIR/AuxScripts/addPackExtend.sh $package
	secho "Pacote $package instalado e movido com sucesso"
done

cd /tmp
rm -rf xvfb

echo "Log completo em $log"

exit 0
