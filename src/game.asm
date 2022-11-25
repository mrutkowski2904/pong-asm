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

    _gameLoop:
    ; detect state
    ; title screen
    cmp [rbp - 4], BYTE START_SCREEN
    je _handleStartScreen

    ; game
    cmp [rbp - 4], BYTE GAME_SCREEN
    je _handleGameplay


;=================================================
; START: TITLE SCREEN LOGIC
;=================================================
    _handleStartScreen:
    call drawBorder

    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 8
    mov r12b, dil
    ; mov dil, 25
    mov sil, 5
    lea rdx, [gameTitle]
    call drawText

    mov dil, r12b
    sub dil, 2
    ; mov dil, 23
    mov sil, 12
    lea rdx, [authorText]
    call drawText

    ; draw horizontal line under title
    mov [rbp - 3], BYTE 25
    _handleStartScreenUnderlineLoop:

    mov al, [rbp - 3]
    mov dil, 20
    add dil, al
    mov sil, 10
    mov dl, '*'
    call setPixel

    dec BYTE [rbp - 3]
    cmp BYTE [rbp - 3], 0
    jne _handleStartScreenUnderlineLoop


    ; handle key press on start screen
    cmp [keyUpdated], BYTE 1
    jne _startScreenSkipKey

    mov [keyUpdated], BYTE 0
    mov [rbp - 4], BYTE GAME_SCREEN

    _startScreenSkipKey:
    jmp _gameLoopRepeat
;=================================================
; END: TITLE SCREEN LOGIC
;=================================================


;=================================================
; START: GAMEPLAY LOGIC
;=================================================
    _handleGameplay:
    call drawGameBoard
    call handlePlayerInput
    call handleBall

    ; draw player lives
    mov [rbp - 2], BYTE 0
    mov al, 3
    _drawPlayerLivesLoop:
    mov ah, [playerLives]
    cmp BYTE [rbp - 2], ah
    je _drawPlayerLivesLoopEnd

    add al, 2
    mov dil, al
    mov sil, 2
    mov dl, '#'
    call setPixel

    inc BYTE [rbp - 2]
    jmp _drawPlayerLivesLoop
    _drawPlayerLivesLoopEnd:

    ; draw computer lives
    mov [rbp - 2], BYTE 0
    mov al, [dimensionX]
    sub al, 4
    ; mov al, 56
    ; mov al, 30
    _drawComputerLivesLoop:
    mov ah, [computerLives]
    cmp BYTE [rbp - 2], ah
    je _drawComputerLivesLoopEnd

    sub al, 2
    mov dil, al
    mov sil, 2
    mov dl, '#'
    call setPixel

    inc BYTE [rbp - 2]
    jmp _drawComputerLivesLoop
    _drawComputerLivesLoopEnd:

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

    jmp _gameLoopRepeat
;=================================================
; END: GAMEPLAY LOGIC
;=================================================

    _gameLoopRepeat:
    ; draw new screen
    call drawBuffer

    ; wait before next game update
    mov rdi, (40 * 1000)
    call usleep wrt ..plt

    call clearBuffer
    jmp _gameLoop

    mov rsp, rbp
    pop rbp
    ret

handleBall:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    ; handle collision
    _handleBallYMaxCheck:
    mov al, [dimensionY]
    dec al
    dec al

    cmp [ballPosY], al
    jne _handleBallYMinCheck
    neg BYTE [ballSpeedY]

    _handleBallYMinCheck:
    cmp [ballPosY], BYTE 1
    jne _handleBallXMaxCheck
    neg BYTE [ballSpeedY]

    _handleBallXMaxCheck:
    mov al, [dimensionX]
    dec al
    dec al

    cmp [ballPosX], al
    jne _handleBallXMinCheck
    neg BYTE [ballSpeedX]

    ; TODO: Player scores
    dec BYTE [computerLives]
    call resetBall
    mov rdi, (350 * 1000)
    call usleep wrt ..plt
    neg BYTE [ballSpeedX]
    call checkPoints

    _handleBallXMinCheck:
    cmp [ballPosX], BYTE 1
    jne _handleBallCheckPlayerPaddle
    neg BYTE [ballSpeedX]

    ; TODO: Computer scores
    dec BYTE [playerLives]
    call resetBall
    mov rdi, (350 * 1000)
    call usleep wrt ..plt
    call makeBeep
    call checkPoints

    _handleBallCheckPlayerPaddle:
    cmp [ballPosX], BYTE (PLAYER_X + 1)
    jne _handleBallCheckComputerPaddle

    mov al, [playerY]
    cmp [ballPosY], al
    jl _handleBallCheckComputerPaddle

    add al, 4
    cmp [ballPosY], al
    jg _handleBallCheckComputerPaddle

    ; bounce
    neg BYTE [ballSpeedX]
    ; neg BYTE [ballSpeedY]

    _handleBallCheckComputerPaddle:
    cmp [ballPosX], BYTE (COMPUTER_X - 1)
    jne _handleBallChecksEnd

    mov al, [computerY]
    cmp [ballPosY], al
    jl _handleBallChecksEnd

    add al, 4
    cmp [ballPosY], al
    jg _handleBallChecksEnd

    ; bounce
    neg BYTE [ballSpeedX]
    ; neg BYTE [ballSpeedY]

    _handleBallChecksEnd:
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
    je _checkPointsPlayerLoses

    cmp [computerLives], BYTE 0
    je _checkPointsPlayerWins

    jmp _checkPointsEnd
    _checkPointsPlayerLoses:
    call clearBuffer
    lea rdx, [playerLosesText]
    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 20
    jmp _checkPointsQuitGame

    _checkPointsPlayerWins:
    call clearBuffer
    lea rdx, [playerWinsText]
    mov dil, [dimensionX]
    shr dil, 1
    sub dil, 18
    jmp _checkPointsQuitGame

    _checkPointsQuitGame:
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

    _checkPointsEnd:
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

    playerLives: db 1
    computerLives: db 3