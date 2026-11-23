global main
global heat
global gradient

extern render_init
extern render_frame
extern render_shutdown
extern WindowShouldClose

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

    heat resb 10000
    randByte resb 1

section .text

main:

    and rsp, -16


    ; Initialize bottom row

    mov r10, 9900

loop_start:

    mov byte [rel heat + r10], 32

    inc r10
    cmp r10, 10000
    jne loop_start


    call render_init


render_loop:

    ; Check for close / ESC

    call WindowShouldClose
    test eax, eax
    jnz shutdown


    ; Reset simulation pointers

    mov r12, 9900
    mov r9, 9900
    mov r8, 9800


loop_upwards:

    copy_loop:

        movzx ebx, byte [rel heat + r9]

        ; Get random byte

        mov eax, 318
        mov rdi, randByte
        mov esi, 1
        xor edx, edx
        syscall

        movzx eax, byte [rel randByte]

        ; Cool by 0 or 1
        and eax, 1

        cmp ebx, eax
        jb underflow

        sub ebx, eax
        jmp no_underflow

    underflow:

        xor ebx, ebx

    no_underflow:

        mov r11, r8
        sub r8, rax

        mov r10, r12
        sub r10, 100

        cmp r8, r10
        jb wrap


    normal_copy:

        mov byte [rel heat + r8], bl
        mov r8, r11

        jmp finish_copy


    wrap:

        add r8, 100
        mov byte [rel heat + r8], bl
        mov r8, r11


    finish_copy:

        inc r9
        inc r8

        cmp r8, r12
        jne copy_loop


    sub r9, 200
    sub r12, 100

    cmp r12, 100
    je simulation_done

    sub r8, 200
    jmp loop_upwards


simulation_done:

    call render_frame

    jmp render_loop


shutdown:

    call render_shutdown
    ret


section .note.GNU-stack noalloc noexec nowrite progbits