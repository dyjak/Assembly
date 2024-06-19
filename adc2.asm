         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ -5
         
         mov eax, a  ; eax = a

         clc  ; CF = 0

         adc eax, b  ; eax = eax + b + CF

         push eax  ; esp -> stack

;        esp -> [eax][ret]

         mov eax, a  ; eax = a

         stc  ; CF = 1
         
         adc eax, b  ; eax = eax + b + CF

         push eax  ; esp -> stack
         
;        esp -> [eax][eax][ret]

         call getaddr
format:
         db "suma2 = %d", 0xA
         db "suma1 = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][eax][ret]

         call [ebx+3*4]  ; printf(format, eax, eax);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

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
