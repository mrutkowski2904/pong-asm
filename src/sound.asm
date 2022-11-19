bits 64
default rel

global makeBeep

extern system

section .text
makeBeep:
    push rbp
    lea rdi, [beepCmd]
    call system wrt ..plt
    pop rbp
    ret

section .data
    beepCmd: db "echo -ne '\007'", 0