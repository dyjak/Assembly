         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

liczba   equ 25

         mov eax, liczba  ; eax = liczba
         
         push eax  ; eax -> stack
         
;        esp -> [eax][ret]

         cmp eax, 99     ; eax - 99 ; OF SF ZF AF PF CF affected
         jg poza  ; jump if greater or equal ; jump if SF == OF or ZF = 1

         cmp eax, 18     ; eax - 99 ; OF SF ZF AF PF CF affected
         jl poza         ; jump if less                 ; jump if SF != OF

         
         
         call getaddr1  ; push on the stack the runtime address of format and jump to getaddr
format1:
         db "%d nalezy do [18,99]", 0xA, 0
getaddr1:

;        esp -> [format1][eax][ret]

         call [ebx+3*4]  ; printf(format1, eax);
         add esp, 2*4    ; esp = esp + 8
         
         jmp always  ; jump always

poza:
         
         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d nie nalezy do [18,99]", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf(format, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

always:

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
