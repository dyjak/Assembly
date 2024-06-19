        [bits 32]

        finit

a       equ 2
b       equ 3
c       equ 5

        push a
        fild dword [esp]
        push b
        fild dword [esp]
        push c
        fild dword [esp]
        ; st0 = c ; st1 = b; st2 = a
        fmulp ; st0 = b*c ; st1 = a
        faddp ; st0 = a+b*c

        add esp, 3*4
        sub esp, 1*4
        fistp dword [esp] ; esp -> [wynik][ret]

        call end
format:
        db "Wynik = %d", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 3*4

        push 0
        call [ebx+0*4]