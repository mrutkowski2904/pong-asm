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

    .textLoop:
    mov dl, [rdx]
    cmp dl, 0
    je .end

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    call drawChar

    add [rbp - 1], BYTE 5

    mov rdx, [rbp - 10]
    mov dl, [rdx]
    cmp dl, 'm'
    jne .extraPaddingSkip
    add [rbp - 1], BYTE 1
    .extraPaddingSkip:

    inc QWORD [rbp - 10]
    mov rdx, [rbp - 10]
    jmp .textLoop

    .end:
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

    .drawP:
    cmp dl, 'p'
    jne .drawO

    lea rdx, [spriteLetterP]
    call drawSprite

    jmp .end

    .drawO:
    cmp dl, 'o'
    jne .drawN

    lea rdx, [spriteLetterO]
    call drawSprite

    jmp .end

    .drawN:
    cmp dl, 'n'
    jne .drawG

    lea rdx, [spriteLetterN]
    call drawSprite

    jmp .end

    .drawG:
    cmp dl, 'g'
    jne .drawB

    lea rdx, [spriteLetterG]
    call drawSprite

    jmp .end

    .drawB:
    cmp dl, 'b'
    jne .drawY

    lea rdx, [spriteLetterB]
    call drawSprite

    jmp .end

    .drawY:
    cmp dl, 'y'
    jne .drawM

    lea rdx, [spriteLetterY]
    call drawSprite

    jmp .end

    .drawM:
    cmp dl, 'm'
    jne .drawR

    mov cl, 5
    lea rdx, [spriteLetterM]
    call drawSprite

    jmp .end

    .drawR:
    cmp dl, 'r'
    jne .drawU
    
    lea rdx, [spriteLetterR]
    call drawSprite

    jmp .end

    .drawU:
    cmp dl, 'u'
    jne .drawL

    lea rdx, [spriteLetterU]
    call drawSprite

    jmp .end

    .drawL:
    cmp dl, 'l'
    jne .drawS

    lea rdx, [spriteLetterL]
    call drawSprite

    jmp .end

    .drawS:
    cmp dl, 's'
    jne .drawW

    lea rdx, [spriteLetterS]
    call drawSprite

    jmp .end

    .drawW:
    cmp dl, 'w'
    jne .drawI

    mov cl, 5
    lea rdx, [spriteLetterW]
    call drawSprite

    jmp .end

    .drawI:
    cmp dl, 'i'
    jne .drawE

    lea rdx, [spriteLetterI]
    call drawSprite

    jmp .end

    .drawE:
    cmp dl, 'e'
    jne .end

    lea rdx, [spriteLetterE]
    call drawSprite

    .end:
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