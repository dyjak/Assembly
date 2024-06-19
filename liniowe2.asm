        [bits 32]
        
;        FYL2X  st(1) := st(1)*log2[st(0)] i zdejmij

;        esp -> [ret]  ; ret - adres powrotu do asmloader

        call printA
formA:
        db "a = ", 0
printA:
        call [ebx+3*4]
        push esp ; esp -> [addr_a][a][ret]

        call getA
inA:
        db "%d", 0
getA:
        call [ebx+4*4]
        add esp, 2*4; esp -> [a][ret]

        call printB
formB:
        db "b = ", 0
printB:
        call [ebx+3*4]
        push esp ; esp -> [addr_b][b][a][ret]

        call getB
inB:
        db "%d", 0
getB:
        call [ebx+4*4]
        add esp, 2*4; esp -> [b][a][ret]

        pop eax
        neg eax
        push eax ; esp -> [-b][a][ret]

        pop eax; eax = -b
        pop ecx; ecx = a
        idiv ecx

        push eax

        call end
result:
        db "x = %d", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 3*4

        push 0
        call [ebx+0*4]

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