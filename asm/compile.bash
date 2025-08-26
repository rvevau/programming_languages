# x86
nasm -f elf32 prog.asm -o prog.o && ld -m elf_i386 prog.o -o prog

# x86-64
nasm -f elf64 prog.asm -o prog.o && ld prog.o -o prog

# ARM
as -o prog.o prog.asm && ld -s -o prog prog.o

# ARM64
aarch64-linux-gnu-as -o prog.o prog.asm && aarch64-linux-gnu-ld -o prog prog.o