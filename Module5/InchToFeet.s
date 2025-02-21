.text
.global main
main:
	# Push the stack record
	SUB sp, sp, #4
	STR lr, [sp]

	# Prompt the user for inches
	LDR r0, =prompt
	BL printf
	LDR r0, =format
	LDR r1, =inch
	BL scanf
	
	# Calculate inches in feet
	# Load total inches to r4
	LDR r0, =inch
	LDR r4, [r0]
	MOV r0, r4
	MOV r1, #12
	# r0 = r0 / r1
	BL __aeabi_idiv
	# Store feet in r5
	MOV r5, r0 
	
	# r5: total feet; r1 : 12; r6 = r5 * 12
	MUL r6, r5, r1
	# r4: total inches; r6: total feet in inches; r7 = r4 - r6
	# Store remaining inches in r7
	SUB r7, r4, r6
	
	MOV r1, r5
	LDR r0, =output_feet
	BL printf
	
	MOV r1, r7
	LDR r0, =output_inch
	BL printf
	
	# Pop the stack record
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
	
.data
prompt: .asciz "Enter inches: "
format: .asciz "%d"
inch: .word 0
output_feet: .asciz "Total feet: %d\n"
output_inch: .asciz "Remaining inches: %d\n"



	
