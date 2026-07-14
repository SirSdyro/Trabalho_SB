global mod16
global mod32

extern cout
extern cin_number16
extern cin_number32

extern msgNum1
extern len_msgNum1
extern msgNum2
extern len_msgNum2
extern len_msgDivZero
extern msgDivZero
extern SAIR

;---------------------------------------------------------
; mod16
;
; Retorno:
; EAX = resultado (resto)
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

    movsx eax, ax         ; estende o resultado de 16 para 32 bits

    mov esp,ebp
    pop ebp
    ret

.divzero:

    push len_msgDivZero
    push msgDivZero
    call cout

    jmp SAIR

;---------------------------------------------------------
; mod32
;
; Retorno:
; EEAX = resultado (resto)
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