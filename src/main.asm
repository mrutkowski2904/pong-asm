bits 64
default rel

global main

extern startKeyboardLoop
extern runGame
extern makeBeep

section	.text
main:
    push rbp
    mov rbp, rsp

    call makeBeep
    call startKeyboardLoop

    ; run game logic
    call runGame
    
    pop rbp
    mov rax, 0
    ret
