# Manual de utilização do cluster

O Cluster F37 é um ambiente de computação de alto desempenho para fins de pesquisa do programa de pós-graduação em Modelagem Matemática e Computacional, mantido pelo laboratório de computação de alto desempenho (LCAD) do CEFET-MG. O F37 é aberto a alunos e professores da instituição que queiram desenvolver projetos de pesquisa e ensino.


## Conta de usuário

Para criar uma conta é necessário submeter uma solicitação no site http://www.lcad.cefetmg.br, na área solicitações. A solicitação da conta será analisada pela coordenação do MMC.

## Acessando o cluster

O acesso ao F37 pode ser feito usando o terminal Linux, via ssh, ou no Windows usando o Putty.

## Arquitetura de Hardware

O F37 conta com 34 máquinas de uso compartilhado, em 3 diferentes configurações. Essas máquinas estão agrupadas nas filas **small**, **medium**, **large**.
 * **small**: Máquinas Dell, processador XEON 8 threads (8 físicas), sem hyperthread, 48GB RAM (em média)
 * **medium**: Máquinas Dell, processador XEON 16 threads (8 físicas), com hyperthread, 32 GB RAM (em média)
 * **large**: Máquinas Supermicro, 64 threads (64 físicas), sem hyperthread, 128 GB RAM

## Arquitetura de Software

### O escalonador SLURM

O SLURM é o gerenciador de trabalhos do cluster, responsável por receber as submissões de jobs. Para submeter um job é necessário então, alem de escolher uma fila de máquinas, informar para o SLURM qual fila foi escolhida, e qual o processo deve ser executado. Isso é feito através de um script Shell. Abaixo temos um exemplo de um script que submete na partição large, um programa compilado em C chamado hello-world.

```shell
#!/bin/bash
#SBATCH --ntask=1
#SBATCH --partition=large
srun ./hello-world

```

### Softwares e bibliotecas instaladas 

O cluster foi instalado com compiladores/interpretadores/softwares mais utilizados nas áreas de pesquisa em modelagem matemática computacional. O usuário conta com as seguintes linguagens de programação:
 * CUDA 
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

Com exceção das bibliotecas, todos os softwares estão disponíveis somente através dos módulos de ambiente, i.e., eles não são carregados por padrão, mas devem ser informados pelo usuário quando serão usados.
