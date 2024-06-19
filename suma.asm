         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 6

         mov ecx, n  ; ecx = n
         mov eax, 0  ; eax = 0

         test ecx, ecx  ; ecx & ecx ;  OF=0 SF ZF PF CF=0 affected

         je done  ; jump if equal   ;  ZF = 0

petla    add eax, ecx  ; eax = eax + ecx

         loop petla

done     push eax

;        esp -> [eax][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to get address
format:
         db "suma = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf(format, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp ->[0][ret]
         call [ebx+0*4]  ; exit(0);