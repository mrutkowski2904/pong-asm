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

    xor dil, dil
    ; if ballY => computerY && ballY <= (computerY + PADDLE_HEIGHT)
    mov al, [computerY]
    cmp  [ballPosY], al
    jl _moveComputerPaddleMoveRequired
    inc dil
    add al, PADDLE_HEIGHT
    cmp [ballPosY], al
    jg _moveComputerPaddleMoveRequired
    
    ; no action needed
    jmp _moveComputerPaddleEnd

    _moveComputerPaddleMoveRequired:
    mov al, [computerY]
    ; dil == 0 -> ballY < computerY
    ; dil == 1 -> ballY > (computerY + PADDLE_HEIGHT)
    cmp dil, 0
    jne _moveComputerPaddleMoveB
    _moveComputerPaddleMoveA:
    call computerPaddleUp
    jmp _moveComputerPaddleEnd

    _moveComputerPaddleMoveB:
    call computerPaddleDown

    _moveComputerPaddleEnd:
    mov rsp, rbp
    pop rbp
    ret