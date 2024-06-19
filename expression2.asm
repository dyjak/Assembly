         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  UINT_MAX 4294967295

%define  INT_MIN -2147483648
%define  INT_MAX  2147483647

a        equ 4
b        equ 5
c        equ 6

;        exp = a + b*c = 4 + 5*6 = 34

         mov eax, b  ; eax = b
         mov ecx, c  ; ecx = c

;        mul arg  ; edx:eax = eax*arg

         mul ecx  ; edx:eax = eax*ecx

         sub esp, 2*4  ; esp = esp - 8

;        esp -> [suma_l][suma_h][ret]

         clc  ; CF = 0
         
         mov ecx , a  ; ecx = a
         adc eax, ecx  ; eax = eax + ecx + CF

         mov [esp], eax  ; *(int*)(esp) = eax

         adc edx, 0  ; edx = edx + 0 + CF

         mov [esp+4], edx  ; *(int*)(esp+4) = edx

         call getaddr  ; push on the stak the run-time address of format and jump to get address
format:
         db "wynik = %llu",0xA,0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf("wynik = %llu\n", eax, edx);
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