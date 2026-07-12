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

    msgOverflow db 'ERRO: Overflow!',0xa
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

    schmidley   resb 2

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
    call add16            ; AX <- resultado

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
SUB16:
    call sub16             ; AX <- resultado

    movsx eax, ax           ; estende o resultado de 16 para 32 bits

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
MUL16:
    call mul16            ; AX <- resultado

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
DIV16:
    call div16              ; AX <- resultado (quociente)

    movsx eax, ax           ; estende o resultado de 16 para 32 bits

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
EXP16:
    call exp16          ; AX <- resultado

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
MOD16:
    call mod16              ; AX <- resultado (resto)

    movsx eax, ax           ; estende o resultado de 16 para 32 bits

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
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

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
SUB32:
    call sub32              ; EAX <- resultado

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
MUL32:
    call mul32            ; EAX <- resultado

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
DIV32:
    call div32              ; EAX <- resultado (quociente)

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
EXP32:
    call exp32          ; EAX <- resultado

    push result_buffer    ; buffer onde será escrita a string
    push eax              ; número a converter
    call num2ascii        ; EAX=ponteiro da string, ECX=tamanho

    push ecx              ; tamanho
    push eax              ; endereço da string
    call cout
    push schmidley
    call cin_string

    jmp MENU
MOD32:
    call mod32              ; EAX <- resultado (resto)

    push result_buffer      ; buffer onde será escrita a string
    push eax                ; número a converter
    call num2ascii          ; EAX=ponteiro da string, EDX=tamanho

    push edx                ; tamanho
    push eax                ; endereço da string
    call cout
    push schmidley
    call cin_string

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

;>>>>>>>>>>>>FUNCOES 16 BITS<<<<<<<<<<<<
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

    mov esp,ebp
    pop ebp
    ret

;---------------------------------------------------------
; sub16
;
; Retorno:
; AX = resultado
;---------------------------------------------------------

sub16:

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

    ; subtracao

    mov ax,[ebp-4]

    sub ax,[ebp-8]

    mov esp,ebp
    pop ebp
    ret

;---------------------------------------------------------
; mul16
;
; Retorno:
; AX = resultado
;---------------------------------------------------------

mul16:
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

    ; multiplicacao

    mov ax,[ebp-4]

    imul ax,[ebp-8]

    jo .overflow

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout

    jmp SAIR

;---------------------------------------------------------
; div16
;
; Retorno:
; AX = resultado (quociente)
;---------------------------------------------------------

div16:

    push ebp
    mov ebp,esp

    sub esp,8

    ; dividendo

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number16

    ; divisor

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number16

    ; verifica divisao por zero

    cmp word [ebp-8],0
    je .divzero

    ; divisao

    mov ax,[ebp-4]
    cwd                    ; estende sinal de AX para DX:AX
    idiv word [ebp-8]      ; AX = quociente, DX = resto

    mov esp,ebp
    pop ebp
    ret

.divzero:

    push len_msgDivZero
    push msgDivZero
    call cout

    jmp SAIR

;---------------------------------------------------------
; exp16
;
; Retorno:
; AX = resultado
;---------------------------------------------------------
exp16:

    push ebp
    mov ebp,esp

    sub esp,8

    ; base

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number16

    ; expoente

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number16

    mov bx,[ebp-4]
    movsx edx,word [ebp-8]
    mov ax,1

    cmp edx,0
    je .fim

.loop:

    cmp edx,0
    je .fim

    imul ax,bx
    jo .overflow

    dec edx
    jmp .loop

.fim:

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout
    jmp SAIR

.erro:

    push len_msgFaixa
    push msgFaixa
    call cout
    jmp SAIR

;---------------------------------------------------------
; mod16
;
; Retorno:
; AX = resultado (resto)
;---------------------------------------------------------

