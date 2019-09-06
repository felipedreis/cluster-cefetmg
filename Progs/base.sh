eecho () {
	echo -e "[ERRO] $1. Verifique o arquivo de logs ${log}" | tee -a $log
}

secho() {
	echo -e "[SUCESSO] $1." | tee -a $log
}

lecho() {
	echo -e "$1" | tee -a $log
}

downloader() {
	for package in $2
        do
          	yumdownloader --enablerepo="$1" --downloaddir=. $package &>> $log
                if [ $? != 0 ]; then
                        eecho "Falha no download do pacote $package"
                        exit 1
                fi
        done
	secho "Download com sucesso do(s) pacote(s) $2"
}
