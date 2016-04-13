#!/bin/bash
#instala o Slurm

if [ ! -d /root/Downloads ];then
	mkdir -p /root/Downloads
fi

cd /root/Downloads

echo "Iniciando instalacao do SLURM"

if [ ! -f slurm-6.1.1-81.x86_64.disk1.iso ];then
	wget -o logWget -c https://sourceforge.net/projects/slurm-roll/files/latest/download
	#wget -o logWget -c http://sourceforge.net/projects/slurm-roll/files/release-6.1.1-14.03.6/slurm-6.1.1-81.x86_64.disk1.iso/download
	if [ $? -ne 0 ];then
		echo "Ocorreu um erro no download do roll do Slurm" &>2;
		cat logWget &>2
		exit 1;
	fi
	rm -f logWget

	mv -v download slurm-6.2.0-15087.x86_64.disk1.iso
	if [ $? -ne 0 ];then
		echo "Falha ao renomear o arquivo baixado" &>2;
		exit 1;
	fi
fi

rocks add roll slurm*.iso
if [ $? -ne 0 ];then
	echo "Falha ao adicionar o roll no sistema" &>2;
	exit 1;
fi

rocks enable roll slurm
if [ $? -ne 0 ];then
	echo "Falha ao habilitar o roll no sistema" &>2;
	exit 1;
fi

cd /export/rocks/install
if [ $? -ne 0 ];then
	echo "Falha ao mudar para o diretorio /export/rocks/install" &>2;
	exit 1;
fi

rocks create distro
if [ $? -ne 0 ];then
	echo "Falha ao criar a distribuicao" &>2;
	exit 1;
fi

yum clean all
if [ $? -ne 0 ];then
	echo "Ocorreu um erro ao limpar os caches do Yum" &>2;
	exit 1;
fi

rocks run roll slurm | sh
if [ $? -ne 0 ];then
	echo "Ocorreu um erro ao executar o roll do Slurm no sistema" &>2;
	exit 1;
fi

echo "#!/bin/bash" > /usr/bin/sinfo2
echo "sinfo -o %13P%15C%20g%9l" >> /usr/bin/sinfo2
chmod 755 /usr/bin/sinfo2

echo "#!/bin/bash" > /usr/bin/squeue2
echo "squeue -o \"%7i %10P %15j %12u %12T %10r %4C %8M %L\" --user=$USER" >> /usr/bin/squeue2
chmod 755 /usr/bin/squeue2

echo "#!/bin/bash" > /usr/bin/squeue3
echo "squeue -o \"%7i %10P %15j %12u %12T %10r %4C %8M %L\" -S U" >> /usr/bin/squeue3
chmod 755 /usr/bin/squeue3

##missing new configuration

echo "Instalacao do SLURM concluída"
