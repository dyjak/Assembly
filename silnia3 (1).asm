        [bits 32]
        
n       equ 5

        push n
        ; esp -> [n][ret]
        mov eax, 1
petla:
        pop ecx
        cmp ecx, 1
        push ecx
        
        jl end

        mov edx, 0
        pop ecx
        mul ecx
        sub ecx, 2
        push ecx
        jmp petla

end:
        
        add esp, 1*4
        push eax
        push n
        
        call printf
format1:
        db "%d!! = %d", 0xA, 0
printf:
        call [ebx+3*4]
        add esp, 3*4

        push 0;
        call [ebx+0*4]