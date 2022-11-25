bits 64
default rel

global drawText
global drawChar
global drawDigit

extern drawSprite

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

    mov rdx, [rbp - 10]
    mov dl, [rdx]
    cmp dl, 'm'
    jne _drawTextAdditionalPaddingSkip
    add [rbp - 1], BYTE 1
    _drawTextAdditionalPaddingSkip:

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
    mov cl, 4

    _drawCharP:
    cmp dl, 'p'
    jne _drawCharO

    lea rdx, [spriteLetterP]
    call drawSprite

    jmp _drawCharEnd

    _drawCharO:
    cmp dl, 'o'
    jne _drawCharN

    lea rdx, [spriteLetterO]
    call drawSprite

    jmp _drawCharEnd

    _drawCharN:
    cmp dl, 'n'
    jne _drawCharG

    lea rdx, [spriteLetterN]
    call drawSprite

    jmp _drawCharEnd

    _drawCharG:
    cmp dl, 'g'
    jne _drawCharB

    lea rdx, [spriteLetterG]
    call drawSprite

    jmp _drawCharEnd

    _drawCharB:
    cmp dl, 'b'
    jne _drawCharY

    lea rdx, [spriteLetterB]
    call drawSprite

    jmp _drawCharEnd

    _drawCharY:
    cmp dl, 'y'
    jne _drawCharM

    lea rdx, [spriteLetterY]
    call drawSprite

    jmp _drawCharEnd

    _drawCharM:
    cmp dl, 'm'
    jne _drawCharR

    mov cl, 5
    lea rdx, [spriteLetterM]
    call drawSprite

    jmp _drawCharEnd

    _drawCharR:
    cmp dl, 'r'
    jne _drawCharU
    
    lea rdx, [spriteLetterR]
    call drawSprite

    jmp _drawCharEnd

    _drawCharU:
    cmp dl, 'u'
    jne _drawCharL

    lea rdx, [spriteLetterU]
    call drawSprite

    jmp _drawCharEnd

    _drawCharL:
    cmp dl, 'l'
    jne _drawCharS

    lea rdx, [spriteLetterL]
    call drawSprite

    jmp _drawCharEnd

    _drawCharS:
    cmp dl, 's'
    jne _drawCharW

    lea rdx, [spriteLetterS]
    call drawSprite

    jmp _drawCharEnd

    _drawCharW:
    cmp dl, 'w'
    jne _drawCharI

    mov cl, 5
    lea rdx, [spriteLetterW]
    call drawSprite

    jmp _drawCharEnd

    _drawCharI:
    cmp dl, 'i'
    jne _drawCharE

    lea rdx, [spriteLetterI]
    call drawSprite

    jmp _drawCharEnd

    _drawCharE:
    cmp dl, 'e'
    jne _drawCharEnd

    lea rdx, [spriteLetterE]
    call drawSprite

    _drawCharEnd:
    mov rsp, rbp
    pop rbp
    ret

section .data
    spriteLetterP: db   '#', '#', '#', '#', \
                        '#', ' ', ' ', '#', \
                        '#', '#', '#', '#', \
                        '#', ' ', ' ', ' ', 0

    spriteLetterO: db   '#', '#', '#', '#', \
                        '#', ' ', ' ', '#', \
                        '#', ' ', ' ', '#', \
                        '#', '#', '#', '#', 0

    spriteLetterN: db   '#', '#', '#', ' ', \
                        '#', ' ', ' ', '#', \
                        '#', ' ', ' ', '#', \
                        '#', ' ', ' ', '#', 0

    spriteLetterG: db   '#', '#', '#', '#', \
                        '#', ' ', ' ', ' ', \
                        '#', ' ', ' ', '#', \
                        '#', '#', '#', '#', 0

    spriteLetterB: db   '#', ' ', ' ', ' ', \
                        '#', '#', '#', '#', \
                        '#', ' ', ' ', '#', \
                        '#', '#', '#', '#', 0

    spriteLetterY: db   '#', ' ', '#', ' ', \
                        '#', '#', '#', ' ', \
                        ' ', '#', ' ', ' ', \
                        ' ', '#', ' ', ' ', 0

    spriteLetterM: db   '#', '#', '#', '#', '#', \
                        '#', ' ', '#', ' ', '#', \
                        '#', ' ', ' ', ' ', '#', \
                        '#', ' ', ' ', ' ', '#', 0

    spriteLetterR: db   '#', '#', ' ', ' ', \
                        '#', ' ', '#', ' ', \
                        '#', '#', ' ', ' ', \
                        '#', ' ', '#', ' ', 0

    spriteLetterU: db   '#', ' ', ' ', '#', \
                        '#', ' ', ' ', '#', \
                        '#', ' ', ' ', '#', \
                        '#', '#', '#', '#', 0

    spriteLetterL: db   '#', ' ', ' ', ' ', \
                        '#', ' ', ' ', ' ', \
                        '#', ' ', ' ', ' ', \
                        '#', '#', '#', '#', 0

    spriteLetterS: db   '#', '#', ' ', ' ', \
                        '#', ' ', ' ', ' ', \
                        ' ', '#', ' ', ' ', \
                        '#', '#', ' ', ' ', 0

    spriteLetterE: db   '#', '#', '#', '#', \
                        '#', ' ', '#', '#', \
                        '#', ' ', ' ', ' ', \
                        '#', '#', '#', '#', 0

    spriteLetterW: db   '#', ' ', ' ', ' ', '#', \
                        '#', ' ', '#', ' ', '#', \
                        '#', ' ', '#', ' ', '#', \
                        '#', '#', '#', '#', '#', 0

    spriteLetterI: db   ' ', ' ', '#', ' ', \
                        ' ', ' ', '#', ' ', \
                        ' ', ' ', '#', ' ', \
                        ' ', ' ', '#', ' ', 0