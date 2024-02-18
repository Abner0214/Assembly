	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @align 4 byte
	.global	main
main:
	stmfd	sp!,{fp,lr}
	add	fp,sp,#4
	@-----------------------
	ldr 	r0, =title		@印出表格一開始	
	bl	printf
	bl	start_deasm
	.include "test.s"
start_deasm:
	mov 	r7,lr			@r7:start
	adr 	r8,start_deasm		
	mov 	r5,r7			@r5:用來計數
loop:
	cmp 	r5,r8			@是否結尾
	bge 	end
	
	sub 	r1,r5,r7		@取include檔案的第一個指令為pc=0
	ldr 	r4,[r5]
	add 	r5,r5,#4			@next instruction

	ldr 	r0,=pcc
	bl 	printf
	
	mov	r10,r4
	and	r10,r10,#0x0c000000 	@bit 27-26
	mov	r10, r10, lsr #26
	cmp	r10, #0

	beq	run			@不印xxx
	
	mov	r10,r4,lsr #28		@bit 31-28
	ldr	r0, =condition
	add	r10, r10, r10, lsl #2	@condition大小為5byte	
	add	r0, r0, r10
	bl	printf
	ldr	r0, =nodpi		
	bl	printf
	b	loop			@下一指令
run:
	mov	r10,r4,lsr #28		@bit 31-28
	ldr	r0, =condition
	add	r10, r10, r10, lsl #2	@condition大小為5byte	
	add	r0, r0, r10
	bl	printf
inst:
	and 	r10,r4, #0x01E00000	@bit 24-21
	mov	r9,r10,lsr #21
	ldr	r0,=opcode
	rsb	r10,r9,r9,lsl #2
	add	r0,r0,r10,lsl #1
	bl	printf
des:
	cmp	r9, #8			@bit 11-8印NA CMN CMP TEQ TST
	rsbges	r0, r9, #11		
	ldrge	r0, =no	
	andlt	r1, r4, #0x00000F000	@bit 15-12
	movlt	r1, r1, lsr #12	
	ldrlt	r0, =destination_register
	bl	printf
op1:	
	@印出op1
	and	r0, r9, #0x0000000D	@MOV MVN不用印 1101 1111
	cmp	r0, #0x0000000D
	ldreq	r0, =no
	andne	r1, r4, #0x000F0000	@19~16
	movne	r1, r1, lsr #16	
	ldrne	r0, =first_register
	bl	printf
op2:	
	@op2
	and	r9, r4,#0x2000000	@bit 25來決定op2是否為register
	cmp	r9, #0
	ldreq	r0, =second_register
	andeq	r1, r4, #0x0000000F	@bit 3-0
	ldrgt	r0, =immediate
	andgt	r10, r4, #0x00000F00	@bit 11-8
	lsrgt	r10, r10, #7		
	andgt	r1, r4, #0x000000FF	@bit 7-0	
	rorgt	r1, r1, r10		@立即值為 ror v 2n
	bl	printf
	
	b 	loop

	@-----------------------
end:	sub sp,fp,#4
	ldmfd sp!,{fp,lr}
	bx lr
title:
	.asciz	"PC\tcondition\tinstruction\tdstreg\t\toperand1\toperand2\n" 
nodpi:
	.asciz	"xxx\n"
pcc:
	.asciz	"%d\t"
no:
	.asciz	"NA\t\t"
immediate:
	.asciz	"#%u\n"	
destination_register:
	.asciz	"r%d\t\t"
first_register:
	.asciz	"r%d\t\t"	

second_register:
	.asciz	"r%d\n"	
condition:
	.asciz	"EQ\t\t"
	.asciz	"NE\t\t"
	.asciz	"CS\t\t"
	.asciz	"CC\t\t"
	.asciz	"MI\t\t"
	.asciz	"PL\t\t"
	.asciz	"VS\t\t"
	.asciz	"VC\t\t"
	.asciz	"HI\t\t"
	.asciz	"LS\t\t"
	.asciz	"GE\t\t"
	.asciz	"LT\t\t"
	.asciz	"GT\t\t"
	.asciz	"LE\t\t"
	.asciz	"AL\t\t"
	.asciz	"NV\t\t"
opcode:
	.asciz	"AND\t\t"
	.asciz	"EOR\t\t"
	.asciz	"SUB\t\t"
	.asciz	"RSB\t\t"
	.asciz	"ADD\t\t"
	.asciz	"ADC\t\t"
	.asciz	"SBC\t\t"
	.asciz	"RSC\t\t"
	.asciz	"TST\t\t"
	.asciz	"TEQ\t\t"
	.asciz	"CMP\t\t"
	.asciz	"CMN\t\t"
	.asciz	"ORR\t\t"
	.asciz	"MOV\t\t"
	.asciz	"MVN\t\t"
