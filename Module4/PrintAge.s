.text
.global main
main:
	# Push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# Prompt the user for age
	LDR r0, =prompt1
	BL printf
	
	# Read the user's age
	LDR r0, =format1
	LDR r1, =age
	BL scanf

	# Print the age
	LDR r0, =output1
        LDR r1, =age 
        LDR r1, [r1, #0]
        BL printf
	
	# Print the user's age with tabs
	LDR r0, =output2
	LDR r1, =age
	LDR r1, [r1, #0]
	BL printf

	# Pop the stack record
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt1: .asciz "Enter your age:"
	format1: .asciz "%d"
	age: .word 0
	output1: .asciz "Your age is %d\n"
	output2: .asciz "Your age is:\t%d\tyears old\n"


