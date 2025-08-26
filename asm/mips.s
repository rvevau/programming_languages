.data
msg: .asciiz "Hello, ibks!\n"
len = . - msg

.text
.globl main

main:
    li $v0, 4        ; sys_write
    la $a0, msg      ; сообщение
    li $a1, len      ; длина сообщения
    syscall

    li $v0, 10       ; sys_exit
    syscall