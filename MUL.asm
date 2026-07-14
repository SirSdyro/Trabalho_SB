global mul16
global mul32

extern cout
extern cin_number16
extern cin_number32

extern msgNum1
extern len_msgNum1
extern msgNum2
extern len_msgNum2
extern msgOverflow
extern len_msgOverflow
extern SAIR

;---------------------------------------------------------
; mul16
;
; Retorno:
; EAX = resultado
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

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    mov esp,ebp
    pop ebp
    ret

.overflow:

    push len_msgOverflow
    push msgOverflow
    call cout

    jmp SAIR

;---------------------------------------------------------
; mul32
;
; Retorno:
; EEAX = resultado
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
