#!/bin/bash
log="${LOG_DIR}/${0%sh}log"
touch $log && echo "" > $log
source base.sh

mkdir -p /tmp/postgresql
cd /tmp/postgresql

major=9
minor=4
version=$major$minor

lecho "Baixando informações do repositório"
yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm &>> $log

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/pgdg-redhat-all.repo &>> $log

lecho "\nBaixando Postgres $major.$minor"
downloader "pgdg$version" "postgresql-jdbc.noarch postgresql$version.x86_64 postgresql$version-contrib.x86_64 postgresql$version-libs.x86_64 postgresql$version-server.x86_64"

lecho "\nInstalando pacotes"
yum -y localinstall *.rpm &>> $log # Fora do loop pois assim o yum cuida da ordem de instalação e dependências corretamente

for package in $(ls *.rpm); do
	rpm --query --queryformat "" ${package%.rpm} &>> $log #verifica se ocorreu a instalação uma vez que o código de saída do yum não é confiável
	if [ $? != 0 ]; then
                eecho "Falha na instalação do pacote $package"
        	exit 1
        fi
	$BASE_DIR/AuxScripts/addPackExtend.sh $package
	secho "Pacote $package instalado e movido com sucesso"
done

cd /tmp
rm -rf postgresql

echo "Log completo em $log"

exit 0
