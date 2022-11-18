bits 64
default rel

global main

extern printf
extern usleep

extern setPixel
extern drawGameBoard
extern drawBuffer

section	.text
gameLoopFunc:
    push rbp
    mov rbp, rsp
    push rbx

_loop:

    call drawGameBoard

    mov dil, 20
    mov sil, 3
    mov dl, 'a'
    call setPixel
    call drawBuffer

    mov rdi, 1000000
    call usleep wrt ..plt

    mov bl, [runGame]
    cmp bl, 1
    je _loop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

main:
    push rbp
    push rbx

    call gameLoopFunc

    pop rbx
    pop rbp
    mov rax, 0
    ret

section .data
    runGame: db 1
    msg: db "Hello World from ASM", 10, 0