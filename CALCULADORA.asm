; PARA COMPILAR E RODAR:
; nasm -f elf32 CALCULADORA.asm -o test.Ola
; ld -m elf_i386 test.o -o test
; ./test

section .data

    welcome db 'Bem-vindo. Digite seu nome:',0xa
    len_welcome equ $-welcome

    hello1 db 'Ola, '
    len_hello1 equ $-hello1

    hello2 db ', bem-vindo ao programa CALC IA-32',0xa
    len_hello2 equ $-hello2

    precisionMsg db 'Precisao (0=16 bits / 1=32 bits): ',0xa
    len_precisionMsg equ $-precisionMsg

    menu0 db 0xa,'ESCOLHA UMA OPCAO',0xa
    len_menu0 equ $-menu0

    menu1 db '1 - Soma',0xa
    len_menu1 equ $-menu1

    menu2 db '2 - Subtracao',0xa
    len_menu2 equ $-menu2

    menu3 db '3 - Multiplicacao',0xa
    len_menu3 equ $-menu3

    menu4 db '4 - Divisao',0xa
    len_menu4 equ $-menu4

    menu5 db '5 - Exponenciacao',0xa
    len_menu5 equ $-menu5

    menu6 db '6 - Mod',0xa
    len_menu6 equ $-menu6

    menu7 db '7 - Sair',0xa
    len_menu7 equ $-menu7

    msgNum1 db 'Primeiro numero: '
    len_msgNum1 equ $-msgNum1

    msgNum2 db 'Segundo numero: '
    len_msgNum2 equ $-msgNum2

    msgRes db 'Resultado: '
    len_msgRes equ $-msgRes

    msgOverflow db 'ERRO: Overflow!',0xa
    len_msgOverflow equ $-msgOverflow

    msgFaixa db 'ERRO: Numero fora da faixa.',0xa
    len_msgFaixa equ $-msgFaixa

section .bss

    username        resb 32
    len_username    resd 1

    precision       resd 1
    menu_op         resd 1

    input_buffer    resb 16

    result_buffer   resb 16

    enter_aux   resb 2

section .text
    global _start

_start:

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

    push precision
    call cin_number16

MENU:

    push len_menu0
    push menu0
    call cout

    push len_menu1
    push menu1
    call cout

    push len_menu2
    push menu2
    call cout

    push len_menu3
    push menu3
    call cout

    push len_menu4
    push menu4
    call cout

    push len_menu5
    push menu5
    call cout

    push len_menu6
    push menu6
    call cout

    push len_menu7
    push menu7
    call cout

    push menu_op
    call cin_number16

    cmp dword [precision],1
    je MENU32

MENU16:

    cmp dword [menu_op],1
    je ADD16

    cmp dword [menu_op],2
    je SUB16

    cmp dword [menu_op],3
    je MUL16

    cmp dword [menu_op],4
    je DIV16

    cmp dword [menu_op],5
    je EXP16

    cmp dword [menu_op],6
    je MOD16

    cmp dword [menu_op],7
    je SAIR

    jmp MENU

MENU32:

    cmp dword [menu_op],1
    je ADD32

    cmp dword [menu_op],2
    je SUB32

    cmp dword [menu_op],3
    je MUL32

    cmp dword [menu_op],4
    je DIV32

    cmp dword [menu_op],5
    je EXP32

    cmp dword [menu_op],6
    je MOD32

    cmp dword [menu_op],7
    je SAIR

    jmp MENU

ADD16:
    call add16            ; AX <- resultado

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push enter_aux
    call cin_string

    jmp MENU
SUB16:
    jmp MENU
MUL16:
    jmp MENU
DIV16:
    jmp MENU
EXP16:
    jmp MENU
MOD16:
    jmp MENU

;///32 bits///
BITS_32:
    cmp dword [menu_op], 1
    je ADD32
    cmp dword [menu_op], 2
    je SUB32
    cmp dword [menu_op], 3
    je MUL32
    cmp dword [menu_op], 4
    je DIV32
    cmp dword [menu_op], 5
    je EXP32
    cmp dword [menu_op], 6
    je MOD32
    cmp dword [menu_op], 7
    je SAIR

ADD32:
    jmp MENU
SUB32:
    jmp MENU
MUL32:
    jmp MENU
DIV32:
    jmp MENU
EXP32:
    jmp MENU
MOD32:
    jmp MENU

    push len_welcome
    push welcome
    call cout

