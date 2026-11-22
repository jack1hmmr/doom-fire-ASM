global _start

section .data

gradient:
    1: db 7,7,7
    2: db 31,7,7
    3: db 47,15,7
    4: db 71,15,7
    5: db 87,23,7
    6: db 103,31,7
    7: db 119,31,7
    8: db 143,39,7
    9: db 159,47,7
    10: db 175,63,7
    11: db 191,71,7
    12: db 199,71,7
    13: db 223,79,7
    14: db 223,87,7
    15: db 223,87,7
    16: db 215,95,7
    17: db 215,95,7
    18: db 215,103,15
    19: db 207,111,15
    20: db 207,119,15
    21: db 207,127,15
    22: db 207,135,23
    23: db 199,135,23
    24: db 199,143,23
    25: db 199,151,31
    26: db 191,159,31
    27: db 191,159,31
    28: db 191,167,39
    29: db 191,167,39
    30: db 191,175,47
    31: db 183,175,47
    32: db 183,183,47
    33: db 183,183,55
    34: db 207,207,111
    35: db 223,223,159
    36: db 239,239,199
    37: db 255,255,255

section .bss
    heat resb 10000
    randByte resb 1

section .text
_start:

counters:

    mov r12, 9900
    mov r10, 9900
    mov r9, 9900
    mov r8, 9800

loop_start:

    mov byte [heat + r10], 32


    inc r10
    cmp r10, 10000
    jne loop_start


loop_upwards:
    copy_loop:

        mov bl, [heat + r9]

        mov eax, 318          
        mov rdi, randByte   
        mov esi, 1            
        xor edx, edx          
        syscall

        movzx eax, byte [randByte]
        and eax, 3
        
        sub bl, al
        
        jnc no_underflow   
        xor bl, bl          
        no_underflow:
            sub r8, rax
            mov byte [heat + r8], bl
            add r8, rax

            inc r9
            inc r8
            cmp r8, r12
            jne copy_loop

    
    sub r9, 200
    sub r12, 100
    cmp r8, 100
    je done
    sub r8, 200
    jmp loop_upwards

done:

    mov eax, 60   
    xor edi, edi  
    syscall


section .note.GNU-stack noalloc noexec nowrite progbits