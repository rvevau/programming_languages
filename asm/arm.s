.data
msg: .asciz "Hello, ibks!\n"
len = . - msg

.text
.global _start

_start:
    mov r0, #1       ; stdout
    ldr r1, =msg     ; сообщение
    ldr r2, =len     ; длина сообщения
    mov r7, #4       ; sys_write
    swi 0

    mov r0, #0       ; код возврата
    mov r7, #1       ; sys_exit
    swi 0