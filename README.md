
# Tabela-HashMIPS
Uma tabela Hash implementada em Assembly MIPS para a matéria de Organização de Computadores Digitais. 

A hash table implemented in Assembly MIPS for the Digital Computers Organization course. 

### Language Details

The whole project is writen and maintened in Portuguese. This includes file names, variables and comentaries. No, a English port is not available. Except everything from here on to be in Portuguese.


## Table of Contents

- [Credits](#credits)
- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Credits

Main/Menu e Impressão- Bruno(@BrunoGomesCoelho)

Inserção - Cruz(@LTKills)

Remoção - Cyrillo(@GCyrillo)

Busca - Alex


## Background

Para a matéria de Organizção de Computadors Digitais cursada no primeiro semestre de 2017, implementamos uma tabela hash em Assembly MIPS. O código está todo em um único arquivo, fortemente comentado em português.

## Install

Basta rodar o arquivo "trabalho.asm" no seu emulador favorito de MIPS. Recomendamos o [MARS](http://courses.missouristate.edu/KenVollmar/mars/) onde o projeto foi feito e testado, embora outros emuladores como o  [QT SPIM](http://spimsimulator.sourceforge.net/) devem também funcionar.


## Usage

Uma vez rodando, os menus são alto explicativos.


## Informações didáticas sobre o código

### Formato da "struct":

(ponteiro anterior, valor , ponteiro posterior) = 32 bytes (end) -- 32 bytes (inteiro) -- 32 bytes (end).

### Informaçes:
Caso o primeiro elemento estiver vazio, terá como valor -1 armazenado nele.

No final da função, deêm um "j menu" (jump para o menu).

Qualquer registrador que forem usar, com exceção dos temporários, terá que primeiro ser empilhado na stack e depois desempilhado.

Para chamar uma função modularizada, tem que chamar com JAL (jump and link) para poder retornar para a sua função.

### Registradores fixos:

$s1 - Input do usuário no menu

$s0 - Endereço do primeiro nó, já apontando pro valor do meio (o valor).


## Contribute

Se quiser contribuir, só forkar. Pull Requests são muito bem vindos.


## License

[MIT © Richard McRichface.](../LICENSE)




