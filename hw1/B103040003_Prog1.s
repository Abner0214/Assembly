format_string:
    .ascii "%s result: %s"  @ output format

.text
.align 2  @ 2^2
.global main

main:
    @ prologue
    stmfd sp!, {fp, lr}
    add fp, sp, #4
    @ --------------------------------------
    ldr r2, [r1, #4]  @ load input string (argv[0+1])
    ldr r6, [r1]
    mov r3, r2
    sub r5, r5, r5

Loop:
    ldrb r4, [r2], #1  @ read each byte

    cmp r4, #0  @ byte read is null-terminator
    beq End
    cmp r4, #' '
    beq Loop
    cmp r4, #'0'
    blge Number
    cmp r4, #'A'
    blge Alpha
    cmp r4, #'a'
    bllt Loop
    cmp r4, #'z'
    blgt Loop

    strb r4, [r3, r5]  @ store one byte
    add r5, r5, #1
    bl Loop

End:

	ldr r0, =format_string
    mov r1, r6

    strb r4, [r3, r5]
    mov r2, r3
    bl printf
    @ epilogue
    sub sp, fp, #4
    ldmfd sp!, {fp, lr}
    bx lr
    @ --------------------------------------

Number:
    cmp r4, #'9'
    blle Loop

Alpha:
    cmp r4, #'Z'
    addle r4, r4, #0x20  @ convert uppercase to lowercase
    bx lr
