# Freechains_sim
Repositório criado para a simulação de um Fórum utilizando o protocolo **Freechains** na disciplina de Redes P2P do Programa de Mestrado em Engenharia Eletrônica da UERJ (PEL-UERJ).

## Como executar

Baixe o arquivo simul.sh e execute-o em seu terminal.

```
./simul.sh
```


## Intenção da Aplicação

A intenção é a de simular um fórum de séries, onde os usuários irão interagir durante 3 dias, verificando o comportamento do protocolo Freechains.

## Usuários e suas Atividades

**Pioneiro**: Criador do fórum e principal mantenedor.

**Ativo 1**: Usuário muito ativo na comunidade, gosta de postar e ler todas as publicações.

**Ativo 2**: Usuário muito ativo, prefere ler do que comentar, porém está sempre visualizando e dando sua opinião por likes e deslikes em todos os posts.

**Troll**: Usuário com o intuito de que o fórum não funcione de maneira adequada.

**Newbie**: Usuário novo e com pouca atividade, ainda aprendendo sobre os assuntos.

## Usuários do Fórum por nó

**Nó A**: Supondo uma casa, onde *Pioneiro* e *Ativo 1* são os moradores e participam deste mesmo fórum.

**Nó B**: Usuários *Ativo 2* e *Newbie*, fazem parte deste mesmo nó, numa situação similar à do Nó A.

**Nó C**: Nó no qual o usuário malicioso, *Troll*, está presente, totalmente apartado dos outros, de modo a simular que sua identidade seja completamente desconhecido do restante do fórum.

## Entradas no Fórum

O usuário *Pioneiro* cria o fórum e compartilha com *Ativo 1* e então *Pioneiro* decide divulgar publicamente as chaves de acesso ao fórum, permitindo a entrada dos usuários *Ativo 2*, *Newbie* e *Troll*.

## Reação dos Autores

Os autores com maior recorrência de participação irão trocar likes entre si (Pioneiro, Ativo1 e Ativo2), enquanto o newbie postará com menor frequência, sendo mais um observador. O troll, por sua vez, fará uma postagem a qual os membros do grupo não gostarão, portanto, ganhará muitos dislikes e não conseguirá postar mais nenhuma mensagem.

## Conclusão

Ao finalizar, conclui-se que o protocolo Freechains é capaz de criar um sistema de consenso baseado em reputação, onde um membro o qual as postagens não são compatíveis com o foco do grupo, terá sua mensagem excluída da cadeia e os outros poderão postar baseado em sua reputação no momento (verificando se a mensagem será bloqueada diretamente, a ver se o membro possui reputação suficiente, ou se será incluída na cadeia, passando pelo critério dos demais membros).

