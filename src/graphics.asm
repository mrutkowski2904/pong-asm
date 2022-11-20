bits 64
default rel

global setPixel
global drawGameBoard
global drawBorder
global drawBuffer
global clearBuffer

global dimensionX
global dimensionY

extern system
extern printf

DIMENSION_X equ 70
DIMENSION_Y equ 23

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

    cmp dil, BYTE (DIMENSION_X - 1)
    jg _setPixelEnd
    cmp sil, BYTE (DIMENSION_Y - 1)
    jg _setPixelEnd

    cmp dil, BYTE 0
    jl _setPixelEnd
    cmp sil, BYTE 0
    jl _setPixelEnd

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

_gameBoardYLoop:
    ; draw line in the middle
    mov sil, [rbp - 4]
    and sil, 1
    cmp sil, 0
    je _gameBoardYLoopSkipMiddle

    mov dil, (DIMENSION_X / 2)
    mov sil, [rbp - 4]
    mov dl, '|'
    call setPixel

_gameBoardYLoopSkipMiddle:
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
    jl _gameBoardYLoop

_gameBoardXLoop:
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
    jl _gameBoardXLoop 

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

drawBorder:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx

    mov [rbp - 4], BYTE 0 ; y loop counter
    mov [rbp - 5], BYTE 0 ; x loop counter

_drawBorderYLoop:
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
    jl _drawBorderYLoop

_drawBorderXLoop:
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
    jl _drawBorderXLoop 

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

_drawBufferLoop:
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
    mov sil, [rsi]
    xor rdx, rdx
    lea rdi, [emptyPixelFormat]
    cmp sil, ' '
    je _drawBufferPrintf
    lea rdi, [pixelFormat]
_drawBufferPrintf:
    call printf wrt ..plt

    inc BYTE[rbp - 4]

    ; if not end of line, jump to loop
    cmp BYTE[rbp - 4], BYTE DIMENSION_X
    jl _drawBufferLoop

    ; else handle end of the line
    lea rdi, [newLineFormat]
    call printf wrt ..plt

    mov [rbp - 4], BYTE 0 ; zero x counter
    inc BYTE[rbp - 5]
    cmp BYTE[rbp - 5], BYTE DIMENSION_Y
    jl _drawBufferLoop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

clearBuffer:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx

    mov QWORD [rbp - 8], ((DIMENSION_X * DIMENSION_Y) - 1)

_clearBufferLoop:
    mov rax, [rbp - 8]
    dec QWORD [rbp - 8]
    lea rbx, [graphicsBuffer]
    add rbx, rax
    mov BYTE [rbx], ' '
    cmp QWORD [rbp - 8], 0
    jne _clearBufferLoop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

section .data
    pixelFormat : db `\033[107;97m%c\033[0m`, 0 ; white bg and fg
    emptyPixelFormat: db ` `, 0
    newLineFormat: db 10, 0
    graphicsBuffer: TIMES (DIMENSION_X * DIMENSION_Y) db ' '
    clearCmd: db "printf '\033[;H'", 0 ; move cursor to the top
    dimensionX: db DIMENSION_X
    dimensionY: db DIMENSION_Y
