        [bits 32]

        finit

a       equ __?float32?__(2.5)
b       equ __?float32?__(3.0)
c       equ __?float32?__(1.5)

        push a
        fld dword [esp]
        push b
        fld dword [esp]
        push c
        fld dword [esp]
        ; st0 = c ; st1 = b; st2 = a
        fmulp ; st0 = b*c ; st1 = a
        faddp ; st0 = a+b*c

        add esp, 3*4
        sub esp, 2*4
        fstp qword [esp] ; esp -> [wynik_l][wynik_h][ret]

        call end
format:
        db "Wynik = %f", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 3*4

        push 0
        call [ebx+0*4]