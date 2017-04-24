# Uma tabela Hash implementada em Assembly MIPS para a matéria de Organização de Computadores Digitais
# Membros: Bruno Coelho, Gabriel Cruz, Gabriel Cyrillo, Alex Sander

.data
.align 0
	strNewline:	.asciiz "\n"
	strSpace:	.asciiz " "
	strInsert:	.asciiz "\nDigite o valor a ser inserido: "
	strRemove:	.asciiz "\nDigite o valor a ser removido: "
	strInicio:	.asciiz "Tabela Hash de inteiros implementada em MIPS Assembly.\n"
	strOpcao:	.asciiz  "Digite 1 para a inserção de um número, 2 para remoção, 3 para busca, 4 para a visualazição da tabela e 5 para sair do programa.\n"
	strInvalidInput: .asciiz "Entrada inválida\n"
	strExit:.asciiz "Finalizando programa\n"
	strInsertError: .asciiz "O número digitado já foi inserido.\n"
	strRemoveError: .asciiz "Não foi possível remover o número. Entrada inválida ou não existente na tabela Hash. \n"
	
	# Impressao Strings
	strInicioImpressao:	.asciiz "\nImpressão da Tabela Hash\n"
	strInicioLinhaImpressao:	.asciiz "Linha["
	strFimLinhaImpressao:	.asciiz "]: "
	strLinhaVaziaImpressao:	.asciiz " **Linha Vazia**"
	strFimImpressao: .asciiz "Fim da impressão, voltando ao menu\n"
	
	#Search Strings
	strSearchQuerry:
		.asciiz "Digite a chave a ser consultada ou -1 para retornar: "
	strSearchNotFound:
		.asciiz "Chave não encontrada\n"
	strSearchFound0:
		.asciiz "Chave encontrada na "
	strSearchFound1:
		.asciiz "a posicao na hash, "
	strSearchFound2:
		.asciiz "a posicao na lista\n"
	strInvalidSearch:
		.asciiz "Chave inválida. Retornando ao menu.\n"

.text
.globl main

main:
	li $v0, 4				# imprime string
	la $a0, strInicio
	syscall

	# aloca as 16 posições do vetor
	li $v0, 9				# sbrk
	li $a0, 64				# 64 = 16 * 4(tam de um end) bytes
	syscall
	move $s0, $v0			# $s0 = malloc(16*sizeof(nó*))

	li $t0, 0				# i = 0
	move $t1, $s0 			# t1 = vetor[0]
	j forInicializa
	
forInicializa:
	# Para cada uma ds posições do vetor, alocamos um nó vazio. 
	# $t0 = i
	# $t1 = vetor[0] inicialmente
	
	bge $t0, 16, menu		# while (i < 16)
	li $v0, 9				# sbrk
	li $a0, 12				# 12 = no anterior(end = 4) + inteiro(word = 4) + proximo no(end = 4)
	syscall					# $v0 = malloc(sizeof(nó))

	move $t2, $v0			# t2 = novo_no

	sw $t2, 0($t1)			# vetor[i] = novo_no
	addi $t0, $t0, 1		# i++
	addi $t1, $t1, 4		# t1 = vetor[i]

	li $t3, -1				# $t3 = flag para não existe = -1
	sw $zero, 0($t2)		# no->anterior = zero
	sw $t3, 4($t2)			# no->valor = -1
	sw $zero, 8($t2)		# no->prox = zero
	j forInicializa

menu:
	li $v0, 4				# imprime string
	la $a0, strOpcao
	syscall
	li $v0, 5				# ler inteiro
	syscall 				# numero digitado em $v0
	move $s1, $v0			# guardando o numero em s1

	beq $s1, +1, insercao
	beq $s1, +2, remocao
	beq $s1, +3, search
	beq $s1, +4 impressao
	beq $s1, +5, endProgram
	j invalidInput			# se chegar aqui, o usuario digitou algum número não valido


# Funções Placeholders, depois coloquem as suas partes aqui.

