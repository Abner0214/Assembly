; Using "https://onecompiler.com/assembly" to run the code

section .data
  prompt db "Enter intA intB op: ", 0
  space db ' ', 0
  format_max: db "Function 1: maximum of", 0
  format_max_len: equ $-format_max
  format_gcd: db "Function 2: greatest common divisor of", 0
  format_gcd_len: equ $-format_gcd
  format_lcm: db "Function 3: least common multiply of", 0
  format_lcm_len: equ $-format_lcm
  format_and: db "and", 0
  format_and_len: equ $-format_and
  format_is: db "is", 0
  format_is_len: equ $-format_is
  format_period: db ".", 10, 0
  format_period_len: equ $-format_period

section .bss
  input resb 50
  output resb 50
  num1 resd 1
  num2 resd 1
  num3 resd 1
  result resd 1 

section .text
  global _start

_start:
  ; ; Print the prompt to the user
  ; mov eax, 4          ; sys_write
  ; mov ebx, 1          ; file descriptor 1 is stdout
  ; mov ecx, prompt     ; message to write
  ; mov edx, 22         ; length of the prompt
  ; int 80h             ; call kernel

  ; Read numbers from the user
  mov eax, 3          ; sys_read
  mov ebx, 0          ; file descriptor 0 is stdin
  mov ecx, input      ; buffer to store input
  mov edx, 50         ; number of bytes to read
  int 80h             ; call kernel

  ; Convert string to integers
  mov esi, input
  call StringToInt
  mov [num1], eax
  call StringToInt
  mov [num2], eax
  call StringToInt
  mov [num3], eax
  
  ; ; Print num1
  ; mov eax, [num1]
  ; call IntToString
  ; call PrintString

  ; ; Print num2
  ; mov eax, [num2]
  ; call IntToString
  ; call PrintString

  ; ; Print num3
  ; mov eax, [num3]
  ; call IntToString
  ; call PrintString  
	
  mov eax, [num1]
  mov ebx, [num2]
  mov ecx, [num3]

  cmp ecx, 1
  je max
  cmp ecx, 2
  je gcd
  cmp ecx, 3
  je lcm
  
          ;;;;; exit ;;;;;
Exit:
  ; Exit the program
  mov eax, 1          ; sys_exit
  xor ebx, ebx        ; exit code 0
  int 80h             ; call kernel

;;;;;;;;; maximum ;;;;;;;;; 
max:
  cmp eax, ebx
  jg .eaxGreater
  mov eax, ebx   ; If ebx is greater, move it to eax
.eaxGreater:
  mov [result], eax

  ; Print formatted message for maximum
  mov eax, 4            ; sys_write
  mov ebx, 1            ; file descriptor 1 is stdout
  mov ecx, format_max   ; message to write
  mov edx, format_max_len
  int 80h               ; call kernel

  ; Print first number (intA)
  mov eax, [num1]
  call IntToString
  call PrintString

  ; Print "and"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_and
  mov edx, format_and_len
  int 80h

  ; Print second number (intB)
  mov eax, [num2]
  call IntToString
  call PrintString

  ; Print "is"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_is
  mov edx, format_is_len
  int 80h

  ; Print maximum result
  mov eax, [result]
  call IntToString
  call PrintString

  ; Print period and '\n'
  mov eax, 4
  mov ebx, 1
  mov ecx, format_period
  mov edx, format_period_len
  int 80h

  jmp Exit


;;;;;;;;; GCD ;;;;;;;;; 
gcd:
  cmp ebx, 0
  je endGCD

  mov ecx, ebx

  mov edx, 0
  idiv ebx
  mov ebx, edx

  mov eax, ecx

  jmp gcd

endGCD:

  mov [result], eax
  ; Print 
  mov eax, 4
	mov ebx, 1
	mov ecx, format_gcd
	mov edx, format_gcd_len
	int 80h

  mov eax, [result]
  
  ; call IntToString
  ; call PrintString 
  
  ; Print first number (intA)
  mov eax, [num1]
  call IntToString
  call PrintString

  ; Print "and"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_and
  mov edx, format_and_len
  int 80h

  ; Print second number (intB)
  mov eax, [num2]
  call IntToString
  call PrintString

  ; Print "is"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_is
  mov edx, format_is_len
  int 80h

  ; Print maximum result
  mov eax, [result]
  call IntToString
  call PrintString

  ; Print period and '\n'
  mov eax, 4
  mov ebx, 1
  mov ecx, format_period
  mov edx, format_period_len
  int 80h
  
  jmp Exit

