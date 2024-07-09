[bits 32]

;     a + b*b

a equ -13
b equ 2

mov esi, dword a    ;esi = a
mov eax, dword b    ;eax = b
mul eax             ;eax = b*b (eax = eax * eax)
add esi, eax        ;esi = a + b*b
;                                           esi i eax s¹ 4bajtowe
push esi
;                   esp->[esi][ret]

call getaddr
format:
       db "%d", 0xA, 0
getaddr:
        call [ebx+12]
        add esp, 4
        call [ebx]


