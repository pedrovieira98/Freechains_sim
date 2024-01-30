#!/bin/bash

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

	freechains-host --port="$A" now "$(date -d "$i day" +%s)"
	freechains-host --port="$B" now "$(date -d "$i day" +%s)"
	freechains-host --port="$C" now "$(date -d "$i day" +%s)"
}

sync_all(){
	freechains --port="$A" peer localhost:"$B" send '#series'
	freechains --port="$B" peer localhost:"$A" send '#series'

	freechains --port="$A" peer localhost:"$C" send '#series'
	freechains --port="$C" peer localhost:"$A" send '#series'

	freechains --port="$C" peer localhost:"$B" send '#series'
	freechains --port="$B" peer localhost:"$C" send '#series'
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

freechains --port="$A" chains join '#series' "$pioneiro_pub_key"
freechains --port="$B" chains join '#series' "$pioneiro_pub_key"
freechains --port="$C" chains join '#series' "$pioneiro_pub_key"

for (( i = 1; i <= 90; i++ ))
do
	echo "Começo do dia $i"
	hosts_date
	sync_all

	# Pioneiro
	if [ $(($i % 1)) -eq 0 ]; then
		pioneiro_post=$(freechains --port="$A" chain '#series' post inline 'Chat de séries' --sign="$pioneiro_pri_key")
		freechains --port="$A" chain '#series' post inline 'Chat de séries' --sign="$pioneiro_pri_key"


		if [ "$(freechains chain --port="$A" '#series' reps '$pioneiro_pub_key')" -gt 4 ] && [ $i -gt 2 ]; then
			freechains chain '#series' --port="$A" like '$ativo1_post' --sign="$pioneiro_pri_key"
			freechains chain '#series' --port="$A" like '$ativo2_post' --sign="$pioneiro_pri_key"
			freechains chain '#series' --port="$A" dislike '$troll_post' --sign="$pioneiro_pri_key"
		fi
	fi

	# Ativo1
	if [ $(($i % 2)) -eq 0 ]; then
		ativo1_post=$(freechains --port="$A" chain '#series' post inline 'Gosto de séries' --sign="$ativo1_pri_key")
		freechains --port="$A" chain '#series' post inline 'Gosto de séries' --sign="$ativo1_pri_key"

		if [ "$(freechains chain --port="$A" '#series' reps '$ativo1_pub_key')" -gt 5 ] && [ $i -gt 2 ]; then
			freechains chain '#series' --port="$A" like '$pioneiro_post' --sign="$ativo1_pri_key"
			freechains chain '#series' --port="$A" dislike '$troll_post' --sign="$ativo2_pri_key"
		fi

	fi

	# Ativo2 
	if [ $(($i % 3)) -eq 0 ]; then
		ativo2_post=$(freechains --port="$B" chain '#series' post inline 'Séries são legais' --sign="$ativo2_pri_key")
		freechains --port="$B" chain '#series' post inline 'Séries são legais' --sign="$ativo2_pri_key"

		if [ "$(freechains chain --port="$B" '#series' reps '$ativo2_pub_key')" -gt 6 ] && [ $i -gt 1 ]; then
			freechains chain '#series' --port="$B" like '$ativo1_post' --sign="$ativo2_pri_key"
			freechains chain '#series' --port="$B" like '$newbie_post' --sign="$ativo2_pri_key"
			freechains chain '#series' --port="$B" dislike '$troll_post' --sign="$pioneiro_pri_key"
		fi

	fi

	# Newbie 
	if [ $(($i % 6)) -eq 0 ]; then
		newbie_post=$(freechains --port="$B" chain '#series' post inline 'O que estou fazendo aqui?' --sign="$newbie_pri_key")
		freechains --port="$B" chain '#series' post inline 'O que estou fazendo aqui?' --sign="$newbie_pri_key"
	fi

	# Troll 
	if [ $(($i % 2)) -eq 0 ]; then
		troll_post=$(freechains --port="$C" chain '#series' post inline 'Eu sou troll' --sign="$troll_pri_key")
		freechains --port="$C" chain '#series' post inline 'Eu sou troll' --sign="$troll_pri_key"

	fi

	Reputation

done

echo "Terminada a simulação"
