[bits 32]

mov ecx, 5

loop1:
     push ecx
     dec ecx
     test ecx, 0
     ja loop1

mov ecx, 5
loop2:
     call getaddr

format:
       db "to: %d", 0xA, 0
getaddr:
        call [ebx+12]
        ;add esp, 4
        dec ecx
        test ecx, 0
        ja loop2




format2:
        db 0xA, 0
getaddr2:
        call [ebx+12]
        add esp, 4
        call [ebx+0]