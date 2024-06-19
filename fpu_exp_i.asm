         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ 5
c        equ 6

;        a + b*c = 4 + 5*6 = 34

         sub esp, 4  ; esp = esp - 4 ; make room for int type result

;        esp -> [ ][ret]

         call getaddr  ; get the runtime address of format

format   db "wynik = %d", 0xA, 0
length   equ $ - format

addr_a   dd a  ; define double word
addr_b   dd b
addr_c   dd c

getaddr:

;        esp -> [format][ ][ret]

         finit  ; fpu init

;        st = []

         mov eax, [esp]         ; eax = *(int*)esp = format
         lea eax, [eax+length]  ; eax = eax + length = format + length = addr_a

         fild dword [eax]    ; *(int*)eax = *(int*)addr_a = a -> st     ; fpu load integer
         fild dword [eax+4]  ; *(int*)(eax+4) = *(int*)addr_b = b -> st ; fpu load integer
         fild dword [eax+8]  ; *(int*)(eax+8) = *(int*)addr_c = c -> st ; fpu load integer

;        st = [st0, st1, st2] = [c, b, a]  ; fpu stack

;        faddp stn ; stn = stn + st0 i zdejmij
;        fmulp stn ; stn = stn * st0 i zdejmij

         fmulp st1  ; [st0, st1, st2] => [st0, st1*st0, st2] => [st1*st0, st2] = [b*c, a]

;        st = [st0, st1] = [b*c, a]  ; fpu stack

         faddp st1  ; [st0, st1] => [st0, st1+st0] => [st1+st0] = [a + b*c]
         
;        st = [st0] = [a + b*c]  ; fpu stack

;                       +4
;        esp -> [format][ ][ret]

         fistp dword [esp+4]  ; *(int*)(esp+4) <- st = [a + b*c]  ; fpu store integer and pop

;        st = []  ; fpu stack

         call [ebx+3*4]  ; printf("wynik = %f\n", *(int*)(esp+4));
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0         ; esp -> [0][ret]
         call [ebx+0*4] ; exit(0);

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