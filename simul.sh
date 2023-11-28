#!/bin/bash

#Pega tempo atual

time = $freechains-host now

#Nó A
A = "8330"
Caminho_A = "/tmp/var"
freechains-host --port="$A" start "$Caminho_A"

#Nó B
B = "8331"
Caminho_B = "/tmp/var"
freechains-host --port="$B" start "$Caminho_B"

#Nó C
C = "8332"
Caminho_C = "/tmp/var"
freechains-host --port="$C" start "$Caminho_C"

#Criação do Pioneiro
pioneiro_chave = $(freechains --port="$A" crypto pubpvt 'chave-do-pioneiro')
pioneiro_pub_key=$(echo $pioneiro_chave | cut -d' ' -f1);
pioneiro_pri_key=$(echo $pioneiro_chave | cut -d' ' -f2);

#Criação do Ativo 1
ativo1_chave = $(freechains --port="$A" crypto pubpvt 'chave-do-ativo1')
ativo1_pub_key=$(echo $ativo1_chave | cut -d' ' -f1);
ativo1_pri_key=$(echo $ativo1_chave | cut -d' ' -f2);

#Criação do Ativo 2
ativo2_chave = $(freechains --port="$B" crypto pubpvt 'chave-do-ativo2')
ativo2_pub_key=$(echo $ativo2_chave | cut -d' ' -f1);
ativo2_pri_key=$(echo $ativo2_chave | cut -d' ' -f2);

#Criação do Troll
troll_chave = $(freechains --port="$C" crypto pubpvt 'chave-do-troll')
troll_pub_key=$(echo $troll_chave | cut -d' ' -f1);
troll_pri_key=$(echo $troll_chave | cut -d' ' -f2);

#Criação do Newbie
newbie_chave = $(freechains --port="$B" crypto pubpvt 'chave-do-newbie')
newbie_pub_key=$(echo $newbie_chave | cut -d' ' -f1);
newbie_pri_key=$(echo $newbie_chave | cut -d' ' -f2);

#Criação do fórum
freechains --port="$A" chains join '#séries' "$pioneiro_pub_key"

#Primeiro post pelo Pioneiro explicando ideia do Fórum
freechains --port="$A" --sign="$pioneiro_pri_key" chain '#séries' post inline "Este é um fórum para conversas e indicações de séries"
