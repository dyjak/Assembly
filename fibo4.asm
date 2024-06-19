        [bits 32]

;       esp -> [ret]  ; ret - adres powrotu do asmloader

%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b
|---|
1   1   2   3   5   8   13   wartosci
|   |---|
d   a   b

Przesuniecie ramki:

d = a              ; d = 1
a = b              ; a = 1
b = a + d = b + d  ; b = 1 + 1 = 2
%endif

n       equ 0

        mov ebp, ebx  ; ebp = ebx

        mov ecx, n ;  ecx = n
        
        mov eax, 1  ; eax = 1
        mov ebx, 1  ; ebx = 1

        test ecx, ecx  ; ecx - 0           ; OF SF ZF AF PF CF affected
        jae next    ; jump if above or equal ; jump if CF = 0 or ZF = 1

        jmp done

next    dec ecx  ; ecx--

shift   mov edx, eax  ; edx = eax
        mov eax, ebx  ; eax = edx
        add ebx, edx  ; ebx = ebx + edx

        loop shift
        
        push ebx  ; ebx -> stack

;       esp -> [ebx][ret]

done:

        call getaddr  ; push on the stack runtime address of format and jump to get address
format:
        db "fibo = %d", 0xA, 0
getaddr:

;       esp -> [format][ebx][ret]

        call [ebp+3*4]  ; printf(format, ebx)
        add esp, 2*4    ; esp = esp + 8

;       esp -> [ret]

        push 0          ; esp -> [0][ret]
        call [ebp+0*4]  ; exit(0)

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
