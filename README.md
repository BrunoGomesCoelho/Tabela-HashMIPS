
# Tabela-HashMIPS

A hash table implemented in Assembly MIPS for the Digital Computers Organization course. 

### Language Details

The whole project is writen and maintened in Portuguese. This includes file names, variables and comentaries. A English port is not currently available. Except all code from here on to be in Portuguese.


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

For the Digital Computers class of 2017/01, my group's final project is the implementation of a hash table in Assemply MIPS. The whole code was made thinking of readability and is fully comented (albeit, in Portuguese).

## Install

Just run the file "trabalho.asm" in your favourite MIPS emulator. We personally recomend [MARS](http://courses.missouristate.edu/KenVollmar/mars/) where the project was build and tested, but other emulators such as  [QT SPIM](http://spimsimulator.sourceforge.net/) will also work.


## Usage

Once running, all the menus are very simple (if you know Portuguese that is).

## Techinical Information about the code (in Portuguese):

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

Contributions and PR's are very welcome.


## License

[MIT © Richard McRichface.](../LICENSE)




