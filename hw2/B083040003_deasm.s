	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @align 4 byte
	.global	main
main:
	stmfd	sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,fp,lr}
	add	fp,sp,#4
	@-----------------------
	ldr	r0,=string1		@印出表格的標題
	bl	printf
	bl	start_deasm
	.include "test.s"

start_deasm:

	mov	r5,lr			@r5存第一個位址
	adr	r6,start_deasm		@r6存結束的位址
	mov	r7,r5			@r7存目前的指令的位址

Loop:

	cmp	r7,r6			@判斷指令是否結束
	bge	end

	sub	r1,r7,r5		
	ldr 	r4,[r7]			@取得現在的指令
	add 	r7,r7,#4		@取下個指令


	ldr	r0,=pcNumber
	bl	printf			@印出pc值

	mov	r9,r4
	and	r9,r9,#0x0c000000	@取出第26、27bit
	mov	r9,r9,lsr #26

	cmp	r9,#0
	beq	insDP			@為Data Processing的指令
	
	cmp	r9,#1
	beq	insMove			@為Data Movement的指令

	mov	r9,r4
	and	r9,r9,#0x0E000000	@取出第25-27bit
	mov	r9,r9,lsr #25
	cmp	r9,#5
	beq	insB			@為Branch的指令

	mov	r9,r4,lsr #28		@取出第28-31bit(condition部分)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	@一個condition 5byte	
	add	r0, r0, r10
	bl	printf			@印出condition

	ldr	r0,=noOP		@指令為UND
	bl	printf

	b	Loop

insB:
	mov	r9,r4,lsr #28		@取出第28-31bit(condition部分)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	@一個condition 5byte	
	add	r0, r0, r10
	bl	printf			@印出condition

	and 	r9,r4, #0x01000000	@取出第24個bit，判斷為B或BL
	mov	r10,r9,lsr #24
	
	cmp	r10,#1
	beq	L			@為BL

	ldr	r0,=opB			@為B
	rsb	r9,r10,r10,lsl #2
	add	r0,r0,r9
	bl	printf

	b 	Loop
L:
	mov	r9,r4,lsr #28		@取出第28-31bit(condition部分)
	@ldr	r0, =condition
	add	r10, r9, r9, lsl #2	@一個condition 5byte	
	add	r0, r0, r10
	@bl	printf			@印出condition

	and 	r9,r4, #0x01000000	@取出第24個bit，判斷為B或BL
	mov	r10,r9,lsr #24

	ldr	r0,=opB
	add	r9,r10,r10,lsl #1
	add	r9,r9,r10
	add	r0,r0,r9
	bl	printf
	
	b 	Loop

insDP:
	mov	r9,r4,lsr #28		@取出第28-31bit(condition部分)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	@一個condition 5byte	
	add	r0, r0, r10
	bl	printf			@印出condition

	and 	r10,r4, #0x01E00000	@取出第21-24bit
	mov	r9,r10,lsr #21
	ldr	r0,=opDP
	rsb	r10,r9,r9,lsl #2
	add	r0,r0,r10,lsl #1

	bl	printf
	
	b 	Loop

insMove:
	mov	r9,r4,lsr #28		@取出第28-31bit(condition部分)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	@一個condition 5byte	
	add	r0, r0, r10
	bl	printf			@印出condition

	and 	r10,r4, #0x00500000	@取出第20和22個bit
	mov	r9,r10,lsr #20
	
	cmp	r9,#0x00000004
	bge	byt			@為STRB或LDRB

	ldr	r0,=opMove		@為STR或LDR
	rsb	r10,r9,r9,lsl #2
	add	r0,r0,r10,lsl #1
	bl	printf
	
	b	Loop	

byt:					@STRB或LDRB
	ldr	r0,=opMoveB
	sub	r9,r9,#0x00000004
	rsb	r10,r9,r9,lsl #3
	add	r0,r0,r10
	bl	printf
	
	b	Loop

	@-----------------------
end:	sub sp,fp,#4
	ldmfd sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr
noOP:
	.asciz	"UND\n"
pcNumber:
	.asciz	"%d\t"
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
opB:
	.asciz	"B\t\n"
	.asciz	"BL\t\n"
opDP:
	.asciz	"AND\t\n"
	.asciz	"EOR\t\n"
	.asciz	"SUB\t\n"
	.asciz	"RSB\t\n"
	.asciz	"ADD\t\n"
	.asciz	"ADC\t\n"
	.asciz	"SBC\t\n"
	.asciz	"RSC\t\n"
	.asciz	"TST\t\n"
	.asciz	"TEQ\t\n"
	.asciz	"CMP\t\n"
	.asciz	"CMN\t\n"
	.asciz	"ORR\t\n"
	.asciz	"MOV\t\n"
	.asciz	"BIC\t\n"
	.asciz	"MVN\t\n"
opMove:
	.asciz	"STR\t\n"
	.asciz	"LDR\t\n"
opMoveB:
	.asciz	"STRB\t\n"
	.asciz	"LDRB\t\n"
string1:
	.asciz	"PC\tcondition\tinstruction\n" 
