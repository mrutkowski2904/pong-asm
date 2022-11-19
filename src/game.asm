bits 64
default rel

global runGame

extern drawBuffer
extern drawTitleScreen
extern drawGameBoard
extern clearBuffer

extern rawPressedKey
extern keyUpdated

extern usleep

START_SCREEN equ 0
GAME_SCREEN equ 1

section .text
runGame:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rbp - 4], BYTE START_SCREEN

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
