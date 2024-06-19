         [bits 64]

extern   printf
extern   exit

section  .data

section .bss

section  .text

a       equ -2147483648
b       equ -1

global   main

main:

;       rsp -> [ret]

;       rcx, rdx, r8, r9, stack

        mov rcx, format  ; rcx = format
        mov rdx, a       ; rdx = a
        mov r8, b        ; r8 = b
        mov r9, a        ; r9 = a

        add r9, b  ; r9 = r9 + b

        sub rsp, 32  ; reserve the shadow space

;       rsp -> [shadow][ret]

        call printf  ; printf(format, a, b, suma);

        add rsp, 4*8  ; rsp = rsp + 32

;       rsp -> [ret]

        ret

format:
        db "a = %d", 0xA
        db "b = %d", 0xA, 0xA
        db "suma = %lld", 0xA, 0


%ifdef COMMENT

nasm add6.asm -o add6.o -f win64
gcc add6.o -o add6.exe -m64

%endif