bits 64
default rel

global startKeyboardLoop
global rawPressedKey

extern tcgetattr
extern tcsetattr
extern read
extern usleep
extern malloc
extern clone

STACK_SIZE equ 65536

; clone flags
CLONE_VM equ 0x00000100
CLONE_FS equ 0x00000200
CLONE_FILES equ 0x00000400
CLONE_SIGHAND equ 0x00000800
CLONE_PARENT equ 0x00008000
CLONE_THREAD equ 0x00010000
CLONE_IO equ 0x80000000

section .text
keyboardLoop:
    push rbp
    mov rbp, rsp

_keyboardLoop:
    mov rdi, 1000
    call usleep wrt ..plt

    call nbgetch
    mov [rawPressedKey], rax

    jmp _keyboardLoop

    mov rsp, rbp
    pop rbp
    ret

startKeyboardLoop:
    push rbp
    mov rbp, rsp

    ; create stack for keyboard thread
    mov rdi, STACK_SIZE
    call malloc wrt ..plt

    lea rdi, [keyboardLoop]
    add rax, STACK_SIZE
    mov rsi, rax
    mov rdx, (CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_PARENT | CLONE_THREAD | CLONE_IO)
    call clone wrt ..plt

    mov rsp, rbp
    pop rbp
    ret

; non blocking getchar (must run in other thread)
; based on https://stackoverflow.com/a/912796
nbgetch:
    push rbp
    mov rbp, rsp
    sub rsp, 64

    ; zero char and struct fields
    mov BYTE [rbp - 1], 0

    xor rax, rax
    mov [rbp - 64], rax
    mov [rbp - 48], rax
    mov [rbp - 32], rax
    mov [rbp - 20], rax

    lea rax, [rbp - 64]
    mov rsi, rax
    mov edi, 0
    call tcgetattr wrt ..plt

    ; ~ICANON
    mov eax, [rbp - 52]
    and eax, -3
    mov [rbp - 52], eax

    ; ~ECHO
    mov eax, [rbp - 52]
    and eax, -9
    mov [rbp - 52], eax

    mov BYTE [rbp - 41], 1
    mov BYTE [rbp - 42], 0

    lea rax, [rbp - 64]
    mov rdx, rax
    mov esi, 0
    mov edi, 0
    call tcsetattr wrt ..plt

    lea rax, [rbp - 1]
    mov edx, 1
    mov rsi, rax
    mov edi, 0
    call read wrt ..plt

    ; clean up
    mov eax, [rbp - 52]
    or eax, 10
    mov [rbp - 52], eax

    lea rax, [rbp - 64]
    mov rdx, rax
    mov esi, 1
    mov edi, 0
    call tcsetattr wrt ..plt

    movzx eax, BYTE [rbp - 1]

    mov rsp, rbp
    pop rbp
    ret

section .data
    rawPressedKey: db ' '