        [bits 32]
        
;        FYL2X  st(1) := st(1)*log2[st(0)] i zdejmij

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x       equ __?float32?__(100.0)
        finit

        push x
        ; esp -> [x][ret]
        fld dword [esp] ; st0 = x
        fld1 ; st0 = 1; st1 = x
        fyl2x ; st0 = log2(x)
        push 10 ; esp -> [10][x][ret]
        fild dword [esp] ; st0 = 10 ; st1 = log2(x)
        fld1 ; st0 = 1 ; st1 = 10 ; st2 = log2(x)
        fyl2x ; st0 = log2(10) ; st1 = log2(x)
        fdivp ; ; st0 = log2(x)/log2(10)
        add esp, 2*4 ; esp -> [10][x][ret]
        sub esp, 2*4 ; esp -> [][][ret]
        fstp qword [esp]

        call end
format:
        db "log2(x) = %f", 0xA, 0
end:
        call [ebx+3*4]

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