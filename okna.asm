         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

liczba   equ 24

         mov eax, liczba  ; eax = liczba
         mov edx, 0       ; edx = 0

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         cmp eax, 19     ; eax - 19 ; OF SF ZF AF PF CF affected
         jge poza        ; jump if greater or equal ; jump if SF == OF or ZF = 1

         cmp eax, 5     ; eax - 5 ; OF SF ZF AF PF CF affected
         jle poza       ; jump if less or equal ; jump if SF != OF or ZF = 1

         call getaddr1  ; push on the stack the runtime address of format and jump to getaddr
format1:
         db "%d nalezy do (5,19)", 0xA, 0
getaddr1:

;        esp -> [format1][eax][ret]

         call [ebx+3*4]  ; printf(format1, eax);
         add esp, 2*4    ; esp = esp + 8
         
;        esp -> [ret]         
         
         mov edx, 1  ; edx = 1

poza:

         mov eax, liczba  ; eax = liczba
         
         push eax  ; eax -> stack
         
;        esp -> [eax][ret]

         cmp eax, 24     ; eax - 24 ; OF SF ZF AF PF CF affected
         jge poza2  ; jump if greater or equal ; jump if SF == OF or ZF = 1

         cmp eax, 12     ; eax - 12 ; OF SF ZF AF PF CF affected
         jle poza2       ; jump if less or equal ; jump if SF != OF or ZF = 1
         
         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d nalezy do (12,24)", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf(format2, eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         jmp always  ; jump always

poza2:

         cmp edx, 0  ; eax - 0 ; OF SF ZF AF PF CF affected
         ja always   ; jump if above              ; jump if CF = 0 and ZF = 0

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "%d nie nalezy do (5,19) i (12,24)", 0xA, 0
getaddr3:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf(format2, eax);
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
