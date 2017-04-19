# Uma tabela Hash implementada em Assembly MIPS para a matéria de Organização de Computadores Digitais
# Membros: Bruno Coelho, Gabriel Cruz, Gabriel Cyrillo, Alex Sander

.data
.align 0
    strInsert: .asciiz "\nDigite o valor a ser inserido: "
    strRemove: .asciiz "\nDigite o valor a ser removido: "
	strInicio: .asciiz "Tabela Hash de inteiros implementada em MIPS Assembly.\n"
	strOpcao: .asciiz  "Digite 1 para a inserção de um número, 2 para remoção, 3 para busca, 4 para a visualazição da tabela e 5 para sair do programa.\n"
	strInvalidInput: .asciiz "Opção não válida digitada, favor digitar um inteiro de 1 a 5 conforme as opções fornecidas.\n"
	strExit:.asciiz "Finalizando programa\n"
    strInsertError: .asciiz "O número digitado já foi inserido.\n"

.text
.globl main

main:
	li $v0, 4		# imprime string
	la $a0, strInicio
	syscall

	# aloca as 16 posições do vetor
	li $v0, 9		# sbrk
	li $a0, 64		# 64 = 16 * 4(tam de um end) bytes
	syscall
	move $s0, $v0		# $s0 = malloc(16*sizeof(nó*))

	li $t0, 0		# i = 0
	move $t1, $s0 		# t1 = vetor[0]
	j forInicializa

menu:
	li $v0, 4	# imprime string
	la $a0, strOpcao
	syscall
	li $v0, 5	# ler inteiro
	syscall 	# numero digitado em $v0
	move $s1, $v0	# guardando o numero em s1

	beq $s1, +1, insercao
	beq $s1, +2, remocao
	beq $s1, +3, busca
	beq $s1, +4 impressao
	beq $s1, +5, endProgram
	j invalidInput		# se chegar aqui, o usuario digitou algum número não valido


# Funções Placeholders, depois coloquem as suas partes aqui.

insercao:

    # $t0 = valor a ser inserido
    # $t1 = posicao de insercao no vetor
    # $t2 = aux(16)
    # $t3 = $s0 = comeco do vetor
    # $t4 = valores da lista

    li $v0, 4 #imprimir string que pede valor
    la $a0, strInsert
    syscall

    jal leInt #inteiro lido em $v0
    move $t0, $v0 #move inteiro lido para $t0

    #fazer mod
    li $t2, 16
    div $t0, $t2 #$t0/16
    mfhi $t1 # $t1 = $t0 % 16

    #acessar posicao do vetor
    move $t3, $s0
    mul $t1, $t1, 4 #quantidade de bytes de deslocamento até a posicao desejada
    add $t3, $t3, $t1 #posicao de insercao

    #percorrer lista
    lw $t4, 4($t3) # pega valor do no
    findPlace:
        bge $zero, $t4, found #while no->valor >= 0
        bge $t4, $t0, found #while no->valor < my_valor
        lw $t3, 8($t3) # vai para o prox no
        lw $t4, 4($t3) # pega valor do prox no
        j findPlace

    #inserir
    found:
        beq $t4, $t0, insertError #número repetido

        #insercão válida
        #criar novo nó
        #atribuir valor ao nó
        #apontar da forma correta

    j menu

remocao:
	li $v0, 4 #imprimir string que pede valor
    la $a0, strRemove
    syscall
    j menu

busca:
	j menu

impressao:
	j menu



#=============UTILS==============#

endProgram:
	li $v0, 4	# imprime string
	la $a0, strExit
	syscall
	li $v0, 10	# exit
	syscall

insertError:
    li $v0, 4	# imprime string
	la $a0, strInsertError
	syscall
	j menu		# voltamos ao menu

forInicializa:
	# para cada uma ds posições do vetor, alocamos um nó vazio. $t0 = i, $t1 = vetor[0] inicialmente
	bge $t0, 16, menu	# while (i < 16)
	li $v0, 9		# sbrk
	li $a0, 12		# 12 = no anterior(end = 4) + inteiro(word = 4) + proximo no(end = 4)
	syscall			# $v0 = malloc(sizeof(nó))

	move $t2, $v0		# t2 = novo_no


	sw $t2, 0($t1)		# vetor[i] = novo_no
	addi $t0, $t0, 1	# i++
	addi $t1, $t1, 4	# t1 = vetor[i]

	li $t3, -1		# $t3 = flag para não existe = -1
	sw $zero, 0($t2)	# no->anterior = zero
	sw $t3, 4($t2)		# no->valor = -1
	sw $zero, 8($t2)	# no->prox = zero
	j forInicializa

invalidInput:
	li $v0, 4	# imprime string
	la $a0, strInvalidInput
	syscall
	j menu		# voltamos ao menu

leInt:		# lê um inteiro que fica em $v0.
	li $v0, 5	# lê inteiro
	syscall
	jr $ra

