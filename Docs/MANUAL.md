# Manual de utilização do cluster

O cluster é um ambiente de computação de alto desempenho para fins de pesquisa do programa de pós-graduação em Modelagem Matemática e Computacional (PPGMMC), mantido pelo Laboratório de Computação de Alto Desempenho (LCAD) do CEFET-MG. O cluster é aberto aos pesquisadores, professores e alunos da instituição que queiram desenvolver projetos de pesquisa e desenvolvimento, bem como atividades especiais no âmbito do ensino.

Este manual descreve a configuração de hardware das máquinas, os softwares instalados, o modo de acesso ao cluster, e também faz uma introdução de como executar os programas de forma correta. Outras informações relevantes como tutoriais de comandos e bibliotecas podem ser encontrados no [site do LCAD](http://www.lcad.cefetmg.br).

## Caracterização do cluster

As próximas secções descrevem a configuração de hardware e software das máquinas. 

### Hardware

O cluster conta com 32 máquinas de uso compartilhado, em 3 diferentes configurações. Essas máquinas estão agrupadas nas filas **small**, **medium**, **large**, conforme descrito a seguir:

 * **small**: 11 máquinas Dell, processador XEON 8 threads físicas, sem hyperthread, 48GB RAM (em média);
 * **medium**: 17 Máquinas Dell, processador XEON 8 threads físicas, com hyperthread, 32 GB RAM (em média);
 * **large**: 4 Máquinas Supermicro, 64 threads físicas, sem hyperthread, 128 GB RAM.

As máquinas estão conectadas por uma rede Gigabit que atinge uma velocidade de 1 Gb/s.

### Softwares 

O cluster dispõe com compiladores/interpretadores/softwares mais utilizados nas áreas de pesquisa em modelagem matemática e computacional. O sistema operacional do cluster é o CentOS 6.6 e todas as máquinas têm os mesmos softwares instalados.
O usuário tem aos seu dispor os seguintes compiladores/interpretadores:
 
 * Java Oracle 7u80, 32 bits e 64 bits;
 * Java Oracle 8u92, 32 bits e 64 bits;
 * Python 2.7;
 * Python 3.4;
 * Octave 4.0.1;
 * R 3.2.4;
 * GCC 6.0.1 (Inclui C, C++, Fortran e Go);
 * CUDA 7.0.28;

Bem como as seguintes bibliotecas instaladas:

 * BLAS;
 * ATLAS;
 * LAPACK; 
 * libgcc.

Adcionalmente os seguintes softwares:
 
 * CPLEX 12.6.3;
 * GAMESS;
 * MPI 1.5.4;
 * MPICH 3.2;
 * Trinity 2.2.0;
 * Cmake 3.5.2;
 * Postgres 9.4;
 * Valgrind 3.11;
 * XVFB.

A fim de manter diferentes versões dos softwares instalados sem que uma cause conflito na outra o recurso de módulos de ambientes é utilizado. Este recurso dá  flexibilidade ao usuário que pode escolher qual versão do software utilizar.

Com exceção das bibliotecas, todos os softwares estão disponíveis somente através dos módulos de ambiente, *i.e.*, eles não são carregados por padrão, mas devem ser informados pelo usuário no momento da sua efetiva utilização. 

O comando utilizado para gerenciar os módulos carregados é o `module`.
É possível listar os módulos com ` module avail`.

```shell
[root@cluster bin]# module avail

------------------------ /usr/share/Modules/modulefiles --------------
dot              modules          rocks-openmpi
module-git       null             rocks-openmpi_ib
module-info      opt-python       use.own

------------------------------- /etc/modulefiles ---------------------
autodocksuite  gcc6.1         jdk8           openmpi-x86_64 trinity
clustalw       glimmer        jdk8_32        phylip         valgrind
cmake          gmap           mpiblast       python2.7      wgs
cplex          gromacs        mpich          python3.4
emboss         hmmer          mrbayes        R-3.2.4
fasta          jdk7           ncbi-blast     t_coffee
gamess         jdk7_32        octave         tigr

```

Para carregar um módulo utilize o comando `module load nome_do_modulo`, e para remover todos os módulos carregados utilize o comando `module purge`. Mais informações relevantes sobre os módulos de ambiente podem ser encontradas no manual do comando (`man module`).

### Espaço em Disco 

O cluster conta com um espaço total em disco de 3 TB, sendo 1 TB reservado para pastas pessoais de usuários e 2 TB para uma área de armazenamento compartilhado por todos os usuários. 

Essa arquitetura de disco é centralizada, o que caracteriza um problema para usuários que fazem muito acesso ao disco. Se um processo fizer constantes leituras e escritas na pasta pessoal do usuário, isso pode causar lentidão para outros processos que acessam o disco.

Portanto a orientação é que o usuário se encarregue de copiar os arquivos que necessitar para o diretório temporário da máquina que está executando o processo e, ao finalizar a computação, copiar os arquivos de volta para o sua pasta pessoal caso necessário. Se o overhead de acesso ao disco for constante e incômodo a outros usuários, o processo será finalizado pelo administrador e o usuário será notificado para alterar seu programa. 

## Conta de usuário

Para criar uma conta é necessário submeter uma solicitação via site do [LCAD](http://www.lcad.cefetmg.br), a coordenação do PPGMMC. Os usuários do cluster são alocados em grupos conforme a finalidade e necessidade de utilização de recursos. Os grupos são:

 * **ppgmmc**: Alunos ou professores do Programa de Pós-Graduação em Modelagem Matemática Computacional
 * **pgss**: Alunos ou professores de outros Programas de Pós-Graduação *Strictu-Sensu* do CEFET-MG
 * **pesq**:  Demais pesquisadores da instituição que não estão vinculados a nenhum programa de de pós-graduação *Strictu-Sensu*
 * **ict**: Professores e alunos de iniciação científica
 * **ensino**: Professores e alunos com projetos de caráter didático específicos

Cada usuário terá uma pasta pessoal, intransferível, com capacidade inicial de 5GB, para armazenar seus programas e dados. Excepcionalmente, e sob requerimento, esta capacidade poderá ser ampliada, observando a disponibilidade de armazenamento total do cluster.

### Acesso ao cluster

O acesso  deve ser feito usando um terminal Linux, via ssh, ou no Windows usando o software [Putty](http://www.putty.org/). 

No terminal linux basta digitar:

```shell
[user@localhost ~]$ ssh -XCp2200 usuario@cluster.lcad.cefetmg.br 
```

Já no Putty é necessário configurar a porta como 2200, e o host como `cluster.lcad.cefetmg.br`. 



## Execução de *jobs*

Para executar uma simulação no cluster é necessário copiar os arquivos para a pasta de usuário usando um cliente FTP ([Filezilla](https://filezilla-project.org/), por exemplo). 
Uma vez copiados os arquivos, para executá-los é necessário escrever um script de submissão que ira informar em qual máquina o processo será executado, entre outras informações relevantes. O software que gerencia a execução dos *jobs* e chamado de escalonador e a próxima seção descreve como utilizá-lo. 

### O escalonador SLURM

O SLURM é o gerenciador de trabalhos do cluster, responsável por receber, alocar, executar e monitorar as submissões de jobs. Para submeter um job é necessário então, além de escolher uma fila de máquinas, informar ao SLURM qual fila foi escolhida, e qual o processo deve ser executado. Isso é feito através de um script Shell. Abaixo temos o script `slurm-teste.sh` que submete na partição large, um programa compilado em C chamado `hello-world`.

```shell
#!/bin/bash
#SBATCH --ntask=1
#SBATCH --qos=part6h
#SBATCH --partition=large

srun ./hello-world
```

Para executar esse processo em segundo plano é necessário utilizar o comando sbatch, como no exemplo abaixo:

```
[user@cluster ~]$ sbatch slurm-teste.sh 
```

Este comando exibirá o JobID da tarefa submetida na linha imediatamente seguinte. É possível ver todos os jobs que estão sendo executados no cluster no momento utilizando o comando `squeue`, ou ver todos os jobs de um usuário que estão sendo executados no momento utilizando o comando `squeue2`.

A diretiva `#SBATCH` define parâmetros do escalonador. Com ela é possível definir o número de tarefas, o número de processadores, a quantidade de memória que será alocada para o processo, o QOS do processo entre outros. Para maiores informações é possível ver o manual do SLURM (no terminal, `man sbatch` ou `man srun`). Os parâmetros mais importantes são listados a seguir:

 * `--ntask`: Define quantos processos iguais serão disparados;
 * `--cpus-per-task`: Em casos de processos multi-thread esse parâmetro é importante, define quantas threads serão alocadas;
 * `--partition`: Define em qual partição o processo será executado; 
 * `--qos`: Define qual Quality Of Service será usado, esse parâmetro garante a alocação justa dos recursos.

Para executar um *job* que utiliza um ou mais módulos específicos é necessário carregá-los no *script* do *sbatch*, como no exemplo abaixo que carrega o CPLEX e utiliza o software:

```shell
#!/bin/bash
#SBATCH --ntask=1
#SBATCH --qos=part6h
#SBATCH --partition=large

module load cplex

srun cplex -f modelo.txt
```


### QoS

QoS (Quality of Service) é um conjunto de políticas de prioridades de tráfego e alocação de recursos implementadas pelo administrador do sistema a fim de garantir a qualidade do serviço para todos os usuários. 
O QoS no cluster é especificamente uma partição de tempo e quantidade de processos, e serve para limitar os recursos alocados por um mesmo usuário simultaneamente. A tabela abaixo mostra os QoS's disponíveis, e seus limites:


QoS|N. Máx. de Jobs|Tempo Máximo
---|------------------|------------
part6h|  100  |6 horas
part12h|50|12 horas
part1d|30|1 dia
part2d|10|2 dias
part10d|3|10 dias
part30d|1|30 dias

Todo usuário está também limitado a executar 100 jobs simultâneos. Caso nenhum QoS seja especificado será utilizado o `part6h`.

