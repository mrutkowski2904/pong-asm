bits 64
default rel

global drawPaddle

extern setPixel

PADDLE_HEIGHT equ 4

section .text

; Draw users paddle at specified
; Args:
; dil - x
; sil - y 
drawPaddle:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx
    
    mov [rbp - 1], BYTE PADDLE_HEIGHT
    mov [rbp - 2], dil ; save x
    mov [rbp - 3], sil ; save y

    _drawPaddleLoop:

    mov dil, [rbp - 2]
    mov sil, [rbp - 3]
    mov dl, '|'
    call setPixel

    inc BYTE [rbp - 3]

    dec BYTE [rbp - 1]
    cmp BYTE [rbp - 1], 0
    jne _drawPaddleLoop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret