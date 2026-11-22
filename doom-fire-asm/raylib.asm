global render_init
global render_frame
global render_shutdown

extern InitWindow
extern SetTargetFPS
extern BeginDrawing
extern EndDrawing
extern DrawRectangle
extern CloseWindow

extern heat
extern gradient

section .rodata

title:
    db "DOOM FIRE", 0

section .text

render_init:
    sub rsp, 8

    mov edi, 1000
    mov esi, 1000
    lea rdx, [rel title]
    call InitWindow

    add rsp, 8
    ret


render_frame:
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8

    call BeginDrawing

    ; existing renderer code...

    call EndDrawing

    add rsp, 8

    pop r15
    pop r14
    pop r13
    pop r12

    ret


render_shutdown:

    call CloseWindow

    ret