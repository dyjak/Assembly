[bits 32]

n equ 3  ;iloczyn = 2 * 4 * 6 = 48

mov ecx, dword n
mov eax, 1


call iloczyn

addr:
  push eax
  call getaddr
format:
         db "wynik = %d", 0xA, 0
getaddr:
          call [ebx+12]
          add esp, 4
          push 0
          call [ebx]



iloczyn:
          cmp ecx, 0
          jne rec
          ret

rec:
          mov esi, ecx         ;esi = ecx
          add esi, esi         ;esi*=2
          mul esi              ;eax*=esi
          dec ecx
          jmp iloczyn