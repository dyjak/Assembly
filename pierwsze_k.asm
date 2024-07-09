[bits 32]

a equ 4

mov edi, dword a
mov ecx, dword a
dec ecx

looop:
      mov eax, edi
      mov edx, 0
      div ecx  ;eax=div edx=reszta

      cmp edx, 0
      je addr_1

      dec ecx
      cmp ecx, 1
      jne looop




addr_2:
       call getaddr_2
format2:
       db "Tak", 0xA, 0
getaddr_2:
          call [ebx+12]
          add esp, 4
          push 0
          call [ebx]




addr_1:
       call getaddr_1
format:
       db "Nie", 0xA, 0
getaddr_1:
          call [ebx+12]
          add esp, 4
          push 0
          call [ebx]
          
          
