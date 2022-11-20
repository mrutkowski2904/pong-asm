bits 64
default rel

global main
global exitGame

extern startKeyboardLoop
extern runGame
extern makeBeep

extern system

section	.text
main:
    push rbp
    mov rbp, rsp

    call makeBeep
    call startKeyboardLoop

    ; prepare terminal
    lea rdi, [clearTerminalCmd]
    call system wrt ..plt

    ; run game logic
    call runGame
    
    pop rbp
    mov rax, 0
    ret

exitGame:
    push rbp

    ; exit process and children
    xor rdi, rdi
    mov rax, 231
    syscall

    ; wont make it here
    pop rbp
    ret

section .data
    clearTerminalCmd: db 'clear -x', 0