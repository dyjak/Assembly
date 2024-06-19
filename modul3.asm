         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ;push on the stack the run-time address of format and jump to get address
format:
         db "a = ", 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("a = !\n");

;        esp -> [a][ret]

         push esp

;        esp -> [addr_a][a][ret]

         call getaddr2
format2:
         db "%d", 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf("%d", &a);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [a][ret]

         pop eax  ; eax = a

;        esp -> [ret]

         mov edx, eax  ; edx = eax = a

         test eax, eax  ; eax - 0               ; OF SF ZF AF PF CF affected
         jns nieujemna  ; jump if sign not ser  ; SF = 0

         neg edx  ; edx = -edx

nieujemna:

         push edx

;        esp -> [edx][ret]


         call getaddr3
format3:
         db "modul = %d", 0xA, 0
getaddr3:

;        esp -> [format][edx][ret]

         call [ebx+3*4]  ; printf(format, edx);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         push 0          ; esp ->[0][ret]
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
