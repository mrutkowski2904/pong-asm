bits 64
default rel

global runGame

extern exitGame
extern drawBuffer
extern drawBorder
extern drawGameBoard
extern clearBuffer
extern drawPaddle
extern setPixel
extern rawPressedKey
extern keyUpdated
extern makeBeep
extern drawText
extern drawDigit
extern drawSprite
extern handlePlayerInput
extern moveComputerPaddle

extern dimensionX
extern dimensionY

extern usleep

global computerY
global playerY
global ballPosX
global ballPosY

START_SCREEN equ 0
GAME_SCREEN equ 1
PLAYER_X equ 3
COMPUTER_X equ 61

section .text

runGame:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 2], BYTE 0 ; player and computer lives counter
    mov [rbp - 3], BYTE 0 ; underline counter
    mov [rbp - 4], BYTE START_SCREEN

    call resetBall
    mov al, [dimensionY]
    shr al, 1
    sub al, 2
    mov [playerY], al
    mov [computerY], al

    .gameLoop:
    ; detect state
    ; title screen
    cmp [rbp - 4], BYTE START_SCREEN
    je .startScreen

    ; game
    cmp [rbp - 4], BYTE GAME_SCREEN
    je .gameplay


;=================================================
; START: TITLE SCREEN LOGIC
;=================================================
    .startScreen:
    call drawBorder

    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 9
    mov r12b, dil
    mov sil, 5
    lea rdx, [gameTitle]
    call drawText

    mov dil, r12b
    sub dil, 2
    mov sil, 12
    lea rdx, [authorText]
    call drawText

    ; draw horizontal line under title
    sub r12b, 4
    mov [rbp - 3], BYTE 25
    .startScreenUnderlineLoop:

    mov al, [rbp - 3]
    mov dil, r12b
    add dil, al
    mov sil, 10
    mov dl, '*'
    call setPixel

    dec BYTE [rbp - 3]
    cmp BYTE [rbp - 3], 0
    jne .startScreenUnderlineLoop


    ; handle key press on start screen
    cmp [keyUpdated], BYTE 1
    jne .startScreenSkipKey

    mov [keyUpdated], BYTE 0
    mov [rbp - 4], BYTE GAME_SCREEN

    .startScreenSkipKey:
    jmp .gameLoopRepeat
;=================================================
; END: TITLE SCREEN LOGIC
;=================================================


;=================================================
; START: GAMEPLAY LOGIC
;=================================================
    .gameplay:
    call drawGameBoard
    call handlePlayerInput
    call handleBall

    ; draw player lives
    mov [rbp - 2], BYTE 0
    mov al, 3
    .playerLivesLoop:
    mov ah, [playerLives]
    cmp BYTE [rbp - 2], ah
    je .playerLivesLoopEnd

    add al, 2
    mov dil, al
    mov sil, 2
    mov dl, '#'
    call setPixel

    inc BYTE [rbp - 2]
    jmp .playerLivesLoop
    .playerLivesLoopEnd:

    ; draw computer lives
    mov [rbp - 2], BYTE 0
    mov al, [dimensionX]
    sub al, 4
    .computerLivesLoop:
    mov ah, [computerLives]
    cmp BYTE [rbp - 2], ah
    je .computerLivesLoopEnd

    sub al, 2
    mov dil, al
    mov sil, 2
    mov dl, '#'
    call setPixel

    inc BYTE [rbp - 2]
    jmp .computerLivesLoop
    .computerLivesLoopEnd:

    ; draw ball
    mov dil, [ballPosX]
    mov sil, [ballPosY]
    mov dl, 'O'
    call setPixel

    mov dil, PLAYER_X
    mov sil, [playerY]
    call drawPaddle

    mov dil, COMPUTER_X
    mov sil, [computerY]
    call drawPaddle

    call moveComputerPaddle

    jmp .gameLoopRepeat
;=================================================
; END: GAMEPLAY LOGIC
;=================================================

    .gameLoopRepeat:
    ; draw new screen
    call drawBuffer

    ; wait before next game update
    mov rdi, (40 * 1000)
    call usleep wrt ..plt

    call clearBuffer
    jmp .gameLoop

    mov rsp, rbp
    pop rbp
    ret

handleBall:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    ; handle collision
    .ballYMaxCheck:
    mov al, [dimensionY]
    dec al
    dec al

    cmp [ballPosY], al
    jne .ballYMinCheck
    neg BYTE [ballSpeedY]

    .ballYMinCheck:
    cmp [ballPosY], BYTE 1
    jne .ballXMaxCheck
    neg BYTE [ballSpeedY]

    .ballXMaxCheck:
    mov al, [dimensionX]
    dec al
    dec al

    cmp [ballPosX], al
    jne .ballXMinCheck
    neg BYTE [ballSpeedX]

    ; TODO: Player scores
    dec BYTE [computerLives]
    call resetBall
    mov rdi, (350 * 1000)
    call usleep wrt ..plt
    neg BYTE [ballSpeedX]
    call checkPoints

    .ballXMinCheck:
    cmp [ballPosX], BYTE 1
    jne .ballCheckPlayerPaddle
    neg BYTE [ballSpeedX]

    dec BYTE [playerLives]
    call resetBall
    mov rdi, (350 * 1000)
    call usleep wrt ..plt
    call makeBeep
    call checkPoints

    .ballCheckPlayerPaddle:
    cmp [ballPosX], BYTE (PLAYER_X + 1)
    jne .ballCheckComputerPaddle

    mov al, [playerY]
    cmp [ballPosY], al
    jl .ballCheckComputerPaddle

    add al, 4
    cmp [ballPosY], al
    jg .ballCheckComputerPaddle

    ; bounce
    neg BYTE [ballSpeedX]

    .ballCheckComputerPaddle:
    cmp [ballPosX], BYTE (COMPUTER_X - 1)
    jne .ballChecksEnd

    mov al, [computerY]
    cmp [ballPosY], al
    jl .ballChecksEnd

    add al, 4
    cmp [ballPosY], al
    jg .ballChecksEnd

    ; bounce
    neg BYTE [ballSpeedX]

    .ballChecksEnd:
    ; update ball position
    mov al, [ballSpeedX]
    add [ballPosX], al

    mov al, [ballSpeedY]
    add [ballPosY], al

    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

resetBall:
    mov al, [dimensionY]
    shr al, 1
    mov [ballPosY], al
    mov al, [dimensionX]
    shr al, 2
    mov [ballPosX], al
    ret

checkPoints:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    cmp [playerLives], BYTE 0
    je .checkPlayerLoses

    cmp [computerLives], BYTE 0
    je .checkPlayerWins

    jmp .pointCheckEnd
    .checkPlayerLoses:
    call clearBuffer
    lea rdx, [playerLosesText]
    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 20
    jmp .pointCheckQuitGame

    .checkPlayerWins:
    call clearBuffer
    lea rdx, [playerWinsText]
    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 18
    jmp .pointCheckQuitGame

    .pointCheckQuitGame:
    mov sil, [dimensionY]
    sub sil, 4
    shr sil, 1
    call drawText

    call drawBorder
    call drawBuffer
    call makeBeep

    mov rdi, (500 * 1000)
    call usleep wrt ..plt
    call exitGame

    .pointCheckEnd:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

section .data
    gameTitle: db 'pong', 0
    authorText: db 'by mr', 0
    playerWinsText: db 'you win', 0
    playerLosesText: db 'you lose', 0

    playerY: db 1
    computerY: db 1

    ballPosX: db 0
    ballPosY: db 0
    ballSpeedX: db 1
    ballSpeedY: db 1

    playerLives: db 3
    computerLives: db 3