SAIR:
    ; 2. Sair do programa (sys_exit)
    mov eax, 1                         ; Número da syscall sys_exit
    mov ebx, 0                         ; Código de status 0 (sucesso)
    int 0x80                           ; Chama o kernel do Linux

;||||||||||FUNCOES||||||||||

;>>>>>>FUNCOES 16 BITS<<<<<<
;---------------------------------------------------------
; add16
;
; Retorno:
; AX = resultado
;---------------------------------------------------------

add16:

    push ebp
    mov ebp,esp

    sub esp,8

    ; primeiro número

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number16

    ; segundo número

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number16

    ; soma

    mov ax,[ebp-4]

    add ax,[ebp-8]

    jo .overflow

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout

    jmp MENU

cout:

    push ebp
    mov ebp,esp

    mov eax,4
    mov ebx,1
    mov ecx,[ebp+8]
    mov edx,[ebp+12]

    int 0x80

    pop ebp
    ret 8

cin_string:

    push ebp
    mov ebp,esp

    mov eax,3
    mov ebx,0
    mov ecx,[ebp+8]
    mov edx,32

    int 0x80

    dec eax
    mov [len_username],eax

    pop ebp
    ret 4

;------------------------------------------------------------
; cin_number16
;
; Entrada:
;     push endereco_da_variavel
;
; Saída:
;     [variavel] = inteiro
;     EAX = inteiro
;
;------------------------------------------------------------

cin_number16:

    push ebp
    mov ebp,esp

    ; leitura

    mov eax,3
    mov ebx,0
    mov ecx,input_buffer
    mov edx,16
    int 0x80

    ; converte

    push input_buffer
    call ascii_to_int

    ; verifica faixa

    cmp eax,32767
    jg .erro

    cmp eax,-32768
    jl .erro

    mov edi,[ebp+8]
    mov [edi],eax

    pop ebp
    ret 4

.erro:

    push len_msgFaixa
    push msgFaixa
    call cout

    jmp SAIR

;------------------------------------------------------------
; cin_number32
;
; Entrada:
;      push endereco
;
; Saída:
;      [endereco] = inteiro
;
;------------------------------------------------------------

cin_number32:

    push ebp
    mov ebp,esp

    mov eax,3
    mov ebx,0
    mov ecx,input_buffer
    mov edx,16
    int 0x80

    push input_buffer
    call ascii_to_int

    mov edi,[ebp+8]
    mov [edi],eax

    pop ebp
    ret 4

;------------------------------------------------------------
; ascii_to_int
;
; Entrada:
;      push buffer
;
; Saída:
;      EAX = inteiro
;
;------------------------------------------------------------

ascii_to_int:

    push ebp
    mov ebp,esp

    mov esi,[ebp+8]

    xor eax,eax
    xor ebx,ebx

    ; verifica sinal

    mov cl,[esi]

    cmp cl,'-'
    jne .loop

    mov bl,1
    inc esi

.loop:

    xor ecx,ecx

    mov cl,[esi]
    inc esi

    cmp cl,0xa
    je .fim

    cmp cl,13
    je .fim

    cmp cl,0
    je .fim

    cmp cl,'0'
    jl .erro

    cmp cl,'9'
    jg .erro

    sub cl,'0'

    imul eax,eax,0xa
    jo .erro

    add eax,ecx
    jo .erro

    jmp .loop

.fim:

    cmp bl,0
    je .ok

    neg eax

.ok:

    pop ebp
    ret 4

.erro:

    push len_msgFaixa
    push msgFaixa
    call cout

    jmp SAIR

;------------------------------------------------------------
; num2ascii
;
; Entrada
;
;     push buffer
;     push numero
;
; Retorno
;
;     EAX = ponteiro
;     EDX = comprimento
;
;------------------------------------------------------------

num2ascii:

    push ebp
    mov ebp,esp

    mov eax,[ebp+8]
    mov edi,[ebp+12]

    add edi,15
    mov byte [edi],0

    xor esi,esi

    cmp eax,0
    jge .convert

    neg eax
    mov esi,1

.convert:

.loop:

    dec edi

    xor edx,edx

    mov ebx,0xa

    div ebx

    add dl,'0'

    mov [edi],dl

    test eax,eax
    jne .loop

    cmp esi,0
    je .finish

    dec edi
    mov byte [edi],'-'

.finish:

    mov eax,edi

    mov edx,[ebp+12]
    add edx,15
    sub edx,eax

    dec edx

    pop ebp
    ret 8
