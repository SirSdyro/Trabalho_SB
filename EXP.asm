global exp16
global exp32

extern cout
extern cin_number16
extern cin_number32

extern msgNum1
extern len_msgNum1
extern msgNum2
extern len_msgNum2
extern len_msgOverflow
extern msgOverflow
extern len_msgFaixa
extern msgFaixa
extern SAIR

;---------------------------------------------------------
; exp16
;
; Retorno:
; EAX = resultado
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

    ; se expoente < 0, retorna 0
    cmp edx,0
    jl .negativo

    ; se expoente == 0, retorna 1
    je .fim

.loop:

    imul ax,bx
    jo .overflow

    dec edx
    jnz .loop

.fim:

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    mov esp,ebp
    pop ebp
    ret

.negativo:

    xor ax,ax

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
; exp32
;
; Retorno:
; EEAX = resultado
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
    mov edx,[ebp-8]
    mov eax,1

    ; se expoente < 0, retorna 0
    cmp edx,0
    jl .negativo

    ; se expoente == 0, retorna 1
    je .fim

.loop:

    imul eax,ebx
    jo .overflow

    dec edx
    jnz .loop

.fim:

    mov esp,ebp
    pop ebp
    ret

.negativo:

    xor eax,eax

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