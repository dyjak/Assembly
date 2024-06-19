         [bits 64]

extern   printf
extern   exit

section  .data

format   db "a", 0xA, 0
section .bss

section  .text

a      equ 1

global   main

main:

;       rsp -> [ret]

;       rcx, rdx, r8, r9, stack
;       rdi, rsi, rdx, rcx, r8, r9, stack

        mov rdi, format  ; rcx = format

        call printf  ; printf(format, a, b, suma);

        add rsp, 4*8  ; rsp = rsp + 32

;       rsp -> [ret]

        ret



%ifdef COMMENT

nasm add6.asm -o add6.o -f win64
gcc add6.o -o add6.exe -m64

%endif