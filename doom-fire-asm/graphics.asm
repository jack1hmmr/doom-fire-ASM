global graphics_init

extern SDL_Init
extern SDL_CreateWindow
extern SDL_CreateRGBSurfaceFrom

section .bss
    pixelBuffer resb 3000000

section .data
    window_title db "DOOM-FIRE IN ASM", 0

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
    ; fill the pixel buffer
    mov rdi, pixelBuffer
    mov rcx, 1000000
    mov al, 255

fill_pixels:
    mov byte [rdi], 255
    mov byte [rdi + 1], 0
    mov byte [rdi + 2], 0
    add rdi, 3
    loop fill_pixels
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits