#!/bin/bash

mkdir -p /tmp/cplex
cd /tmp/cplex

major=12
minor=6
micro=3

version=$major.$minor.$micro

#colocar cplex no dropbox...
echo "Baixando CPLEX"
wget -c -nv https://www.dropbox.com/s/t10natbfd02sahs/CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0
mv CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0 cplex_installer.bin

if [ ! -f  ./cplex_installer.bin ]; then
	echo "[ERRO] CPLEX instalation file not found"
	exit 1
fi
echo "[SUCESSO] Download do CPLEX efetuado com sucesso"

chmod +x cplex_installer.bin

echo -e "\nInstalando CPLEX"
./cplex_installer.bin <<< "5

1




"

if [ $? != 0 ]; then
        echo "[ERRO] Falha ao instalar o CPLEX"
        exit 1
fi
echo "[SUCESSO] CPLEX instalado com sucesso"

echo -e "\nCriando pacote"
rocks create package /opt/ibm/ILOG/CPLEX_Enterprise_Server1263 cplex release=1 version=$version 2>&1 | tail -n 8

if [ ! -f cplex-$version-1.x86_64.rpm ];then
        echo "[ERRO] Falha ao gerar o pacote rpm do CPLEX"
        exit 1
fi

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cplex-*.rpm)
echo "[SUCESSO] Pacote CPLEX criado e movido com sucesso."

cd ..
rm -rf cplex

exit 0