;;;;;;;;; LCM ;;;;;;;;;
lcm:
  mov esi, eax
  mov edi, ebx


gcd1:
  cmp ebx, 0
  je endGCD1

  mov ecx, ebx

  mov edx, 0
  idiv ebx
  mov ebx, edx

  mov eax, ecx

  jmp gcd1

endGCD1:  

  mov ecx, eax
  mov eax, esi
  div ecx
  imul edi
  
  mov [result], eax
  ; Print
  mov eax, 4
	mov ebx, 1
	mov ecx, format_lcm
	mov edx, format_lcm_len
	int 80h
  
  mov eax, [result]

  ; call IntToString
  ; call PrintString
  
  ; Print first number (intA)
  mov eax, [num1]
  call IntToString
  call PrintString

  ; Print "and"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_and
  mov edx, format_and_len
  int 80h

  ; Print second number (intB)
  mov eax, [num2]
  call IntToString
  call PrintString

  ; Print "is"
  mov eax, 4
  mov ebx, 1
  mov ecx, format_is
  mov edx, format_is_len
  int 80h

  ; Print maximum result
  mov eax, [result]
  call IntToString
  call PrintString

  ; Print period and '\n'
  mov eax, 4
  mov ebx, 1
  mov ecx, format_period
  mov edx, format_period_len
  int 80h
  
  jmp Exit


; String to integer
StringToInt:
  xor eax, eax
.next_digit:
  movzx edx, byte [esi] ; Move next byte into DL and zero-extend to 32-bits
  cmp dl, '0'        ; Check if character is below '0'
  jb .not_digit      
  cmp dl, '9'        ; Check if character is above '9'
  ja .not_digit      
  sub dl, '0'        ; ACII code to integer
  imul eax, eax, 10  ; Multiply current number by 10 (shift left one decimal place)
  add eax, edx       ; Add new digit to current number
  inc esi            ; Move to next character
  jmp .next_digit    
.not_digit:
  cmp byte [esi], ' ' ; if the current char is a ' '
  je .skip_space      ; 
  ret                 ; Return if it's end of string (null-terminator)
.skip_space:
  inc esi            ; Skip the space character (' ')
  ret             

; Integer to String
IntToString:
  mov edi, output + 49    ; Point EDI to the end of the output buffer, prepare for reverse filling
  mov ebx, 10             ; Set base 10 for division
.reverse:
  xor edx, edx            ; Clear EDX prior to dividing EDX:EAX by EBX
  div ebx                 ; Divide EAX by 10, result in EAX, remainder in EDX
  add dl, '0'             ; Convert the remainder to an ASCII character
  dec edi                 
  mov [edi], dl           
  test eax, eax           ; Check if the quotient was 0
  jnz .reverse            ; If not, we have more digits to process

  ; Calculate the length of the number and write it to stdout
  mov eax, 4              ; sys_write
  mov ebx, 1              ; file descriptor 1 is stdout
  mov ecx, edi            ; message to write (converted number)
  lea edx, [output + 50]  ; Load the end address of the buffer
  sub edx, edi            ; Calculate the length: end address - current address
  int 80h                 ; call kernel

  ; ; Write a space after the number (except after the last one)
  ; mov eax, 4              ; sys_write
  ; mov ebx, 1              ; file descriptor 1 is stdout
  ; mov ecx, space          ; message to write (space character)
  ; mov edx, 1              ; message length (one space)
  ; int 80h                 ; call kernel

  ret                     ; Return from function

; Print string  
PrintString:
  ; Assumes EDI points to the start of the string and the string is null-terminated
  mov eax, 4          ; sys_write
  mov ebx, 1          ; file descriptor 1 is stdout
  mov ecx, edi        ; pointer to string to write
  lea edx, [output + 16]  ; End of the buffer
  sub edx, edi        ; Calculate the length of the string
  int 80h             ; call kernel

  ; ; Print a space character for readability
  ; mov eax, 4          ; sys_write
  ; mov ebx, 1          ; file descriptor 1 is stdout
  ; mov ecx, space      ; pointer to space character
  ; mov edx, 1          ; length of space
  ; int 80h             ; call kernel

  ret                 ; Return from function
