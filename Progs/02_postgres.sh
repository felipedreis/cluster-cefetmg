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

mkdir -p /tmp/postgresql
cd /tmp/postgresql

major=9
minor=4
version=$major$minor

echo "Baixando informações do repositório"
yum -q -y -e 0 install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/pgdg-redhat-all.repo 

echo -e "\nBaixando Postgres $major.$minor"
downloader "pgdg$version" "postgresql-jdbc.noarch postgresql$version.x86_64 postgresql$version-contrib.x86_64 postgresql$version-libs.x86_64 postgresql$version-server.x86_64"

echo -e "\nInstalando pacotes"
yum -q -y -e 0 localinstall *.rpm # Fora do loop pois assim o yum cuida da ordem de instalação e dependências corretamente

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
rm -rf postgresql

exit 0
