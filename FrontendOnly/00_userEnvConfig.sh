#!/bin/bash

#define a política de criação de senhas
#lcredit=-1 - pelo menos um caracter em lowercase
#ucredit=-1 - pelo menos um caracter em uppercase
#dcredit=-1 - pelo menos um digito
#ocredit=-1 - pelo menos um caracter especial
sed -i 's/^password    requisite.*/password requisite pam_cracklib.so try_first_pass retry=3 minlength=10 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1/g' /etc/pam.d/system-auth

#remove do bash de usuário as variáveis carregadas por padrao
chmod 700 /etc/profile.d/{bio.{sh,csh},java.{sh,csh},rocks-hpc.{sh,csh},rocks-python.{sh,csh},ganglia-binaries.{sh,csh},rocks-devel.{sh,csh}}