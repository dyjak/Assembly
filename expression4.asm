       [bits 32]

;        esp -> [ret]  ; ret - return address

a        equ 4
b        equ 5
c        equ 6
d        equ 7

;           0:eax
;         + 0:esi
;         -------
;         edi:esi

          mov eax, a  ; eax = a
          mov esi, b  ; esi = b

          mul esi  ; eax = eax * esi

          push eax  ; eax -> stack

          mov eax, c  ; eax = c
          mov esi, d  ; esi = d

          mul esi  ; eax = eax * esi

          pop esi  ; esi <- stack

          add eax, esi  ; eax = eax + esi

          push eax  ; eax -> stack

;         esp -> [eax][ret]

          call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
          db 'wynik = %u', 0xA, 0
getaddr:

;         esp -> [format][eax][ret]

          call [ebx+3*4]  ; printf(format, eax);
          add esp, 2*4    ; esp = esp + 8

;         esp -> [ret]

          push 0          ; esp -> [0][ret]
          call [ebx+0*4]  ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwr�ci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif