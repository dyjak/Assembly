         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -2147483650
b        equ -3

%define  UINT_MAX 4294967295

a_l      equ a % (UINT_MAX + 1)
a_h      equ a / (UINT_MAX + 1)

         mov eax, a_l  ; eax = a_l

         ;cdq  ; edx:eax = eax ; sign conversion

         mov edx, a_h  ; edx = a_h

         mov ecx, b  ; ecx = 0

;        Dzielenie ze znakiem liczby 64-bitowej edx:eax przez argument

         idiv ecx    ; eax = edx:eax / ecx  ; iloraz
                     ; edx = edx:eax % ecx  ; reszta

;        idiv arg    ; eax = edx:eax / arg  ; iloraz
                     ; edx = edx:eax % arg  ; reszta

         push edx
         push eax

;        esp -> [format][eax][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "iloraz = %d", 0xA
         db "reszta = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);