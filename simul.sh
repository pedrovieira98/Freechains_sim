#!/bin/sh

#Pega tempo atual
time = $freechains-host now
echo $time

#Função para obter reputação
Reputation(){
    echo "Reputação do Pioneiro"
    echo "freechains --host=localhost:"$A" chain '#séries' reps $pioneiro_pub_key"

    echo "Reputação do Ativo1"
    echo "freechains --host=localhost:"$A" chain '#séries' reps $ativo1_pub_key"

    echo "Reputação do Ativo2"
    echo "freechains --host=localhost:"$B" chain '#séries' reps $ativo2_pub_key"

    echo "Reputação do Troll"
    echo "freechains --host=localhost:"$C" chain '#séries' reps $troll_pub_key"

    echo "Reputação do Newbie"
    echo "freechains --host=localhost:"$B" chain '#séries' reps $newbie_pub_key"
}


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

# Dia 1 -- Criação do fórum e primeiro post pelo pioneiro --

#Criação do fórum
freechains --port="$A" chains join '#séries' "$pioneiro_pub_key"

#Primeiro post pelo Pioneiro explicando ideia do Fórum
pioneiro_post1 = $(freechains --port="$A" chain '#séries' post inline "Este é um fórum para conversas e indicações de séries" --sign="$pioneiro_pri_key")



# Dia 5 -- Entrada dos membros Ativos no fórum --

#Ativo1 se junta e decide postar (está no mesmo nó que o pioneiro)
ativo1_post1 = $(freechains --port="$A" chain '#séries' post inline "Gosto muito de séries" --sign="$ativo1_pri_key")


#Ativo2 e Newbie se juntam ao fórum de séries
freechains --port="$B" chains join '#séries' "$pioneiro_pub_key"
freechains --host=localhost:"$A" peer localhost:"$B" recv '#séries'

#Pioneiro dá like no post de Ativo1
freechains --port="$A" chain '#séries' --sign="$pioneiro_pri_key" like "$ativo1_post1"


# Dia 10 -- Ativo2 faz um post e Ativo1 faz outro post --

ativo2_post1 = $(freechains --port="$B" chain '#séries' post inline "Minha série favorita é The Walking Dead" --sign="$ativo2_pri_key")
ativo1_post2 = $(freechains --port="$A" chain '#séries' post inline "Gosto de séries de fantasia" --sign="$ativo1_pri_key")

#Dia 15 -- Pioneiro da like no post 2 de Ativo1 --

freechains --port="$A" chain '#séries' --sign="$pioneiro_pri_key" like "$ativo1_post2"

# Dia 20 -- Ativo1 e pioneiro dão like no post de Ativo2 --

freechains --port="$A" chain '#séries' --sign="$pioneiro_pri_key" like "$ativo2_post1"
freechains --port="$A" chain '#séries' --sign="$ativo1_pri_key" like "$ativo2_post1"


# Dia 30 -- Entrada do troll no fórum e like de Ativo2 no post de Ativo1 -- 

freechains --host=localhost:"$A" peer localhost:"$C" recv '#séries'
freechains --port="$B" chain '#séries' --sign="$ativo2_pri_key" like "$ativo1_post2"

# Dia 40 -- Post do troll --

troll_post1 = $(freechains --port="$C" chain '#séries' post inline "Filmes são muito mais legais" --sign="$troll_pri_key")

# Dia 50 -- Dislikes no post do troll

freechains --port="$A" chain '#séries' --sign="$pioneiro_pri_key" dislike "$troll_post1"
freechains --port="$A" chain '#séries' --sign="$ativo1_pri_key" dislike "$troll_post1"
freechains --port="$B" chain '#séries' --sign="$ativo2_pri_key" dislike "$troll_post1"

# Dia 90 -- Verificação de reputação

Reputation