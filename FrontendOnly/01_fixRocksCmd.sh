#!/bin/bash
#Corrige o erro do comando Rocks sync host sharedkey

cd /opt/rocks/lib/python2.6/site-packages/rocks/commands/sync/host/sharedkey
if [ $? -ne 0 ];then
	echo "Nao foi possivel entrar no diretório /opt/rocks/lib/python2.6/site-packages/rocks/commands/sync/host/sharedkey" &>2;
	exit 1;
fi

if [ ! -f  __init__.py ];then
	echo "O arquivo __init__.py nao existe ou nao e' regular" &>2;
	exit 1;
fi

touch __init__.py.tmp
if [ $? -ne 0 ];then
	echo "Nao foi possivel criar o arquivo temporario __init__.py.tmp" &>2;
	exit 1;
fi

FLAG=1;
while IFS="" read -r LINE;do
	if [[ "${LINE}" == "		for host in hosts:" ]];then
		echo "${LINE}" >> __init__.py.tmp;
		echo -e "\t\t\tif host != os.uname()[1].split('.',1)[0]:" >> __init__.py.tmp
		echo -e "\t\t\t\tcmd = 'scp -q -o UserKnownHostsFile=%s %s root@%s:%s' % \\" >> __init__.py.tmp;
		echo -e "\t\t\t\t\t(khfname,fname, host, fname)" >> __init__.py.tmp;
		echo -e "\t\t\t\tp = Parallel(cmd, host)" >> __init__.py.tmp;
		echo -e "\t\t\t\tp.start()" >> __init__.py.tmp;
		echo -e "\t\t\t\tthreads.append(p)" >> __init__.py.tmp;
		echo "" >> __init__.py.tmp;
		FLAG=0;
	elif [[ "${LINE}" == "		for thread in threads:" ]];then
		echo "${LINE}" >> __init__.py.tmp;
		FLAG=1;
	elif [[ $FLAG -eq 1 ]];then
		echo "${LINE}" >> __init__.py.tmp;
	fi
done < __init__.py
if [ $? -ne 0 ];then
	echo "Nao foi possivel escrever no arquivo __init__.py.tmp" &>2;
	exit 1;
fi

#Remove o original e renomeia o temporario.
rm -vf __init__.py
if [ $? -ne 0 ];then
	echo "Nao foi possivel remover o arquivo __init__.py" &>2;
	exit 1;
fi

mv -v __init__.py.tmp __init__.py
if [ $? -ne 0 ];then
	echo "Nao foi possivel renomear o arquivo __init__.py.tmp" &>2;
	exit 1;
fi

echo "Rocks sync host sharedkey corrigido";
