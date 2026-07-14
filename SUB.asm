global sub16
global sub32

extern cout
extern cin_number16
extern cin_number32

extern msgNum1
extern len_msgNum1
extern msgNum2
extern len_msgNum2

;---------------------------------------------------------
; sub16
;
; Retorno:
; EAX = resultado
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

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    mov esp,ebp
    pop ebp
    ret

;---------------------------------------------------------
; sub32
;
; Retorno:
; EEAX = resultado
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