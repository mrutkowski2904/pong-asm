bits 64
default rel

global drawText
global drawChar

extern setPixel 

section .text

; Draws text at specified position
; input char should be lowercase
; Args:
; dil - x
; sil - y
; rdx - pointer to \0 terminated string
drawText:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; x param
    mov [rbp - 1], dil
    ; y param
    mov [rbp - 2], sil
    ; pointer to msg
    mov [rbp - 10], rdx

_drawTextLoop:
    mov dl, [rdx]
    cmp dl, 0
    je _drawTextEnd

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    call drawChar

    add [rbp - 1], BYTE 5

    inc QWORD [rbp - 10]
    mov rdx, [rbp - 10]
    jmp _drawTextLoop

_drawTextEnd:
    mov rsp, rbp
    pop rbp
    ret

; Draws ascii character at specified position
; input char should be lowercase
; Args:
; dil - x
; sil - y
; dl  - value
drawChar:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; x param
    mov [rbp - 1], dil
    ; y param
    mov [rbp - 2], sil
    ; value param
    mov [rbp - 3], dl

_drawCharP:
    cmp [rbp - 3], BYTE 'p'
    jne _drawCharO

    ; ####
    ; #  #
    ; ####
    ; #
    
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 2
    mov dl, '*'
    call setPixel

    jmp _drawCharEnd

_drawCharO:
    cmp [rbp - 3], BYTE 'o'
    jne _drawCharN

    ; ####
    ; #  #
    ; #  #
    ; ####

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 3
    mov dl, '*'
    call setPixel
    jmp _drawCharEnd

_drawCharN:
    cmp [rbp - 3], BYTE 'n'
    jne _drawCharG

    ; ###
    ; #  #
    ; #  #
    ; #  #

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 3
    mov dl, '*'
    call setPixel

    jmp _drawCharEnd

_drawCharG:
    cmp [rbp - 3], BYTE 'g'
    jne _drawCharB

    ; ####
    ; #  
    ; #  #
    ; ####

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 3
    mov dl, '*'
    call setPixel
    jmp _drawCharEnd

_drawCharB:

_drawCharEnd:
    mov rsp, rbp
    pop rbp
    ret