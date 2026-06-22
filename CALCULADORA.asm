; PARA COMPILAR E RODAR:
; nasm -f elf32 CALCULADORA.asm -o test.Ola
; ld -m elf_i386 test.o -o test
; ./test

section .data
    welcome db 'Bem-vindo. Digite seu nome:', 0xa   ; String com quebra de linha
    len_welcome equ $ - welcome                    ; Tamanho da string

    hello1 db 'Hola, '
    len_hello1 equ $ - hello1

    hello2 db ', bem-vindo ao programa de CALC IA-32', 0xa
    len_hello2 equ $ - hello2

    precisionMsg db 'Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32):', 0xa
    len_precisionMsg equ $ - precisionMsg

    ;hello db 'Hola, <nome do usuario>, bem-vindo ao programa de CALC IA-32', 0xa
    ;len_hello equ $ - hello

    ;hello db 'Hola, <nome do usuario>, bem-vindo ao programa de CALC IA-32', 0xa
    ;len_hello equ $ - hello
    
    len_precision equ 1
    bit16 equ 16
    bit32 equ 32

section .bss
    username resb 32
    len_username resd 4
    precision resb 1

section .text
    global _start                      ; Ponto de entrada exigido pelo ld

_start:
    ; 1. Escrever no terminal (sys_write)
    ;mov eax, 4                         ; Número da syscall sys_write
    ;mov ebx, 1                         ; File descriptor 1 (stdout)
    ;mov ecx, welcome                       ; Ponteiro para a mensagem
    ;mov edx, len_welcome                       ; Tamanho da mensagem
    ;int 0x80                           ; Chama o kernel do Linux
    push len_welcome
    push welcome
    call cout
    push username
    call cin_string
    push len_hello1
    push hello1
    call cout
    push [len_username]
    push username
    call cout
    push len_hello2
    push hello2
    call cout
    push len_precisionMsg
    push precisionMsg
    call cout
    push len_precision
    push precision
    call cin_number
    push precision
    call ascii2num
    push len_precision
    push precision
    call cout

    add [precision], 1
    mov eax, 4
    mov ebx, 1
    mov ecx, precision
    mov edx, 1
    int 0x80

    ; 2. Sair do programa (sys_exit)
    mov eax, 1                         ; Número da syscall sys_exit
    mov ebx, 0                         ; Código de status 0 (sucesso)
    int 0x80                           ; Chama o kernel do Linux

;||||||||||FUNCOES||||||||||
cout:
    ; param : (mensagem, tamanho da mensagem)
    push ebp
    mov ebp, esp
    mov eax, 4
    mov ebx, 1
    mov ecx, [ebp+8]
    mov edx, [ebp+12]
    int 0x80
    pop ebp
    ret 8

cin_string:
    ; param : (variavel)
    push ebp
    mov ebp, esp
    mov eax, 3
    mov ebx, 0
    mov ecx, [ebp+8]
    mov edx, 32
    int 0x80
    pop ebp
    sub eax, 1
    mov [len_username], eax
    ret 4

cin_number:
    ; param : (variavel, tamanho maximo da variavel)
    push ebp
    mov ebp, esp
    mov eax, 3
    mov ebx, 0
    mov ecx, [ebp+8]
    mov edx, [ebp+12]
    int 0x80
    pop ebp
    ret 8

ascii2num:
    ; param : (variavel)
    push ebp
    mov ebp, esp
    mov esi, [ebp+8]         ; Move the address of our text buffer into ESI
    xor eax, eax            ; Clear EAX. This register holds our final total
    xor ecx, ecx            ; Clear ECX. This holds the current digit byte
.convert_loop:
    mov cl, [esi]           ; Load the next character byte from memory into CL
    inc esi                 ; Move buffer pointer forward to the next byte

    cmp cl, 0xa             ; Check if character is a Newline (\n)
    je .done                ; If newline, user finished typing. Exit loop
    cmp cl, 0               ; Check if character is a Null terminator
    je .done                ; If null, exit loop

    ; Basic safety check (ensure the character is a digit between '0' and '9')
    cmp cl, '0'
    jl .convert_loop        ; Skip if it's less than ASCII '0'
    cmp cl, '9'
    jg .convert_loop        ; Skip if it's greater than ASCII '9'

    ; Convert ASCII character to raw digit value
    sub cl, '0'             ; Subtract 48 (0x30) to change '5' (0x35) to 5

    ; Shift total to the left by multiplying previous value by 10
    ; Formula: Total = (Total * 10) + Current Digit
    imul eax, eax, 10       ; Multiply current total in EAX by 10
    add eax, ecx            ; Add the newly parsed digit value into EAX
    jmp .convert_loop       ; Loop back for next character
.done:
    mov [ebp+8],eax
    pop ebp
    ret 4