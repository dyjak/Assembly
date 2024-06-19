         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 3
b        equ 5
         
         mov esi, a  ; esi = a;
         mov edi, b  ; edi = b;
         
         push edi
         push esi

;        esp -> [esi][edi][ret]

         call getaddr
format:
         db "(esi, edi) = (%d, %d)", 0xA, 0
getaddr:

;        esp -> [format][esi][edi][ret]

         call [ebx+3*4]  ; printf("(esi, edi) = (%d, %d)\n");
         add esp, 3*4      ; esp = esp + 12

;        esp -> [ret]

         mov esi, a  ; esi = a;
         mov edi, b  ; edi = b;
         
         xchg esi, edi  ; (esi, edi) = (edi, esi)

         push edi
         push esi

;        esp -> [esi][edi][ret]

         call getaddr2
format2:
         db "(esi, edi) = (%d, %d)", 0xA, 0
getaddr2:

;        esp -> [format2][esi][edi][ret]
         
         call [ebx+3*4]  ; printf("(esi, edi) = (%d, %d)", esi, edi);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         push 0          ; esp ->[0][ret]
         call [ebx+0*4]  ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; edi zawiera pointer na tablice API
;
; call [edi + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwr�ci jest w esi.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

edi    -> [ ][ ][ ][ ] -> exit
edi+4  -> [ ][ ][ ][ ] -> putchar
edi+8  -> [ ][ ][ ][ ] -> getchar
edi+12 -> [ ][ ][ ][ ] -> printf
edi+16 -> [ ][ ][ ][ ] -> scanf

%endif
