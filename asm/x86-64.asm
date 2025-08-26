section .data
    msg db 'Hello, ibks!', 0xA
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1       ; sys_write
    mov rdi, 1       ; stdout
    mov rsi, msg     ; сообщение
    mov rdx, len     ; длина сообщения
    syscall

    mov rax, 60      ; sys_exit
    xor rdi, rdi     ; код возврата 0
    syscall