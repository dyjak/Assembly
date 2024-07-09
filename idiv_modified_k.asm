[bits 32]

a        equ -2147483650
b        equ -3

%define  UINT_MAX 4294967295

a_l equ a%(UINT_MAX+1)
a_h equ a/(UINT_MAX+1)

mov eax, a_l
mov edx, a_h
mov ecx, b

idiv ecx

push edx
push eax


call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "iloraz = %i", 0xA
         db "reszta = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);