insercao:

	# $t0 = valor a ser inserido
	# $t1 = posicao de insercao no vetor
	# $t2 = aux(16)
	# $t3 = $s0 = comeco do vetor
	# $t4 = valores da lista
	# $t5 = nó criado
	# $t6 = endereco do no anterior

	li $v0, 4				# imprimir string que pede valor
	la $a0, strInsert
	syscall			

	jal leInt 				# inteiro lido em $v0
	move $t0, $v0			# move inteiro lido para $t0
	
	# verifica se o inteiro digitado é positivo
	blt $t0, $zero, invalidInput

	#fazer mod
	li $t2, 16
	div $t0, $t2			# $t0/16
	mfhi $t1 				# $t1 = $t0 % 16
	
	#acessar posicao do vetor
	move $t3, $s0
	mul $t1, $t1, 4 		# quantidade de bytes de deslocamento até a posicao desejada
	
	add $t1, $t3, $t1 		# posicao de insercao
	move $t3, $t1
	lw $t3, 0($t3)

	#percorrer lista
	lw $t4, 4($t3)			# t4 = nó

	findPlace:
		blt $t4, $zero, found 	# while no->valor >= 0
		bge $t4, $t0, found 	# while no->valor < my_valor
		lw  $t3, 8($t3)         # vai para o prox no
		lw $t4, 4($t3) 		# pega valor do prox no
		j findPlace

	#inserir
	found:
		beq $t4, $t0, insertError #número repetido

	# inserção válida
	# criar novo nó
	li $v0, 9				# sbrk
	li $a0, 12				# 12 = no anterior(end = 4) + inteiro(word = 4) + proximo no(end = 4)
	syscall					# $v0 = malloc(sizeof(nó))

	move $t5, $v0			# t5 = novo_no
	
	#atribuir valor ao nó
	sw $t0, 4($t5)
		
	#rearranjar ponteiros
	lw $t6, 0($t3) 			#$t6 eh o no anterior
		
	sw $t5, 0($t3) 			# aponta #t3 para novo_no
	beq $t6, $zero, isFirst
	sw $t5, 8($t6) 			# aponta anterior para novo_no se $t6 != 0
	j continue
	
	isFirst: # caso especial se for o primeiro nó na lista
		sw $t5, 0($t1) # muda o endereco guardado no vetor pois o primeiro elemento da lista foi trocado
	continue:

	sw $t3, 8($t5) 		# aponta novo_no para $t3
	sw $t6, 0($t5) 		# aponta novo_no para anterior

	j menu

remocao:
	# Imprime string que pede valor
	li $v0, 4 
	la $a0, strRemove
	syscall
	
	# Lê do usuário o inteiro que deve ser removido 
	jal leInt 			# $v0 = int(input())
	move $t0, $v0		# $t0 = $v0
	blt $t0, $zero, removeError
	
	# Faz mod, a fim de achar a posição para a procura do elemento
	li $t2, 16
	div $t0, $t2		# $t0/16
	mfhi $t1 			# $t1 = $t0 % 16
	
	li $t3, 4			# Endereço da lista = (end. do Hash) + 4 * mod
	move $t6, $s0	
	mul $t1, $t1, $t3
	add $t6, $t6, $t1
	
	lw $t6, 0($t6) 		# Acesse o endereço que contém o primeiro nó da lista
	li $t7, -1
	
searchRemocao:
	# Leitura do nó atual
	lw $t0, 0($t6)		# $t0 (previous)
	lw $t1, 4($t6)		# $t1 (current)
	lw $t2, 8($t6)		# $t2 (next)
	
	beq $t1, $v0, movePointersRemocao # Se acha-lo, remova-o
	beq $t1, $t7, removeError	 	  # Caso a lista acabe e não tenha achado, imprima uma menssagem de erro
	
	move $t6, $t2		# Continue a procurar na lista
	j searchRemocao
	
movePointersRemocao:
	# Caso seja o primeiro elemento (não havendo antecessor), trate como exceção
	beq $t0, $zero, firstElementRemocao
	
	sw $t0, 0($t2)			# o anterior do próximo nó recebe o anterior do nó atual
	sw $t2, 8($t0)			# o próximo do nó anterior recebe o próximo do nó atual
	
	j menu
	
firstElementRemocao:
	lw $t7, 4($t2)			# Caso seja o primeiro elemento da lista, copie parte do próximo elemento
	lw $t8, 8($t2)			# para ele (o valor e o ponteiro para o próximo nó. 
							# O ponteiro anterior continua o mesmo, contendo $zero)
	sw $t7, 4($t6)
	sw $t8, 8($t6)
	
	lw $t2, 8($t2)			# Vá para o próximo nó e atualize o seu ponteiro para anterior
	beq $t2, $zero, menu	# Só se houver próximo nó. Senão, volte para o menu
	sw $t6, 0($t2)
	
	j menu

##### Busca
search:
	#Search por Alex Sander R. Silva - 9779350
	#s0 = &hash[0]
	#t0 = key
	#t1 = -1
	#t2 = 16
	#t3 = ptr
	#t4 = value
	#t5 = hashPos
	#t6 = listPos
	
	#init
	li $t1, -1	#t1 = -1
	li $t2, 16	#t2 = 16

