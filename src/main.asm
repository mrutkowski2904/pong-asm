bits 64
default rel

global main

extern printf
extern usleep

extern setPixel
extern drawGameBoard
extern drawBuffer
extern startKeyboardLoop
extern rawPressedKey
extern makeBeep

section	.text
gameLoopFunc:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

_loop:
    call drawGameBoard
    
    mov dil, 20
    mov sil, 3
    mov dl, [rawPressedKey]
    call setPixel
    call drawBuffer

    mov rdi, (77 * 1000)
    call usleep wrt ..plt

    mov bl, [runGame]
    cmp bl, 1
    je _loop

    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

main:
    push rbp

    call makeBeep
    call startKeyboardLoop
    call gameLoopFunc

    pop rbp
    mov rax, 0
    ret

section .data
    runGame: db 1
    msg: db "Hello World from ASM", 10, 0