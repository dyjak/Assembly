         [bits 32]

a        equ 5
b        equ 19
c        equ 12
d        equ 24
x        equ 3

;        esp -> [ret]

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         mov esi, c  ; esi = c
         mov edi, d  ; edi = d
         mov edx, x  ; edx = x

         push edi
         push esi
         push ecx
         push eax
         push edx

;        esp -> [edx][eax][ecx][esi][edi][ret]

greater_a:
         cmp edx, eax  ; cmp x, a

         jg less_b      ; x > a
         je not_equal   ; x = a
         jmp not_equal  ; x < a
less_b:

         cmp edx, ecx  ; cmp x, b

         jg not_equal  ; x > b
         je not_equal  ; x = b
greater_c:

         cmp edx, esi  ; cmp x, c

         jg less_d      ; x > c
         je not_equal   ; x = c
         jmp not_equal  ; x < c
less_d:

         cmp edx, edi  ; cmp x, d

         jg not_equal  ; x > d
         je not_equal  ; x = d

         call getaddr1
format1:

         db "%d nalezy do (%d, %d) i (%d, %d)", 0xA, 0
getaddr1:

;        esp -> [format1][edx][eax][ecx][esi][edi][ret]

         call [ebx+3*4]  ; printf(format, edx, eax, ecx, esi, edi);

         jmp exit

not_equal:

         call getaddr2
format2:

         db "%d nie nalezy do (%d, %d) i (%d, %d)", 0xA, 0
getaddr2:

;        esp -> [format2][edx][eax][ecx][esi][edi][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
exit:
         add esp, 6*4    ; esp = esp + 24

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
