	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @ align 4 byte
	.global	main

main:
	stmfd sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
	add fp, sp, #4   @ r1
	@-----------------------
	ldr r0, =headerRow
	bl printf
	bl start_deasm
	.include "test.s"

start_deasm:
	mov	r5, lr   @ r5 frist address
	adr	r6, start_deasm   @ r6 end address
	mov	r7, r5   @ r7 current address

Loop:
	cmp	r7, r6			
	bge	end   @ break

	sub	r1, r7, r5  @ get PC value
	ldr r4, [r7]   @ get current instruction
	add r7, r7, #4   @ get next one


	ldr r0, =pcNumber
	mov r8, r1   @ keep the current PC value
	bl printf   @ print PC value

	mov	r9, r4
	and	r9, r9, #0x0c000000   @ get 26-27 bit
	mov	r9, r9, lsr #26

	cmp	r9, #0   @ Data Processing instruction
	beq	insDP
	
	cmp	r9, #1   @ Data Movement instruction
	beq	insMove

	mov	r9, r4
	and	r9, r9, #0x0E000000	  @ get 25-27 bit
	mov	r9, r9, lsr #25
	cmp	r9, #5
	beq	insB  @ Branch instruction

	mov	r9, r4, lsr #28   @ get 28-31 bit (condition)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	  @ one condition uses 5 bytes
	add	r0, r0, r10
	bl printf   @ print condition

	ldr	r0, =noOP
	bl printf

	b Loop

insB:
	mov	r9, r4, lsr #28   @ get 28-31 bit (condition)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	  @ one condition uses 5 bytes
	add	r0, r0, r10
	bl printf   @ print condition

	and r9, r4, #0x01000000   @ get 24 it to determine it is "B" or "BL"
	mov	r10, r9, lsr #24
	
	cmp	r10, #1   @ BL
	beq	insBL

	ldr	r0, =opB   @ B
	bl printf

    and r1, r4, #0x00FFFFFF   @ get the Bits 23-0 (signed 24-bit offset)
    tst r1, #0x00800000   @ test the sign bit (bit 23)
    beq positive_offset_B
    orr r1, r1, #0xFF000000   @ Sign-extend for negative offset

positive_offset_B:   @ Calculate the target address (PC + 8 + Sign-extended Offset)
    add r2, r8, #8
    add r2, r2, r1, lsl #2	
    mov r1, r2

    ldr r0, =pcNumber
    bl printf
    ldr r0, =newLine
    bl printf

	b Loop

insBL:                  @ BL
	mov	r9, r4, lsr #28   @ get 28-31 bit (condition)
	@ ldr r0, =condition
	add	r10, r9, r9, lsl #2	  @ one condition uses 5 bytes
	add	r0, r0, r10
	@ bl printf   @ print condition

	and r9, r4, #0x01000000   @ get 24 it to determine it is "B" or "BL"
	mov	r10, r9, lsr #24

	ldr	r0, =opB
	add r0, r0, #3
	bl printf

    and r1, r4, #0x00FFFFFF   @ get the Bits 23-0 (signed 24-bit offset)
    tst r1, #0x00800000   @ test the sign bit (bit 23)
    beq positive_offset_BL
    orr r1, r1, #0xFF000000   @ Sign-extend for negative offset

positive_offset_BL:   @ Calculate the target address (PC + 8 + Sign-extended Offset)
    add r2, r8, #8
    add r2, r2, r1, lsl #2
    mov r1, r2

    ldr r0, =pcNumber
    bl printf
    ldr r0, =newLine
    bl printf

	b Loop

insDP:
	mov	r9, r4, lsr #28   @ get 28-31 bit (condition)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	  @ one condition uses 5 bytes	
	add	r0, r0, r10
	bl printf   @ print condition

	and r10, r4, #0x01E00000  @ get 21-24 bit
	mov	r9, r10, lsr #21
	ldr	r0, =opDP
	rsb	r10, r9, r9, lsl #2
	add	r0, r0, r10, lsl #1

	bl printf
	
	b Loop

insMove:
	mov	r9, r4, lsr #28   @ get 28-31 bit (condition)
	ldr	r0, =condition
	add	r10, r9, r9, lsl #2	  @ one condition uses 5 bytes
	add	r0, r0, r10
	bl printf   @ print condition

	and r10, r4, #0x00500000   @ get 20, 22 bit
	mov	r9, r10, lsr #20
	
	cmp	r9, #0x00000004
	bge	moveB   @ STRB or LDRB

	ldr	r0, =opMove   @ STR or LDR
	rsb	r10, r9, r9, lsl #2
	add	r0, r0, r10, lsl #1
	bl printf
	
	b Loop

moveB:                    @ STRB or LDRB
	ldr	r0, =opMoveB
	sub	r9, r9, #0x00000004
	rsb	r10, r9, r9, lsl #3
	add	r0, r0, r10
	bl printf
	
	b Loop
    @-----------------------

end:	
    sub sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
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
	.asciz	"B\t"
	.asciz	"BL\t"
newLine:
    .asciz  "\n"
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
headerRow:
	.asciz	"PC\tcondition\tinstruction\n"