mod16:

    push ebp
    mov ebp,esp

    sub esp,8

    ; dividendo

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number16

    ; divisor

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number16

    ; verifica divisao por zero

    cmp word [ebp-8],0
    je .divzero

    ; divisao

    mov ax,[ebp-4]
    cwd                    ; estende sinal de AX para DX:AX
    idiv word [ebp-8]      ; AX = quociente, DX = resto

    mov ax,dx              ; retorna o resto

    mov esp,ebp
    pop ebp
    ret

.divzero:

    push len_msgDivZero
    push msgDivZero
    call cout

    jmp SAIR

;>>>>>>>>>>>>FUNCOES 32 BITS<<<<<<<<<<<<
;---------------------------------------------------------
; add32
;
; Retorno:
; EAX = resultado
;---------------------------------------------------------

add32:

    push ebp
    mov ebp,esp

    sub esp,8

    ; primeiro número

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; segundo número

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    ; soma

    mov eax,[ebp-4]

    add eax,[ebp-8]

    mov esp,ebp
    pop ebp
    ret

;---------------------------------------------------------
; sub32
;
; Retorno:
; EAX = resultado
;---------------------------------------------------------

sub32:

    push ebp
    mov ebp,esp

    sub esp,8

    ; primeiro número

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; segundo número

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    ; subtracao

    mov eax,[ebp-4]

    sub eax,[ebp-8]

    mov esp,ebp
    pop ebp
    ret

;---------------------------------------------------------
; mul32
;
; Retorno:
; EAX = resultado
;---------------------------------------------------------

mul32:
    push ebp
    mov ebp,esp

    sub esp,8

    ; primeiro número

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; segundo número

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    ; multiplicacao

    mov eax,[ebp-4]

    imul eax,[ebp-8]

    jo .overflow

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout

    jmp SAIR

;---------------------------------------------------------
; div32
;
; Retorno:
; EAX = resultado (quociente)
;---------------------------------------------------------

div32:

    push ebp
    mov ebp,esp

    sub esp,8

    ; dividendo

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; divisor

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    ; verifica divisao por zero

    cmp dword [ebp-8],0
    je .divzero

    ; divisao

    mov eax,[ebp-4]
    cdq                     ; estende sinal de EAX para EDX:EAX
    idiv dword [ebp-8]      ; EAX = quociente, EDX = resto

    mov esp,ebp
    pop ebp
    ret

.divzero:

    push len_msgDivZero
    push msgDivZero
    call cout

    jmp SAIR

;---------------------------------------------------------
; exp32
;
; Retorno:
; EAX = resultado
;---------------------------------------------------------
exp32:

    push ebp
    mov ebp,esp

    sub esp,8

    ; base

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; expoente

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    mov ebx,[ebp-4]
    movsx edx,word [ebp-8]
    mov eax,1

    cmp edx,0
    je .fim

.loop:

    cmp edx,0
    je .fim

    imul eax,ebx
    jo .overflow

    dec edx
    jmp .loop

.fim:

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout
    jmp SAIR

.erro:

    push len_msgFaixa
    push msgFaixa
    call cout
    jmp SAIR

;---------------------------------------------------------
; mod32
;
; Retorno:
; EAX = resultado (resto)
;---------------------------------------------------------

mod32:

    push ebp
    mov ebp,esp

    sub esp,8

    ; dividendo

    push len_msgNum1
    push msgNum1
    call cout

    lea eax,[ebp-4]
    push eax
    call cin_number32

    ; divisor

    push len_msgNum2
    push msgNum2
    call cout

    lea eax,[ebp-8]
    push eax
    call cin_number32

    ; verifica divisao por zero

    cmp dword [ebp-8],0
    je .divzero

    ; divisao

    mov eax,[ebp-4]
    cdq                     ; estende sinal de EAX para EDX:EAX
    idiv dword [ebp-8]      ; EAX = quociente, EDX = resto

    mov eax,edx             ; retorna o resto

    mov esp,ebp
    pop ebp
    ret

.divzero:

    push len_msgDivZero
    push msgDivZero
    call cout

    jmp SAIR

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
