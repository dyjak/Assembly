        [bits 32]

        finit; inicjalizacja FPU

        call printN
formN:
        db "n = ", 0
printN:
        call [ebx+3*4]
        push esp ; esp -> [addr_n][n][ret]

        call getN
inN:
        db "%d", 0
getN:
        call [ebx+4*4]
        add esp, 2*4; esp -> [n][ret]

        mov edi, 0 ; edi = 0 ; dlugosc 

petla:
        test esp, 0
        jnle done

        fild dword [esp]
        push 10
        fidiv dword [esp]
        add esp, 1*4 ; esp -> [n][ret]
        ; st0 = n/10
        fdivp ; st0 = n/10
        fstp dword [esp]
        inc esi
        jmp petla

done:
        call end
format:
        db "Dlugosc = %d", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 2*4

        push 0
        call [ebx+0*4]
