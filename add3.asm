         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ -5

         mov eax, a  ; eax = a

          call getaddr
addr_b:
         dd b  ; define double word
getaddr:

;        esp -> [addr_b][ret]

         mov ecx, [esp]  ; ecx = *(int*)esp = addr_b

         push dword [ecx]  ; *(int*)ecx = *(int*)addr_b = b -> stack
         
;        esp -> [b][addr_b][ret]

         pop ecx  ;ecx <- stack
         
;        esp -> [addr_b][ret]

         add eax, ecx  ; eax = eax + ecx

         push eax  ; eax -> stack
         
;        esp -> [eax][addr_b][ret]

         call getaddr2  ; push on the stack runtime address of format and jump to get address
format2:
         db "a = %d", 0xA, 0
getaddr2:

;        esp -> [format][eax][addr_b][ret]

         call [ebx+3*4]  ; printf(format, eax);
         add esp, 2*4    ; esp = esp + 8

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
