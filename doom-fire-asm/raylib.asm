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

    xor r12d, r12d        ; X = 0
    xor r13d, r13d        ; Y = 0
    xor r14d, r14d        ; heat index = 0
    xor r15d, r15d        ; row = 0

draw_frame_row:

    ; heat[index] -> gradient index
    movzx eax, byte [heat + r14]
    imul eax, 3

    ; gradient + (heat * 3)
    lea r10, [rel gradient]
    add r10, rax

    ; R
    movzx eax, byte [r10]

    ; G
    movzx ecx, byte [r10 + 1]
    shl ecx, 8
    or eax, ecx

    ; B
    movzx ecx, byte [r10 + 2]
    shl ecx, 16
    or eax, ecx

    ; A = 255
    mov ecx, 0xFF
    shl ecx, 24
    or eax, ecx

    ; Color -> 5th argument
    mov r8d, eax

    ; DrawRectangle(x, y, 10, 10, color)
    mov edi, r12d
    mov esi, r13d
    mov edx, 10
    mov ecx, 10

    call DrawRectangle

    add r12d, 10
    inc r14d

    cmp r14d, 100
    jne draw_frame_row

    ; Finished one row
    xor r12d, r12d
    add r13d, 10
    xor r14d, r14d

    inc r15d
    cmp r15d, 100
    jne draw_frame_row

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