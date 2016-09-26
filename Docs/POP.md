# Procedimento Operacional Padrão 

Este POP destina-se a instruir sobre a instalação e configuração do sistema operacional Rocks Cluster em um ambiente 
de computação distribuido e de alto-desempenho. Foi elaborado no CEFET-MG no Laboratório de Computação de Alto Desempenho
para guiar a instalação do cluster do Programa de Pós-Graduação em Modelagem Matemática e Computacional (PPG-MMC).

Durante a instalação pode ser necessário consultar a documentação da versão do Rocks Cluster utilizada (http://central6.rocksclusters.org/roll-documentation/base/6.2/). 

## Instalação do sistema operacional 

1. Baixe o ISO Jumbo para o Rocks Cluster 6.2 em http://www.rocksclusters.org/wordpress/?page_id=508 grave em um DVD 
2. Insira o CD na máquina escolhida como frontend do Cluster. No caso do F37, a máquina é a 37ª máquina do rack e reinicie a máquina
3. Na tela inicial do boot do Rocks Cluster digite "build" e pressione enter
4. Na tela em que se deve selecionar as rolls que serão instaladas, escolha instalá-las a partir do DVD
5. Selecione: base, kernel, os, area51, bio, ganglia, hpc, fingerprint, perl, python, web-server; clique em avançar
6. Preencha o formulário com a URL do cluster (cluster.lcad.cefetmg.br), e os dados do administrador do sistema
7. Configure o IP da interface externa (em1) para 200.131.37.158 e a máscara de rede para 255.255.255.0
8. Configure o IP da interface interna (em2) para 10.1.1.1 e a máscara de rede para 255.255.0.0
9. Configure o DNS e o Gateway de rede. Os endereços devem ser obtidos do administrador da rede do campus
10. Particione o disco manualmente, seguindo esquema abaixo e então confirme:
	* / -> 200GB
	* /var -> 200GB
	* swap -> 48GB
	* /state/partition1 -> restante do espaço disponível
11. Deste ponto em diante a instalação prosseguirá até a máquina ser reiniciada

## Configuração do cluster

12. Quando a máquina terminar a instalação, clone o repositório git no link https://github.com/juanlopesf/ClusterDeployScript.git
13. Execute o script install.sh
14. Quando iniciar a instalação do NAS, inicie a máquina que recebera o appliance e aguarde o boot pela rede e aguarde que a configuração do particionamento se inicie
15. Particione o disco manualmente seguindo o esquema abaixo:
	* / -> 100GB
	* /var -> 100GB
	* /export/data1 -> restante do espaço disponível
16. Aguarde o fim da execução do script, isso certamente vai demorar algumas horas (leve um livro)
17. Após o fim da instalação, cheque os logs em ~/ClusterDeployScript/Logs. Eles estão organizados por passo da instalação, e os passos de configuração e instalação de software são independentes
18. Crie um usuário admin e escolha uma senha segura para ele

## Instalação dos computes

19. Abra um terminal no frontend, digite insert-ethers
20. Selecione a opção "Compute" e digite Enter
21. Ligue computador por computador e selecione o boot pela rede
22. Os computes instalarão automaticamente a partir deste passo. Pode ser que não seja possível instalar todos de uma vez, por causa do gargalo da rede, então faça em parcelas