sNextQuerry:
	#Print str SearchQuerry
	li $v0, 4
	la $a0, strSearchQuerry
	syscall
	
	#Scan int key
	li $v0, 5
	syscall
	
	move $t0, $a0	#t0 = key
	li $t6, 0		#t6 = listPos = 0
	
	#While key >= 0
	blt $t0, $zero, sEndSearch
		#hashPos = key % 16
		div $t0, $t2
		mfhi $t5
		
		#ptr = hash[hashPos] = (node *)
		mul $t3, $t5, 4
		add $t3, $t3, $s0
		
		#value = node->value
		lw $t4, 4($t3)

	sListSearch:
		#While (value != -1 and value > key)
		beq $t4, $t1, sEndListSearch
		bgt $t4, $t0, sEndListSearch
			#pos = node->next = (node *)
			lw $t3, 8($t3)
			
			#value = node->value
			lw $t4, 4($t3)
			
			#listPos++
			addi, $t6, $t6, 1
		j sListSearch
		
		
	sEndListSearch:
		#Value == key => Found
		beq $t3, $t0, sFound
	
	sNotFound:
		#Print str SearchNotFound
		li $v0, 4
		la $a0, strSearchNotFound
		syscall
		
		j sNextQuerry
	
	sFound:
		#Print str SearchFound0
		li $v0, 4
		la $a0, strSearchFound0
		syscall
		
		#Print int hashPos
		li $v0, 1
		move $a0, $t5
		syscall
		
		#Print str SearchFound1
		li $v0, 4
		la $a0, strSearchFound1
		syscall
		
		#Print int listPos
		li $v0, 1
		move $a0, $t6
		syscall
		
		#Print str SearchFound2
		li $v0, 4
		la $a0, strSearchFound2
		syscall

sEndSearch:
	#If key == -1 goto menu
	beq $t0, $t2, menu
	
	#Print str InvalidSearch
	li $v0, 4
	la $a0, strInvalidSearch
	syscall
	
	j menu

impressao:
	# $t0 = posição atual no vetor
	# $t1 = i
	# t2 = no_atual
	# t3 = no_atual->valor
	
	move $t0, $s0			# t0 = vetor[0]
	li $t1, 0				# i = 0
	li $v0, 4				# print string
	la $a0, strInicioImpressao
	syscall					# printf("\nImpressão da Tabela Hash\n")
	
# Percorremos a cada posicao (0 à 15) do vetor
forLoopImpressao:
	bge $t1, 16, fimImpressao	# while (i < 16)
	lw $t2, 0($t0)			# t2 = vetor[i] = no_atual
					
	li $v0, 4				# printf("Linha[%d]", i)
	la $a0, strInicioLinhaImpressao
	syscall				
	li $v0, 1				# print int
	move $a0, $t1			# t1 = posicao atual do vetor
	syscall	
	li $v0, 4				# print string
	la $a0, strFimLinhaImpressao
	syscall				
	
	# Imprimir todos os nós de uma lista duplamente encadeada, até encontrar o fim (valor = -1)
	LoopImpressaoNo:
		lw $t3, 4($t2)		# t2 = valor da lista duplamente encadeada
		beq $t3, -1, endLinhaImpressao # while (t2 != -1)
		li $v0, 1			# print int
		move $a0, $t3		
		syscall				# printf("%d", no->valor)
		li $v0, 4			# printf string
		la $a0, strSpace
		syscall				# printf(" ")
		lw $t2, 8($t2)		# t2 = t2->proximo_nó
		j LoopImpressaoNo	# Vamos para o próximo nó
	j forLoopImpressao
	
endLinhaImpressao:
	li $v0, 4				# imprimimos um "\n"
	la $a0, strNewline		# print string
	syscall
	
	# atualizamos o próximo nó
	addi $t1, $t1, 1		# i++
	addi $t0, $t0, 4		# t0 tem o endereco do próximo nó
	j forLoopImpressao		# voltamos para imprimir a próxima linha da Hash.
	
fimImpressao:
	li $v0, 4				# print string
	la $a0, strFimImpressao
	syscall
	j menu

#=============UTILS==============#

endProgram:
	li $v0, 4				# imprime string
	la $a0, strExit
	syscall
	li $v0, 10				# exit
	syscall

insertError:
	li $v0, 4				# imprime string
	la $a0, strInsertError
	syscall
	j menu					# voltamos ao menu
	
removeError:
	li $v0, 4				# imprime string
	la $a0, strRemoveError
	syscall
	j menu		
	
invalidInput:
	li $v0, 4				# imprime string
	la $a0, strInvalidInput
	syscall
	j menu					# voltamos ao menu

leInt:						# lê um inteiro que fica em $v0.
	li $v0, 5				# lê inteiro
	syscall
	jr $ra
