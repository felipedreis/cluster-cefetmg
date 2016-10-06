# Manual de utilização do cluster

O Cluster F37 é um ambiente de computação de alto desempenho para fins de pesquisa do programa de pós-graduação em Modelagem Matemática e Computacional, mantido pelo laboratório de computação de alto desempenho (LCAD) do CEFET-MG. O F37 é aberto a alunos e professores da instituição que queiram desenvolver projetos de pesquisa e ensino.


## Conta de usuário

Para criar uma conta é necessário submeter uma solicitação no site do [LCAD](http://www.lcad.cefetmg.br), na área solicitações. A solicitação da conta será analisada pela coordenação do MMC. Os usuários do cluster são alocados em grupos de acordo com o departamento em que o mesmo está lotado na instituição, os possíveis grupos são:

 * **ppgmmc**: Alunos ou professores do Programa de Pós-Graduação em Modelagem Matemática Computacional
 * **pgss**: Alunos ou professores de outros Programas de Pós-Graduação *Strictu-Sensu*
 * **pesq**: Pesquisadores da instituição que não estão filiados a nenhum programa de pesquisa
 * **ict**: Professores e alunos de iniciação científica
 * **didático**: Professores e alunos que queiram usar o cluster para fins didáticos

## Acessando o cluster

O acesso ao F37 pode ser feito usando o terminal Linux, via ssh, ou no Windows usando o [Putty](http://www.putty.org/). No terminal linux basta digitar:

```shell
[user@localhost ~]$ ssh -XCp2200 usuario@cluster.lcad.cefetmg.br 
```

No Putty é necessário configurar a porta como a 2200, e o host como `cluster.lcad.cefetmg.br`. 

## Arquitetura de Hardware

O F37 conta com 32 máquinas de uso compartilhado, em 3 diferentes configurações. Essas máquinas estão agrupadas nas filas **small**, **medium**, **large**.

 * **small**: 11 Máquinas Dell, processador XEON 8 threads (8 físicas), sem hyperthread, 48GB RAM (em média)
 * **medium**: 17 Máquinas Dell, processador XEON 16 threads (8 físicas), com hyperthread, 32 GB RAM (em média)
 * **large**: 4 Máquinas Supermicro, 64 threads (64 físicas), sem hyperthread, 128 GB RAM

As máquinas estão conectadas a uma rede Gigabit que atinge uma largura de banda de 1 Gb/s.

## Arquitetura de Software

Para executar uma simulação no Cluster é necessário copiar os arquivos para a pasta de usuário usando um cliente FTP ([Filezilla](https://filezilla-project.org/), por exemplo). O cluster conta com uma arquitetura de software disponível para auxiliar na execução de simulações. Entre esses softwares estão o escalonador, compiladores e interpretadores mais comuns, middlewares e ferramentas. As seções seguintes esclarecem os detalhes da utilização dessa arquitetura. 
O sistema operacional do cluster F37 é o CentOS 6.6 e todas as máquinas têm os mesmos softwares instalados.

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
[user@clusterf37 ~]$ sbatch slurm-teste.sh 
```

Este comando exibirá o JobID da tarefa submetida na linha imediatamente seguinte. É possível ver todos os jobs que estão sendo executados no cluster no momento utilizando o comando `squeue`, ou ver todos os jobs de um usuário que estão sendo executados no momento utilizando o comando `squeue2`.

A diretiva `#SBATCH` define parâmetros do escalonador. Com ela é possível definir o número de tarefas, o número de processadores, a quantidade de memória que será alocada para o processo, o QOS do processo entre outros. Para maiores informações é possível ver o manual do SLURM (no terminal, `man sbatch` ou `man srun`). Os parâmetros mais importantes são listados a seguir:

 * `--ntask`: Define quantos processos iguais serão disparados
 * `--cpus-per-task`: Em casos de processos multi-thread esse parâmetro é importante, define quantas threads serão alocadas
 * `--partition`: Define em qual partição o processo será executado 
 * `--qos`: Define qual Quality Of Service será usado, esse parâmetro garante a alocação justa dos recursos

#### QoS

QoS (Quality of Service) é um conjunto de políticas de prioridades de tráfego e alocação de recursos implementadas pelo administrador do sistema a fim de garantir a qualidade do serviço para todos os usuários. 
O QoS no F37 é especificamente uma partição de tempo e quantidade de processos, e serve para limitar os recursos alocados por um mesmo usuário simultaneamente. A tabela abaixo mostra os QoS's presentes no F37, e seus limites:


QoS|N. Máx. de Jobs|Tempo Máximo
:---:|------------------:|------------
part6h|  100  |6 horas
part12h|50|12 horas
part1d|30|1 dia
part2d|10|2 dias
part10d|3|10 dias
part30d|1|30 dias

Todo usuário está também limitado a executar 100 jobs simultâneos. Caso nenhum QoS seja especificado será utilizado o `part6h`.

### Softwares e bibliotecas instaladas 

O cluster foi instalado com compiladores/interpretadores/softwares mais utilizados nas áreas de pesquisa em modelagem matemática computacional. O usuário conta com as seguintes linguagens de programação:
 
 * BLAST 2.2.25
 * CUDA 7.0.28
 * Java Oracle 7u80, 32 bits e 64 bits
 * Java Oracle 8u92, 32 bits e 64 bits
 * Python 2.7
 * Python 3.4
 * Octave 4.0.1
 * R 3.2.4
 * GCC 6.0.1 (Inclui C, C++, Fortran e Go)

As bibliotecas instaladas:

 * blas
 * atlas
 * lapack 
 * libgcc

Os seguintes softwares:
 
 * CPLEX 12.6.3
 * GAMESS
 * MPI 1.5.4
 * MPICH 3.2
 * Trinity 2.2.0

Outras ferramentas instaladas:
 
 * Cmake 3.5.2
 * Postgres 9.4
 * Valgrind 3.11
 * XVFB

#### Módulos de ambiente

Environment Modules é um recurso do Linux que permite que exista mais de uma versão do mesmo software instalado na máquina de forma que não haja conflito. Eles dão flexibilidade ao usuário que pode escolher qual versão do software usar.

Com exceção das bibliotecas, todos os softwares estão disponíveis somente através dos módulos de ambiente, i.e., eles não são carregados por padrão, mas devem ser informados pelo usuário quando serão usados. O comando utilizado para gerenciar os módulos carregados é o `module`.
É possível listar os módulos com ` module avail`.

```shell
[user@clusterf37 ~]$ module avail

------------------------------------------------------------------------ /usr/share/Modules/modulefiles ------------------------------------------------------------------------
dot              module-git       module-info      modules          null             opt-python       rocks-openmpi    rocks-openmpi_ib use.own

------------------------------------------------------------------------------- /etc/modulefiles -------------------------------------------------------------------------------
autodocksuite  cplex          gamess         gmap           jdk7           jdk8_32        mrbayes        openmpi-x86_64 python3.4      tigr           wgs
clustalw       emboss         gcc6.1         gromacs        jdk7_32        mpiblast       ncbi-blast     phylip         R-3.2.4        trinity
cmake          fasta          glimmer        hmmer          jdk8           mpich          octave         python2.7      t_coffee       valgrind


```

Para carregar um módulo utilize `module load nome_do_modulo`, e para remover todos os módulos carregados utilize `module purge`. Mais informações relevantes sobre os módulos de ambiente podem ser encontradas no manual do comando (`man module`).

Para executar um job que utiliza um ou mais módulos específicos é necessário carregá-los no script do sbatch, como no exemplo abaixo que carrega o cplex e utiliza o software:

<pre>
#!/bin/bash
#SBATCH --ntask=1
#SBATCH --qos=part6h
#SBATCH --partition=large

<b>module load cplex</b>

srun cplex -f modelo.txt
</pre>


## Disponibilidade de disco

O cluster conta com um espaço em disco de 3 TB, sendo 1 TB reservado para home de usuários e 2 TB em um storage para uso compartilhado. Todo usuário tem uma cota inicial de disco de 5GB. Essa cota é expansível de acordo com a necessidade do usuário e da disponibilidade em disco. Tanto a expansão da cota em disco quanto o acesso ao storage devem passar por analise e aprovação do administrador do sistema.

Essa arquitetura de disco é centralizada, o que caracteriza um problema para usuários que fazem muito acesso ao disco. Se um processo fizer constantes leituras e escritas no home do usuário, isso pode causar lentidão para outros processos que acessam o disco. Portanto a orientação é que o usuário se encarregue de copiar os arquivos que necessitar para o diretório temporário da máquina que está executando o processo e, ao finalizar a computação, copiar os arquivos de volta para o home caso necessário. Se o overhead de acesso ao home for constante e incômodo o processo será finalizado pelo administrador e o usuário será notificado para alterar seu programa. 
