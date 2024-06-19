%ifdef COMMENT
fibo(0) = 1
fibo(1) = 1
fibo(n) = fibo(n-1) + fibo(n-2)
%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 6

         mov ecx, n  ; ecx = n

         call fibo  ; eax = fibo(ecx) ; fastcall

addr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "fibo = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("silnia = %d\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax fibo(ecx)

fibo     cmp ecx, 0  ; ecx - 0           ; ZF affected
         jne next    ; jump if not equal ; jump if ZF = 0
         mov eax, 1  ; eax = 1
         ret

next     cmp ecx, 1    ; ecx - 1           ; ZF affected
         jne rec       ; jump if not equal ; jump if ZF = 0
         mov eax, ecx  ; eax = ecx = 1
         ret

rec      push ecx
         dec ecx       ; ecx = ecx - 1 = n-1
         call fibo     ; eax = fibo(ecx) = fibo(n-1)
         pop ecx
         push eax      ; eax -> stack = fibo(n-1)
         push ecx
         dec ecx       ; ecx = ecx - 1 = n-2
         call fibo     ; eax = fibo(ecx) = fibo(n-2)
         pop ecx
         pop edx       ; edx <- stack = fibo(n-1)
         add eax, edx  ; eax = eax + edx = fibo(n-2) + fibo(n-1)

         ret

;        fibo(0) = 1
;        fibo(1) = 1
;        fibo(n) = fibo(n-1) + fibo(n-2)

%ifdef COMMENT
eax = fibo(ecx)

* fibo(2) =           * fibo(2) = 2
  ecx = ecx - 1 = 1     ecx = ecx - 1 = 1
  eax = fibo(1) =       eax = fibo(0) = 1
  eax -> stack =        eax -> stack = 1
  ecx = ecx - 1 = 0     ecx = ecx - 1 = 0
  eax = fibo(0) =       eax = fibo(0) = 1
  edx <- stack =        edx <- stack = 1
  eax = eax + edx       eax = eax + edx = 1 + 1 = 2
  ecx = ecx + 2 = 2     ecx = ecx + 2 = 2
  return eax =          return eax = 2

* fibo(1) =           * fibo(1) = 1
  eax = ecx = 1         eax = 1
  return eax = 1        return eax = 1
  
* fibo(0) =           * fibo(0) = 1
  eax = 1               eax = 1
  return eax = 1        return eax = 1
%endif

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387
