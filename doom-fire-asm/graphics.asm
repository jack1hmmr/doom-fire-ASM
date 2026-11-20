global graphics_init
global graphics_draw
global pixelBuffer

extern SDL_Init
extern SDL_CreateWindow
extern SDL_CreateRGBSurfaceFrom
extern SDL_GetWindowSurface
extern SDL_UpperBlit
extern SDL_UpdateWindowSurface

section .bss
    pixelBuffer resb 3000000
    windowHandle resq 1
    pixelSurface resq 1

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
    mov [windowHandle], rax

    ; create an SDL surface using our pixel buffer
    mov rdi, pixelBuffer
    mov esi, 1000
    mov edx, 1000
    mov ecx, 24
    mov r8d, 3000
    mov r9d, 0x00FF0000

    push 0xFF000000
    push 0x000000FF
    push 0x0000FF00
    call SDL_CreateRGBSurfaceFrom
    add rsp, 24

    mov [pixelSurface], rax

; fill the pixel buffer
    mov rdi, pixelBuffer
    mov rcx, 1000000
    mov al, 255

fill_pixels:
    mov byte [rdi], 0
    mov byte [rdi + 1], 0
    mov byte [rdi + 2], 255
    add rdi, 3
    loop fill_pixels

    mov rax, [windowHandle]
    pop rbp
    ret

graphics_draw:
    push rbp
    mov rbp, rsp

    mov rdi, [windowHandle]
    call SDL_GetWindowSurface

    mov rdi, [pixelSurface]
    xor esi, esi
    mov rdx, rax
    xor ecx, ecx
    call SDL_UpperBlit

    mov rdi, [windowHandle]
    call SDL_UpdateWindowSurface

    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits