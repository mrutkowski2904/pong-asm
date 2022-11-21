bits 64
default rel

global drawText
global drawChar
global drawDigit

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
    add sil, 4
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
    add dil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add sil, 3
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
    add sil, 4
    mov dl, '*'
    call setPixel

    jmp _drawDigitEnd

_drawDigit1:
    cmp [rbp - 3], BYTE 1
    jne _drawDigit2

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 1
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
    add dil, 2
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 4
    mov dl, '*'
    call setPixel

    jmp _drawDigitEnd

_drawDigit2:
    cmp [rbp - 3], BYTE 2
    jne _drawDigit3

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add dil, 1
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
    add dil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 1
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
    
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add sil, 4
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add dil, 1
    add sil, 4
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 4
    mov dl, '*'
    call setPixel

    jmp _drawDigitEnd

_drawDigit3:
    cmp [rbp - 3], BYTE 3
    jne _drawDigit4

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add dil, 1
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
    add dil, 4
    mov dl, '*'
    call setPixel

    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add sil, 5
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    add dil, 1
    add sil, 5
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 5
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    add sil, 5
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 5
    mov dl, '*'
    call setPixel

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
    cmp [rbp - 3], BYTE 'b'
    jne _drawCharY

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
    add sil, 3
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
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 3
    mov dl, '*'
    call setPixel

    jmp _drawCharEnd

_drawCharY:
    cmp [rbp - 3], BYTE 'y'
    jne _drawCharM
    
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    ; add dil, 0
    add sil, 1
    mov dl, '*'
    call setPixel

    jmp _drawCharEnd

_drawCharM:
    cmp [rbp - 3], BYTE 'm'
    jne _drawCharR

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
    add dil, 4
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 4
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 3
    mov dl, '*'
    call setPixel

    jmp _drawCharEnd

_drawCharR:
    cmp [rbp - 3], BYTE 'r'
    jne _drawCharEnd
    
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
    add dil, 2
    add sil, 3
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 2
    add sil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    mov dl, '*'
    call setPixel
    mov dil, [rbp - 1]
    mov sil, [rbp - 2]
    add dil, 1
    add sil, 2
    mov dl, '*'
    call setPixel

_drawCharEnd:
    mov rsp, rbp
    pop rbp
    ret