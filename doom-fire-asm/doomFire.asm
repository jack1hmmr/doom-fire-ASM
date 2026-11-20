global fire_update
extern pixelBuffer

section .bss
    heat     resb 10000
    nextHeat resb 10000
    randomOutput resb 1

section .data
    message db "DOOM FIRE STARTING!!!!", 10
    messageLen equ $ - message
    randomState dd 123456789

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

gradient_end:
    gradient_length equ (gradient_end - gradient) / 3


section .text

fire_update:
    
    ; Seed the bottom row with maximum heat
    
    mov rcx, 100
    mov rdi, heat + 9900

fill_bottom:
    mov byte [rdi], 36
    inc rdi
    loop fill_bottom

    
    ; Spread heat upward
    
    mov rsi, 9900
    mov rdi, 9800
    mov r9, 99

outer_loop:
    xor r10, r10
    mov rcx, 100

spread_heat:
    mov al, [heat + rsi]
    mov bl, al

    call random_number

    cmp bl, al
    jb no_heat

    sub bl, al
    jmp cooling_done

no_heat:
    xor bl, bl

cooling_done:
    mov [heat + rdi], bl

    ; horizontal wrap
    cmp r10, 2
    jb wrap_left

    mov [heat + rdi - 2], bl
    jmp spread_done

wrap_left:
    mov [heat + rdi + 98], bl

spread_done:
    inc rsi
    inc rdi
    inc r10
    loop spread_heat

    sub rsi, 200
    sub rdi, 200

    dec r9
    jnz outer_loop

    ; Convert the 100x100 heat grid into pixels
    ; Each heat cell becomes a 10x10 pixel block
    
    xor r10, r10                 ; heat row = 0

draw_rows:
    xor r11, r11                 ; heat column = 0

draw_columns:
    ; heat index = row * 100 + column
    mov eax, r10d
    imul eax, 100
    add eax, r11d

    ; get heat value
    movzx eax, byte [heat + rax]

    ; heat value -> RGB gradient entry
    imul eax, 3
    lea rsi, [gradient + eax]

    ; screen Y = row * 10
    mov eax, r10d
    imul eax, 10
    imul eax, 1000

    ; screen X = column * 10
    mov edx, r11d
    imul edx, 10

    add eax, edx
    imul eax, 3

    ; pixelBuffer + offset
    lea rdi, [pixelBuffer + rax]

    ; Draw this heat cell as a 10x10 block
    
    mov r8, 10

draw_block_rows:
    mov r9, 10
    mov rdx, rdi

draw_block_columns:
    mov al, [rsi]
    mov [rdx], al

    mov al, [rsi + 1]
    mov [rdx + 1], al

    mov al, [rsi + 2]
    mov [rdx + 2], al

    add rdx, 3
    dec r9
    jnz draw_block_columns

    add rdi, 3000
    dec r8
    jnz draw_block_rows

    inc r11
    cmp r11, 100
    jb draw_columns

    inc r10
    cmp r10, 100
    jb draw_rows

    ret


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

section .note.GNU-stack noalloc noexec nowrite progbits