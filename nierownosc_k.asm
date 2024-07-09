[bits 32]

;     a + b < c

a equ -5
b equ -3
c equ 1

mov esi, dword a
add esi, dword b    ;esi = a + b
mov edi, dword c    ;edi = c
push esi
;                esp->[esi][ret]
push edi
;                esp->[edi][esi][ret]




check:
     cmp dword esi, dword edi
     jl true                ;jump if below




call getaddr_false
;                esp->[format_false][edi][esi][ret]
format_false:
       db "Liczby nie spelniaja nierownosci.", 0xA, 0
getaddr_false:
        call [ebx+12] ;print
        add esp, 3*4  ;esp -> [ret]
        call [ebx]    ;exit

true:
     call getaddr_true
;                esp->[format_true][edi][esi][ret]
format_true:
       db "Liczby spelniaja nierownosc.", 0xA, 0
getaddr_true:
        call [ebx+12] ;print
        add esp, 3*4  ;esp -> [ret]
        call [ebx]    ;exit