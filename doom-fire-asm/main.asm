global main

extern graphics_init
extern graphics_draw
extern fire_update
extern SDL_Delay
extern SDL_DestroyWindow
extern SDL_Quit

section .text

main:
    push rbp
    mov rbp, rsp

    ; start graphics, make window
    call graphics_init

    mov r12, rax

fire_loop:
    call fire_update
    call graphics_draw

    mov edi, 16
    call SDL_Delay

    jmp fire_loop

    ; get rid window
    mov rdi, r12
    call SDL_DestroyWindow

    ; Shut down 
    call SDL_Quit

    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits