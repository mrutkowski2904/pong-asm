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

    .loop:

    mov dil, [rbp - 2]
    mov sil, [rbp - 3]
    mov dl, '|'
    call setPixel

    inc BYTE [rbp - 3]

    dec BYTE [rbp - 1]
    cmp BYTE [rbp - 1], 0
    jne .loop

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
    jne .end

    mov [keyUpdated], BYTE 0

    cmp [rawPressedKey], BYTE 'w'
    je .upKey

    cmp [rawPressedKey], BYTE 's'
    je .downKey

    jmp .end

    .upKey:
    cmp [playerY], BYTE 1
    je .end

    dec BYTE [playerY]
    jmp .end

    .downKey:
    mov bl, [dimensionY]
    sub bl, 5
    cmp [playerY], bl 
    je .end

    inc BYTE [playerY]
    jmp .end

    .end:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

computerPaddleUp:
    mov dil, [computerY]
    cmp dil, 1
    je .end
    dec BYTE [computerY]
    .end:
    ret

computerPaddleDown:
    mov sil, [dimensionY]
    dec sil
    mov dil, [computerY]
    add dil, PADDLE_HEIGHT
    cmp dil, sil
    je .end
    inc BYTE [computerY]
    .end:
    ret

moveComputerPaddle:
    push rbp
    mov rbp, rsp

    xor dil, dil
    ; if ballY => computerY && ballY <= (computerY + PADDLE_HEIGHT)
    mov al, [computerY]
    cmp  [ballPosY], al
    jl .moveRequired
    inc dil
    add al, PADDLE_HEIGHT
    cmp [ballPosY], al
    jg .moveRequired
    
    ; no action needed
    jmp .end

    .moveRequired:
    mov al, [computerY]
    ; dil == 0 -> ballY < computerY
    ; dil == 1 -> ballY > (computerY + PADDLE_HEIGHT)
    cmp dil, 0
    jne .moveDown
    .moveUp:
    call computerPaddleUp
    jmp .end

    .moveDown:
    call computerPaddleDown

    .end:
    mov rsp, rbp
    pop rbp
    ret