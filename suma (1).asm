        [bits 32]
        
n       equ 10

        mov esi, 0
        mov eax, 0

petla:  
        inc esi
        add eax, esi

        cmp esi, n
        jne petla

        push eax
        push n
        call end
format:
        db "Suma(%d) = %d", 0xA, 0
end:
        call [ebx+3*4]
        add esp, 2*4

        push 0
        call [ebx+0*4]