.text
.global main
main:
	# Push the stack record
	SUB sp, sp, #4
	STR lr, [sp]
	
	# Prompt the user for feet
	LDR r0, =prompt_feet
	BL printf
	LDR r0, =format
	LDR r1, =feet
	BL scanf
	
	# Prompt the user for inches
	LDR r0, =prompt_inch
	BL printf
	LDR r0, =format
	LDR r1, =inch
	BL scanf

	# Calculate total inches = num_feet * 12 + num_inch
	LDR r0, =feet
	LDR r0, [r0]
	MOV r1, #12
	# r0 = r0 * 12
	MUL r0, r0, r1
	LDR r1, =inch
	LDR r1, [r1]
	# r0 = r0 + r1
	ADD r0, r0, r1
	
	MOV r1, r0
	LDR r0, =output
	BL printf
	
	# Pop the stack record
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt_feet: .asciz "Enter feet: "
format: .asciz "%d"
feet: .word 0
prompt_inch: .asciz "Enter inches: "
inch: .word 0
output: .asciz "Total inches: %d\n"
