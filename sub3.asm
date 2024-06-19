         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 10
b        equ 5

         call getaddr_b
define_b:
         dd b  ; define double word
getaddr_b:

;        esp -> [define_b][ret]

         mov eax, a            ; eax = a
         mov ecx, [esp]        ; ecx = b
         sub eax, dword [ecx]  ; eax = eax - *(int*)ecx

         push eax

;        esp -> [eax][define_b][ret]

         call getaddr  ; push on the stack the run-time addr of format and jump to get address
format:
         db "roznica = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][define_b][ret]

         call [ebx+3*4]  ; pritnf("roznica = %d\n", a)
         add esp, 3*4    ; esp = esp + 12

;        esp -> [format]

         push 0          ; esp -> [00 00 00 00][ret]
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