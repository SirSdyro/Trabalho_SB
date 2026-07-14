global add16
global add32

extern cout
extern cin_number16
extern cin_number32

extern msgNum1
extern len_msgNum1
extern msgNum2
extern len_msgNum2

;---------------------------------------------------------
; add16
;
; Retorno:
; EAX = resultado
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

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    mov esp,ebp
    pop ebp
    ret

;>>>>>>>>>>>>FUNCOES 32 BITS<<<<<<<<<<<<
;---------------------------------------------------------
; add32
;
; Retorno:
; EEAX = resultado
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