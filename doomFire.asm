global _start

section .bss
    heat     resb 10000
    nextHeat resb 10000
    randomOutput resb 1

section .data
    message db "DOOM FIRE STARTING!!!!", 10
    messageLen equ $ - message
    randomState dd 123456789

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, messageLen
    syscall

    mov rcx, 100
    mov rdi, heat + 9900

fill_bottom:
    mov byte [rdi], 37
    inc rdi
    loop fill_bottom
    
    mov rcx, 100
    mov rsi, 9900
    mov rdi, 9800

spread_heat:
    mov al, [heat + rsi]
    mov bl, al

    call random_number

    sub bl, al
    mov [nextHeat + rdi], bl

    mov [nextHeat + rdi - 2], bl

    mov rax, 60
    mov rdi, 0
    syscall

random_number:
    mov eax, [randomState]

    shl eax, 13
    xor [randomState], eax

    mov eax, [randomState]
    shr eax, 17
    xor [randomState], eax

    mov eax, [randomState]
    shl eax, 5
    xor [randomState], eax
    mov eax, [randomState]
    shr eax, 30

    ret