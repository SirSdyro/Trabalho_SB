NESTE TRABALHO FOI UTILIZADO O WSL (WINDOWS SUBSYSTEM FOR LINUX) NO WINDOWS 10

PARA COMPILAR:

nasm -f elf32 CALCULADORA.asm -o CALCULADORA.o
nasm -f elf32 ADD.asm -o ADD.o
nasm -f elf32 SUB.asm -o SUB.o
nasm -f elf32 MUL.asm -o MUL.o
nasm -f elf32 DIV.asm -o DIV.o
nasm -f elf32 EXP.asm -o EXP.o
nasm -f elf32 MOD.asm -o MOD.o

PARA LIGAR:

ld -m elf_i386 CALCULADORA.o ADD.o SUB.o MUL.o DIV.o EXP.o MOD.o -o calculadora

PARA RODAR:

./calculadora