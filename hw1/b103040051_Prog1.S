@this is comment

@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp

@this is code section
@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main
main:

    @prologue
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4

    @code body

	mov r5, r0 @r5 = n_argv
	ldr r6, [r1, #4] @r6 = 取得該輸入字串的位址
	ldr	r0, =string_format @r0 is output format

loop:
	ldrb r1, [r6] @取得其字元ascii code
	@if (65<=r1<=90): r1 += 32, print(r1)
	@else if(97<=r1<=122): print(r1)
	@else continue
	cmp r1, #10
	BEQ loop_end
	cmp r1, #0
	BEQ loop_end

	cmp r1, #65
	BLT loop_next
	cmp r1, #90
	BLE lowercase

	cmp r1, #97
	BLT loop_next
	cmp r1, #122
	BLE printit

	B loop_next

lowercase:
	add r1, r1, #32
printit:
	stmfd sp!, {r0,r6}
	bl printf
	ldmfd sp!, {r0,r6}
loop_next:
	add r6, r6, #1
	B loop
	
loop_end:
	ldr	r0, =string_end
	stmfd sp!, {r0,r6}
	bl printf
	ldmfd sp!, {r0,r6}


	mov r0, #1
	bl fun

	mov	r0, #0
	
	@epilogue
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr

@another function
fun:
    add r0, r0, #1    
    bx lr
	
@data section

Label1:
    .word   0x77777777
    .short  0x1122
    .align 2
    .byte   0x31, 0x32, 0x33, 0x34

string_format:
	.ascii	"%c\0"
string_end:
	.ascii "\n\0"
string1:
	.asciz "Hello, arm-gcc\n"
    
    .end
    
    