         [bits 32]

a        equ 18
b        equ 99
x        equ 0

;        esp -> [ret]

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         mov edx, x  ; edx = x

         push ecx
         push eax
         push edx

;        esp -> [edx][eax][ecx][ret]

         cmp edx, eax  ; cmp x, a
greater_a:

         je less_b      ; x = a
         jg less_b      ; x > a
         jmp not_equal  ; x < a
less_b:

         cmp edx, ecx  ; cmp x, b

         jg not_equal  ; x > b

         call getaddr1
format1:

         db "%d nalezy do [%d, %d]", 0xA, 0
getaddr1:

;        esp -> [format1][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format1, edx, eax, ecx);

         jmp exit

not_equal:

         call getaddr2
format2:

         db "%d nie nalezy do [%d, %d]", 0xA, 0
getaddr2:

;        esp -> [format2][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format2, edx, eax, ecx);
exit:

         add esp, 4*4    ; esp = esp + 16

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
