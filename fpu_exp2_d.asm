        [bits 32]

        finit; inicjalizacja FPU

a       equ __?float32?__(2.5)
b       equ __?float32?__(3.5)
c       equ __?float32?__(1.5)
d       equ __?float32?__(0.5)

        ; esp  -> [ret] 
        push a
        push b
        ; esp  -> [b][a][ret] 
        fld dword [esp]
        fld dword [esp+1*4]
        add esp, 2*4
        ; esp  -> [ret] 
        ; st0 = b ; st1 = a
        fmulp 
        ; st0 = a*b

        push c
        push d
        ; esp  -> [d][c][ret]
        fld dword [esp]
        fld dword [esp+1*4]
        add esp, 2*4
        ; esp  -> [ret]
        ; st0 = d ; st1 = c ; st2 = a*b
        fmulp
        ; st0 = c*d ; st1 = a*b
        faddp
        ; st0 = a*b+c*d
        fstp qword [esp]
        ; esp -> [wynik_l][wynik_h][ret]

        call end
format1:
        db "Wynik = %f", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 1*8
        ; esp -> [ret]
        push 0
        call [ebx+0*4]
        