bits 64
default rel

global drawPaddle
global handlePlayerInput
global moveComputerPaddle

extern setPixel
extern ballPosX
extern ballPosY
extern computerY
extern dimensionY
extern playerY
extern rawPressedKey
extern keyUpdated

PADDLE_HEIGHT equ 4

section .text

; Draw users paddle at specified
; Args:
; dil - x
; sil - y 
drawPaddle:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx
    
    mov [rbp - 1], BYTE PADDLE_HEIGHT
    mov [rbp - 2], dil ; save x
    mov [rbp - 3], sil ; save y

    _drawPaddleLoop:

    mov dil, [rbp - 2]
    mov sil, [rbp - 3]
    mov dl, '|'
    call setPixel

    inc BYTE [rbp - 3]

    dec BYTE [rbp - 1]
    cmp BYTE [rbp - 1], 0
    jne _drawPaddleLoop

    pop rbx
    mov rsp, rbp
    pop rbp
    ret

handlePlayerInput:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    cmp [keyUpdated], BYTE 1
    jne _handlePlayerInputEnd

    mov [keyUpdated], BYTE 0

    cmp [rawPressedKey], BYTE 'w'
    je _handleUpKey

    cmp [rawPressedKey], BYTE 's'
    je _handleDownKey

    jmp _handlePlayerInputEnd

    _handleUpKey:
    cmp [playerY], BYTE 1
    je _handlePlayerInputEnd

    dec BYTE [playerY]
    jmp _handlePlayerInputEnd

    _handleDownKey:
    mov bl, [dimensionY]
    sub bl, 5
    cmp [playerY], bl 
    je _handlePlayerInputEnd

    inc BYTE [playerY]
    jmp _handlePlayerInputEnd

    _handlePlayerInputEnd:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

computerPaddleUp:
    mov dil, [computerY]
    cmp dil, 1
    je _computerPaddleUpEnd
    dec BYTE [computerY]
    _computerPaddleUpEnd:
    ret

computerPaddleDown:
    mov sil, [dimensionY]
    dec sil
    mov dil, [computerY]
    add dil, PADDLE_HEIGHT
    cmp dil, sil
    je _computerPaddleDownEnd
    inc BYTE [computerY]
    _computerPaddleDownEnd:
    ret

moveComputerPaddle:
    push rbp
    mov rbp, rsp

    mov al, [computerY]
    add al, (PADDLE_HEIGHT / 2)
    cmp al, [ballPosY]
    je _moveComputerPaddleEnd

    cmp al, [ballPosY]
    jl _moveComputerPaddleUp
    call computerPaddleDown
    jmp _moveComputerPaddleEnd

    _moveComputerPaddleUp:
    call computerPaddleUp

    _moveComputerPaddleEnd:
    mov rsp, rbp
    pop rbp
    ret