         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 4

         mov ecx, n  ; ecx = 14

         mov edi, 0  ; edi = 0 ; h_m
         mov esi, 1  ; esi = 1 ; l_m
         mov ebp, 0  ; ebp = 0 ; temp

         test ecx, ecx  ; ecx & ecx ; OF=0 SF ZF PF CF=0 affected

         je done  ; jump if equal   ; ZF = 1

petla    mov ebp, 0  ; ebp = 0
         mov edx, 0  ; edx = 0

         mov eax, esi  ; eax = esi
         mul ecx       ; edx:eax = eax*ecx
         mov esi, eax  ; esi = eax
         
         add ebp, edx  ; ebp = ebp + edx

         mov edx, 0    ; edx = 0
         mov eax, edi  ; eax = edi
         mul ecx       ; edx:eax = eax*ecx

         mov edi, eax  ; edi = eax
         add edi, ebp  ; edi = edi + ebp

         loop petla

done     push edi
         push esi

;        esp -> [esi][edi][ret]

         call getaddr  ; push on the stack the run-time addr of format and jump to get address
format:
         db "silnia = %llu", 0xA, 0
getaddr:

;        esp -> [format][esi][edi][ret]

         call [ebx+3*4]  ; pritnf(format, esi, edi)
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

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