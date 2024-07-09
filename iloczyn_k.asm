[bits 32]

n equ 3  ;iloczyn = 2 * 4 * 6 = 48

mov ecx, dword n    ;ecx = n
mov eax, dword 1    ;eax = 1
mov esi, dword 0    ;esi = 0

looop:
      add esi, dword 2
      mul esi  ;eax = eax * esi

      dec ecx
      cmp ecx, 0
      jne looop
      

      push eax      ;esp->[eax][ret]

      call getaddr  ;esp->[format][eax][ret]
format:
         db "wynik = %d", 0xA, 0
getaddr:
         call [ebx+3*4]  ; printf(format, eax, edx);
         add esp, 2*4

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);