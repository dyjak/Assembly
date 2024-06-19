         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

bajt     equ 128  ; n = 0...255

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
 
digits   db "0123456789ABCDEF"

format   db "byte2hex = "
hex      db "00", 0xA, 0

getaddr:

;        esp -> [digits][ret]

         mov ebp, ebx  ; ebp = ebx
         
         mov ebx, [esp]  ; ebx = *(int*)esp = digits
         
         lea edi, [1 + ebx + hex - digits]  ; edi = 1 + ebx + hex - digits = 1 + digits + hex - digits = hex + 1

         mov al, bajt  ; al = bajt
         
         mov dl, al  ; dl = al
         
         and al, 00001111b  ; al = al & 00001111b

         xlat  ; al = *(char*)(ebx + al)  ; table lookup translation

         mov [edi], al  ; *(char*)edi = al
         
         dec edi  ; edi--
         
         mov al, dl  ; al = dl
         
         shr al, 4  ; al = al >> 4
         
         xlat  ; al = *(char*)(ebx + al)  ; table lookup translation
         
         mov [edi], al  ; *(char*)edi = al
         
         add dword [esp], format - digits  ; *(char*)esp = *(char*)esp + format - digits = digits + format - digits = format

;        esp -> [format][digits][ret]

         call [ebp+3*4]  ; printf(format);
         add esp, 1*4      ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebp+0*4]  ; exit(0);

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
