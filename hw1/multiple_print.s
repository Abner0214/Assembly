.text
.align 2
.global main

@ Declare the printf function
.extern printf

.data
format_string:
    .ascii "Result: \"%s\"\n"  @ Define the format string

.data
result_string:
    .ascii "   Hello, World!"  @ Define a string with leading whitespace

main:
    @ Prologue
    stmfd sp!, {fp, lr}
    add fp, sp, #4

    @ Load the address of the format string into r0
    ldr r0, =format_string

    @ Load the address of the string into r1
    ldr r1, =result_string

    @ Call printf
    bl printf

    @ Epilogue
    sub sp, fp, #4
    ldmfd sp!, {fp, lr}
    bx lr
