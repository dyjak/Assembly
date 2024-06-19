         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  UINT_MAX 4294967295

%define  INT_MIN -2147483648
%define  INT_MAX  2147483647

a        equ -1
b        equ 1
c        equ -2147483648
d        equ 1

;        exp = a*b + c*d = -1 - 2147483648 = -2147483649

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

;        mul arg  ; edx:eax = eax*arg

         imul ecx  ; edx:eax = eax*ecx
         
         mov esi, eax
         mov edi, edx

         mov eax, c  ; eax = c
         mov ecx, d  ; ecx = d

;        mul arg  ; edx:eax = eax*arg

         imul ecx  ; edx:eax = eax*ecx

         sub esp, 2*4  ; esp = esp - 8

;        esp -> [suma_l][suma_h][ret]

         cdq  ; edx:eax = eax ; signed conversion
         
         clc           ; CF = 0
         adc eax, esi  ; eax = eax + esi + CF
         adc edx, edi  ; edx = edx + edi + CF
         
         mov [esp], eax    ; *(int*)(esp) = eax
         mov [esp+4], edx   ; *(int*)(esp+4) = edx

         call getaddr  ; push on the stak the run-time address of format and jump to get address
format:
         db "wynik = %lld",0xA,0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf("wynik = %lld\n", eax, edx);
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