	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @align 4 byte
	.global	main
main:
	@prologue
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	
	@--------------------------------------
	ldr r0,=title
	bl printf
	bl start_deasm
	.include "test.s"
start_deasm:
	mov r7,lr	@用r7計算開始點(目前lr)
	adr r8,start_deasm	@ending point
	mov r5,r7
instLoop:	
	cmp r5,r8
	bge End

	sub r1,r5,r7	@目前pc值
	ldr r4,[r5]	@第一個指令:r4
	add r5,r5,#4
	
	ldr r0,=pcVal
	bl printf
	
	mov r10,r4
	and r10,r10,#0x0c000000
	mov r10,r10,lsr #26
	cmp r10,#0
	
	beq keepRun
	
	cmp r10,#2
	beq branch

	mov r10,r4,lsr #28
	ldr r0,=condition
	add r10,r10,r10,lsl #2
	add r0,r0,r10
	bl printf
	ldr r0,=nextLine
	bl printf
	b instLoop
keepRun:
	mov r10,r4,lsr #28
	ldr r0,=condition
	add r10,r10,r10,lsl #2
	add r0,r0,r10
	bl printf
instruction:
	and r10,r4,#0x01E00000
	mov r9,r10,lsr #21	@r9存opcode
	ldr r0,=opcode
	rsb r10,r9,r9,lsl #2
	add r0,r0,r10,lsl #1
	bl printf
destinaiton:
	cmp r9,#8	@確認是否為cmp cmn tst teq
	cmpge r9,#12
	ble destination1
	and r1,r4,#0x0000F000	@rd的位置
	mov r1,r1,lsr #12
	ldr r0,=register
	bl printf
	b instLoop
destination1:
	and r1,r4,#0x000F0000
	mov r1,r1,lsr #16
	ldr r0,=register
	bl printf
	b instLoop
branch:
	mov r10,r4,lsr #28	@印branch condition
	ldr r0,=condition
	add r10,r10,r10,lsl #2
	add r0,r0,r10
	bl printf
	and r10,r4,#0x01000000
	mov r10,r10,lsr #24
	cmp r10,#1
	beq link
	ldrne r0,=branch1
	bl printf
	and r1,r4,#0x00FFFFFF
	ldr r0,=register
	bl printf
	b instLoop
link:
	ldr r0,=link1
	bl printf
	and r1,r4,#0x00FFFFFF
	ldr r0,=register
	bl printf
	b instLoop
	@--------------------------------------
End:	sub sp,fp,#4
	ldmfd sp!,{fp,lr}
	bx lr

title:
	.asciz "PC\tcondition\tinstruction\tdestination\n"
pcVal:
	.asciz "%d\t"
nextLine:
	.asciz "\n"
register:
	.asciz "r%d\n"
branch1:
	.asciz "B\t"
link1:
	.asciz "BL\t"
condition:
	.asciz "EQ\t\t"
	.asciz "NE\t\t"
	.asciz "CS\t\t"
	.asciz "CC\t\t"
	.asciz "MI\t\t"
	.asciz "PL\t\t"
	.asciz "VS\t\t"
	.asciz "VC\t\t"
	.asciz "HI\t\t"
	.asciz "LS\t\t"
	.asciz "GE\t\t"
	.asciz "LT\t\t"
	.asciz "GT\t\t"
	.asciz "LE\t\t"
	.asciz "AL\t\t"
	.asciz "NV\t\t"
opcode:
	.asciz "AND\t\t"
	.asciz "EOR\t\t"
	.asciz "SUB\t\t"
	.asciz "RSB\t\t"
	.asciz "ADD\t\t"
	.asciz "ADC\t\t"	
	.asciz "SBC\t\t"
	.asciz "RSC\t\t"
	.asciz "TST\t\t"
	.asciz "TEQ\t\t"
	.asciz "CMP\t\t"
	.asciz "CMN\t\t"
	.asciz "ORR\t\t"
	.asciz "MOV\t\t"
	.asciz "BIC\t\t"
	.asciz "MVN\t\t"

