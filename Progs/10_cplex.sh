#!/bin/bash
log="${LOG_DIR}/10_cplex.log"
touch $log && echo "" > $log

source $BASE_DIR/base.sh

mkdir -p /tmp/cplex
cd /tmp/cplex

major=12
minor=6
micro=3

version=$major.$minor.$micro

#colocar cplex no dropbox...
lecho "Baixando CPLEX"
wget -c https://www.dropbox.com/s/t10natbfd02sahs/CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0 &>> $log
mv CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0 cplex_installer.bin

if [ ! -f  ./cplex_installer.bin -o $? != 0 ]; then
	eecho "CPLEX instalation file not found"
	exit 1
fi
secho "Download do CPLEX efetuado com sucesso"

chmod +x cplex_installer.bin

lecho "\nInstalando CPLEX"
./cplex_installer.bin <<< "5

1




" &>> $log

if [ $? != 0 ]; then
        eecho "Falha ao instalar o CPLEX"
        exit 1
fi
secho "CPLEX instalado com sucesso"

lecho "\nCriando pacote"
rocks create package /opt/ibm/ILOG/CPLEX_Enterprise_Server1263 cplex release=1 version=$version &>> $log

if [ ! -f cplex-$version-1.x86_64.rpm ];then
        eecho "Falha ao gerar o pacote rpm do CPLEX"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cplex-*.rpm)
secho "Pacote CPLEX criado e movido com sucesso."

cd ..
rm -rf cplex

echo "Log completo em $log"

exit 0
