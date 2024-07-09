[bits 32]

a equ -2147483647
b equ 2
mov eax, dword a
mov ecx, dword b

imul ecx  ;edx:eax = eax*ecx

push edx
push eax


call getaddr
format:
       db "%lli.", 0xA, 0
getaddr:
        call [ebx+12] ;print
        add esp, 3*4  ;esp -> [ret]
        call [ebx]    ;exit