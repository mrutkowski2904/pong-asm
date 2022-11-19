bits 64
default rel

global setPixel
global drawGameBoard
global drawBuffer

extern system
extern printf

DIMENSION_X equ 50
DIMENSION_Y equ 15

section .text

; Sets pixel to specified ASCII value
; Args:
; dil - x
; sil - y
; dl  - value
setPixel:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    cmp dil, BYTE DIMENSION_X
    jge _setPixelEnd
    cmp sil, BYTE DIMENSION_Y
    jge _setPixelEnd

    xor rax, rax
    mov al, sil
    mov bl, DIMENSION_X
    mul bl ; horizontal offset in ax

    xor r12, r12
    mov r12b, dil
    add ax, r12w ; index in buffer in ax

    lea rsi, [graphicsBuffer] 
    add rsi, rax ; final addr of element

    mov [rsi], dl

_setPixelEnd:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

drawGameBoard:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx

    mov [rbp - 4], BYTE 0 ; y loop counter
    mov [rbp - 5], BYTE 0 ; x loop counter

_yLoop:
    ; draw line in the middle
    mov dil, (DIMENSION_X / 2)
    mov sil, [rbp - 4]
    mov dl, '|'
    call setPixel

    ; draw left and right side border
    mov dil, (DIMENSION_X - 1)
    mov sil, [rbp - 4]
    mov dl, '*'
    call setPixel
    mov dil, 0
    mov sil, [rbp - 4]
    mov dl, '*'
    call setPixel

    inc BYTE [rbp - 4]
    cmp BYTE [rbp - 4], BYTE DIMENSION_Y
    jl _yLoop

_xLoop:
    ; draw upper and lower side border
    mov dil, [rbp - 5]
    mov sil, 0
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 5]
    mov sil, (DIMENSION_Y - 1)
    mov dl, '*'
    call setPixel

    inc BYTE [rbp - 5]
    cmp BYTE [rbp - 5], BYTE DIMENSION_X
    jl _xLoop 

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

drawBuffer:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    push rbx

    ; clear screen
    lea rdi, [clearCmd]
    call system wrt ..plt

    mov [rbp - 4], BYTE 0 ; x loop counter
    mov [rbp - 5], BYTE 0 ; y loop counter

_loop:
    ; calculate buffer index
    mov [rbp - 7], WORD 0
    xor rax, rax
    mov al, [rbp - 4]
    mov [rbp - 7], al ; index = x

    ; index += (y * DIM_X)
    mov al, [rbp - 5]
    mov bl, DIMENSION_X
    mul bl
    add ax, [rbp - 7]
    mov [rbp - 7], ax
    
    lea rsi, [graphicsBuffer] 
    add rsi, rax
    mov rsi, [rsi]
    xor rdx, rdx
    lea rdi, [pixelFormat]
    call printf wrt ..plt

    inc BYTE[rbp - 4]

    ; if not end of line, jump to loop
    cmp BYTE[rbp - 4], BYTE DIMENSION_X
    jl _loop

    ; else handle end of the line
    lea rdi, [newLineFormat]
    call printf wrt ..plt

    mov [rbp - 4], BYTE 0 ; zero x counter
    inc BYTE[rbp - 5]
    cmp BYTE[rbp - 5], BYTE DIMENSION_Y
    jl _loop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

section .data
    pixelFormat: db "%c", 0
    newLineFormat: db 10, 0
    graphicsBuffer: TIMES (DIMENSION_X * DIMENSION_Y) db ' '
    clearCmd: db "clear", 0
