global graphics_init

extern SDL_Init
extern SDL_CreateWindow

section .data
    window_title db "DOOM FIRE IN ASSEMBLY", 0

section .text

graphics_init:
    push rbp
    mov rbp, rsp
    
    ; some random stuff
    mov edi, 0x00000020
    call SDL_Init

    ; make a window (:
    mov rdi, window_title
    mov esi, 0x2FFF0000
    mov edx, 0x2FFF0000
    mov ecx, 1000
    mov r8d, 1000
    mov r9d, 0x00000004
    call SDL_CreateWindow
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits