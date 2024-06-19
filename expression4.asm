         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 1
b        equ 2
c        equ 3
d        equ 4

;        exp = a*b + c*d = 2 + 12 = 14

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

;        mul arg  ; edx:eax = eax*arg

         mul ecx  ; edx:eax = eax*ecx

         mov esi, eax  ; esi = eax

         mov eax, c  ; eax = c
         mov ecx, d  ; ecx = d
         
;        mul arg  ; edx:eax = eax*arg

         mul ecx  ; edx:eax = eax*ecx

         mov edi, eax  ; edi = eax

         add esi, edi  ; esi = esi + edi

         push esi

;        esp -> [esi][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "wynik = %u", 0xA, 0
getaddr:

;        esp -> [format][esi][ret]

         call [ebx+3*4]  ; printf("wynik = %u\n", esi);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret] <- to jest na 4 bajtach
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
; To co funkcja zwróci jest w EAX.
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
