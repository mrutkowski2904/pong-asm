bits 64
default rel

global runGame

extern drawBuffer
extern drawTitleScreen
extern drawGameBoard
extern clearBuffer
extern drawPaddle
extern rawPressedKey
extern keyUpdated
extern setPixel

extern dimensionX
extern dimensionY

extern usleep

START_SCREEN equ 0
GAME_SCREEN equ 1

section .text
runGame:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 4], BYTE START_SCREEN
    mov al, [dimensionY]
    shr al, 1

    mov [ballPosY], al
    mov [ballPosX], BYTE 5

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
    call drawTitleScreen

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

    ; draw ball
    mov dil, [ballPosX]
    mov sil, [ballPosY]
    mov dl, 'O'
    call setPixel

    mov dil, 3
    mov sil, [playerY]
    call drawPaddle

    jmp _gameLoopRepeat
;=================================================
; END: GAMEPLAY LOGIC
;=================================================


_gameLoopRepeat:
    ; draw new screen
    call drawBuffer

    ; wait for 77 ms before next game update
    mov rdi, (77 * 1000)
    call usleep wrt ..plt

    call clearBuffer
    jmp _gameLoop

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
    ; TODO: Player scores
    mov al, [dimensionX]
    dec al
    dec al

    cmp [ballPosX], al
    jne _handleBallXMinCheck
    neg BYTE [ballSpeedX]

_handleBallXMinCheck:
    ; TODO: Computer scores
    cmp [ballPosX], BYTE 1
    jne _handleBallChecksEnd
    neg BYTE [ballSpeedX]


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

section .data
    playerY: db 5

    ballPosX: db 0
    ballPosY: db 0
    ballSpeedX: db 1
    ballSpeedY: db 1