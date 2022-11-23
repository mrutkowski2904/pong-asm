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

; Draws digit at specified position
; input char should be lowercase
; Args:
; dil - x
; sil - y
; dl  - value
drawDigit:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 1], BYTE dil ; x
    mov [rbp - 2], BYTE sil ; y
    mov [rbp - 3], BYTE dl ; value

_drawDigit0:
    cmp [rbp - 3], BYTE 0
    jne _drawDigit1

    jmp _drawDigitEnd

_drawDigit1:
    cmp [rbp - 3], BYTE 1
    jne _drawDigit2

    jmp _drawDigitEnd

_drawDigit2:
    cmp [rbp - 3], BYTE 2
    jne _drawDigit3

    jmp _drawDigitEnd

_drawDigit3:
    cmp [rbp - 3], BYTE 3
    jne _drawDigit4

    jmp _drawDigitEnd

_drawDigit4:
    cmp [rbp - 3], BYTE 4
    jne _drawDigit5

    jmp _drawDigitEnd

_drawDigit5:
    cmp [rbp - 3], BYTE 5
    jne _drawDigit6

    jmp _drawDigitEnd

_drawDigit6:
    cmp [rbp - 3], BYTE 6
    jne _drawDigit7

    jmp _drawDigitEnd

_drawDigit7:
    cmp [rbp - 3], BYTE 7
    jne _drawDigitEnd

_drawDigitEnd:
    mov rsp, rbp
    pop rbp

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
    jne _drawCharEnd
    
    lea rdx, [spriteLetterR]
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