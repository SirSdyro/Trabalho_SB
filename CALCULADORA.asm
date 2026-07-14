; João Henrique Jácomo Lemes - 231018893
; Ricardo de Carvalho Nabuco - 231021360
; Trabalho 2 de Software Básico

section .data

    welcome db 'Bem-vindo. Digite seu nome:',0xa
    len_welcome equ $-welcome

    hello1 db 'Hola, '
    len_hello1 equ $-hello1

    hello2 db ', bem-vindo ao programa CALC IA-32',0xa
    len_hello2 equ $-hello2

    precisionMsg db 'Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32):',0xa
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

    msgOverflow db 'OCORREU OVERFLOW',0xa
    len_msgOverflow equ $-msgOverflow

    msgFaixa db 'ERRO: Numero fora da faixa.',0xa
    len_msgFaixa equ $-msgFaixa

    msgDivZero db 'ERRO: Divisao por zero.',0xa
    len_msgDivZero equ $-msgDivZero

section .bss

    username        resb 32
    len_username    resd 1

    precision       resd 1
    menu_op         resd 1

    input_buffer    resb 16

    result_buffer   resb 16

    schmidley   resb 32

section .text
    global _start

    global msgNum1
    global len_msgNum1

    global msgNum2
    global len_msgNum2

    global msgOverflow
    global len_msgOverflow
    global msgFaixa
    global len_msgFaixa
    global msgDivZero
    global len_msgDivZero
    global username
    global len_username

    global input_buffer
    global result_buffer

    global SAIR
    global cout
    global cin_string
    global cin_number16
    global cin_number32
    global ascii_to_int
    global num2ascii
    global mostrarResultado

    extern add16
    extern add32

    extern sub16
    extern sub32

    extern mul16
    extern mul32

    extern div16
    extern div32

    extern exp16
    extern exp32

    extern mod16
    extern mod32

_start:

    push len_welcome
    push welcome
    call cout

    push username
    call cin_string

    push len_hello1
    push hello1
    call cout

    push dword [len_username]
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
    call add16            ; EAX <- resultado

    push eax
    call mostrarResultado

    push schmidley
    call cin_string

    jmp MENU
SUB16:
    call sub16             ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
MUL16:
    call mul16            ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
DIV16:
    call div16              ; EAX <- resultado (quociente)

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
EXP16:
    call exp16          ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
MOD16:
    call mod16              ; EAX <- resultado (resto)

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

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
    call add32            ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
SUB32:
    call sub32              ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
MUL32:
    call mul32            ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
DIV32:
    call div32              ; EAX <- resultado (quociente)

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
EXP32:
    call exp32          ; EAX <- resultado

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU
MOD32:
    call mod32              ; EAX <- resultado (resto)

    push eax
    call mostrarResultado
    push schmidley
    call cin_string

    jmp MENU

SAIR:
    ; 2. Sair do programa (sys_exit)
    mov eax, 1                         ; Número da syscall sys_exit
    mov ebx, 0                         ; Código de status 0 (sucesso)
    int 0x80                           ; Chama o kernel do Linux

;|||FUNCOES DE ENTRADA E SAIDA|||

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

    pop ebp
    ret 8

;------------------------------------------------------------
; mostrarResultado
;
; Entrada:
;     push numero
;
; Saída:
;     nenhuma
;
;------------------------------------------------------------

mostrarResultado:

    push ebp
    mov ebp,esp

    ; Converte número para string
    push result_buffer
    push dword [ebp+8]
    call num2ascii

    ; Imprime string
    push edx
    push eax
    call cout

    pop ebp
    ret 4