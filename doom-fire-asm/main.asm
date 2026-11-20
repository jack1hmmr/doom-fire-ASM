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

    ; Keep window open for now
    ; run the fire simulation
    call fire_update
    call graphics_draw

    ; Keep window open for now
    mov edi, 100000
    call SDL_Delay

    ; get rid window
    mov rdi, r12
    call SDL_DestroyWindow

    ; Shut down 
    call SDL_Quit

    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits