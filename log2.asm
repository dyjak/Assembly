        [bits 32]
        
;        FYL2X  st(1) := st(1)*log2[st(0)] i zdejmij

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x       equ __?float32?__(256.0)

        finit

        push x

        fld1
        fld dword [esp]
        add esp, 1*4

        fyl2x

        sub esp, 2*4
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