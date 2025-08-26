.model small
.stack 100h

.data
    msg db 'Hello, ibks!$'

.code
start:
    mov ax, @data
    mov ds, ax
    mov dx, offset msg
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h
end start