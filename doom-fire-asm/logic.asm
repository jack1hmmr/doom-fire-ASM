global main
global heat
global gradient

extern render_init
extern render_frame

section .data

gradient:
    db 7,7,7
    db 31,7,7
    db 47,15,7
    db 71,15,7
    db 87,23,7
    db 103,31,7
    db 119,31,7
    db 143,39,7
    db 159,47,7
    db 175,63,7
    db 191,71,7
    db 199,71,7
    db 223,79,7
    db 223,87,7
    db 223,87,7
    db 215,95,7
    db 215,95,7
    db 215,103,15
    db 207,111,15
    db 207,119,15
    db 207,127,15
    db 207,135,23
    db 199,135,23
    db 199,143,23
    db 199,151,31
    db 191,159,31
    db 191,159,31
    db 191,167,39
    db 191,167,39
    db 191,175,47
    db 183,175,47
    db 183,183,47
    db 183,183,55
    db 207,207,111
    db 223,223,159
    db 239,239,199
    db 255,255,255

section .bss

heat:
    resb 10000

randByte:
    resb 1

section .text

main:

    and rsp, -16

    ; Initialize bottom row
    ; heat[9900..9999] = 32

    mov r10, 9900

loop_start:

    mov byte [rel heat + r10], 32

    inc r10
    cmp r10, 10000
    jne loop_start


    ; Start renderer
    ; Simulation temporarily disabled

    call render_init

render_loop:

    call render_frame
    jmp render_loop


section .note.GNU-stack noalloc noexec nowrite progbits