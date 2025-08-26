.data
msg: .asciz "Hello, ibks!\n"
len = . - msg

.text
.global _start

_start:
    li a0, 1         ; stdout
    la a1, msg       ; сообщение
    li a2, len       ; длина сообщения
    li a7, 64        ; sys_write
    ecall

    li a0, 0         ; код возврата
    li a7, 93        ; sys_exit
    ecall