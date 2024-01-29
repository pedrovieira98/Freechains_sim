rm -rf /tmp/var/Freechains/


Reputation(){
	echo "Reputação do Pioneiro"
	echo "$(freechains --port="$A" chain '#series' reps $pioneiro_pub_key)"

	echo "Reputação do Ativo1"
	echo "$(freechains --port="$A" chain '#series' reps $ativo1_pub_key)"

	echo "Reputação do Ativo2"
	echo "$(freechains --port="$B" chain '#series' reps $ativo2_pub_key)"

	echo "Reputação do Troll"
	echo "$(freechains --port="$C" chain '#series' reps $troll_pub_key)"

	echo "Reputação do Newbie"
	echo "$(freechains --port="$B" chain '#series' reps $newbie_pub_key)"
}

hosts_date(){
	freechains-host --port="$A" now "$date"
	freechains-host --port="$B" now "$date"
	freechains-host --port="$C" now "$date"
}


A="9050"
Caminho_A="/tmp/var/Freechains/myhosta/"
gnome-terminal -- freechains-host --port="$A" start $Caminho_A
sleep 1

B="9051"
Caminho_B="/tmp/var/Freechains/myhostb/"
gnome-terminal -- freechains-host --port="$B" start $Caminho_B 

C="9052"
Caminho_C="/tmp/var/Freechains/myhostc/"
gnome-terminal -- freechains-host --port="$C" start $Caminho_C

#CriaÃ§Ã£o do Pioneiro
pioneiro_chave=$(freechains --port="$A" keys pubpvt 'chave-do-pioneiro')
pioneiro_pub_key=$(echo $pioneiro_chave | cut -d' ' -f1)
echo "$pioneiro_pub_key"
pioneiro_pri_key=$(echo $pioneiro_chave | cut -d' ' -f2)
echo "$pioneiro_pri_key"

#CriaÃ§Ã£o do Ativo
ativo1_chave=$(freechains --port="$A" keys pubpvt 'chave-do-ativo1')
ativo1_pub_key=$(echo $ativo1_chave | cut -d' ' -f1)
ativo1_pri_key=$(echo $ativo1_chave | cut -d' ' -f2)

#CriaÃ§Ã£o do Ativo 2
ativo2_chave=$(freechains --port="$B" keys pubpvt 'chave-do-ativo2')
ativo2_pub_key=$(echo $ativo2_chave | cut -d' ' -f1)
ativo2_pri_key=$(echo $ativo2_chave | cut -d' ' -f2)

#CriaÃ§Ã£o do Troll
troll_chave=$(freechains --port="$C" keys pubpvt 'chave-do-troll')
troll_pub_key=$(echo $troll_chave | cut -d' ' -f1)
troll_pri_key=$(echo $troll_chave | cut -d' ' -f2)

#CriaÃ§Ã£o do Newbie
newbie_chave=$(freechains --port="$B" keys pubpvt 'chave-do-newbie')
newbie_pub_key=$(echo $newbie_chave | cut -d' ' -f1)
newbie_pri_key=$(echo $newbie_chave | cut -d' ' -f2)

# Dia 1 -- Criação do fórum e primeiro post pelo pioneiro --
echo "epoch dia 1"
date="2023-10-01 00:00:00.000"
hosts_date

#Criação do fórum
echo "fórum criado"
echo "$(freechains --port="$A" chains join '#series' "$pioneiro_pub_key")"

#Primeiro post pelo Pioneiro explicando ideia do Fórum
pioneiro_post1=$(freechains --port="$A" chain '#series' post inline "Este Ã© um fÃ³rum para conversas e indicaÃ§Ãµes de series" --sign="$pioneiro_pri_key")

Reputation

#Dia 5 -- Entrada dos membros Ativos no fórum --
echo "epoch dia 5"
date="2023-10-05 00:00:00.000"
hosts_date

#Ativo1 se junta e decide postar (está no mesmo nó que o pioneiro)
ativo1_post1=$(freechains --port="$A" chain '#series' post inline "Gosto muito de series" --sign="$ativo1_pri_key")


#Ativo2 e Newbie se juntam ao fórum de series
$(freechains --port="$B" chains join '#series' "$pioneiro_pub_key")
$(freechains --port="$A" peer localhost:"$B" send '#series')

#Pioneiro dá like no post de Ativo1
$(freechains --port="$A" chain '#series' --sign="$pioneiro_pri_key" like "$ativo1_post1")

Reputation

# Dia 10 -- Ativo2 faz um post e Ativo1 faz outro post --
echo "epoch dia 10"
echo "$(freechains-host now "$date + $10")"

ativo2_post1=$(freechains --port="$B" chain '#series' post inline "Minha série favorita é The Walking Dead" --sign="$ativo2_pri_key")
ativo1_post2=$(freechains --port="$A" chain '#series' post inline "Gosto de series de fantasia" --sign="$ativo1_pri_key")

Reputation

#Dia 15 -- Pioneiro da like no post 2 de Ativo1 e no post de Ativo2 --
echo "epoch dia 15"
echo "$(freechains-host now "$date + $15")"

$(freechains --port="$A" chain '#series' --sign="$pioneiro_pri_key" like "$ativo1_post2")

Reputation

# Dia 20 -- Ativo1 e pioneiro dão like no post de Ativo2 --
echo "epoch dia 20"
echo "$(freechains-host now "$date + $20")"

$(freechains --port="$A" chain '#series' like "$ativo2_post1" --sign="$pioneiro_pri_key")
$(freechains --port="$A" chain '#series' like "$ativo2_post1" --sign="$ativo1_pri_key")

Reputation

# Dia 30 -- Entrada do troll no fórum e like de Ativo2 no post de Ativo1 -- 
echo "epoch dia 30"
echo "$(freechains-host now "$date + $30")"

$(freechains --port="$C" chains join '#series' "$pioneiro_pub_key")
$(freechains --host=localhost:"$A" peer localhost:"$C" send '#series')
$(freechains --port="$B" chain '#series' --sign="$ativo2_pri_key" like "$ativo1_post2")

Reputation

# Dia 40 -- Post do troll --
echo "epoch dia 40"
echo "$(freechains-host now "$date + $40")"

troll_post1=$(freechains --port="$C" chain '#series' post inline "Filmes são muito mais legais" --sign="$troll_pri_key")

Reputation

# Dia 50 -- Dislikes no post do troll
echo "epoch dia 50"
echo "$(freechains-host now "$date + $50")"

$(freechains --port="$A" chain '#series' --sign="$pioneiro_pri_key" dislike "$troll_post1")
$(freechains --port="$A" chain '#series' --sign="$ativo1_pri_key" dislike "$troll_post1")
$(freechains --port="$B" chain '#series' --sign="$ativo2_pri_key" dislike "$troll_post1")

Reputation

# Dia 90 -- Verificação de reputação
echo "epoch dia 90"
echo "$(freechains-host now "$date + $90")"


Reputation
