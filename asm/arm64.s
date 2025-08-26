.data
msg: .asciz "Hello, ibks!\n"
len = . - msg

.text
.global _start

_start:
    mov x0, #1       ; stdout
    adr x1, msg      ; сообщение
    mov x2, #len     ; длина сообщения
    mov x8, #64      ; sys_write
    svc 0

    mov x0, #0       ; код возврата
    mov x8, #93      ; sys_exit
    svc 0