.text
.global main
	# Main
	# Purpose: call findMaxOf3(int val1, int val2, int val3) function and find the largest one

	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Prompt for and read 3 values
	LDR r0, =prompt1
	BL printf
	LDR r0, =format
	LDR r1, =val1
	BL scanf

	LDR r0, =prompt2
	BL printf
	LDR r0, =format
	LDR r1, =val2
	BL scanf

	LDR r0, =prompt3
	BL printf
	LDR r0, =format
	LDR r1, =val3
	BL scanf

	# Load r0, r1, r2 into function
	LDR r0, =val1
	LDR r0, [r0]
	LDR r1, =val2
	LDR r1, [r1]
	LDR r2, =val2
	LDR r2, [r2]

	BL findMaxOf3

	# Print maximum number
	MOV r1, r0
	LDR r0, =output
	BL printf
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt1: .asciz "Enter first value: "
prompt2: .asciz "Enter second value: "
prompt3: .asciz "Enter third value"
format: .asciz "%d"
output: .asciz "Maximum value is %d. \n"
val1: .word 0
val2: .word 0
val3: .word 0

# End Main

.text
findMaxOf3:
	# Function: findMaxOf3
	# Purpose: find maximum value of the 3 inputs
	# Input: r0 - val1, r1 - val2, r2 - val3
	# Output: r0 - maximum of the 3

	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Compare r0 with r1. If r1 > r0, then move r1 to r0
	CMP r0, r1
	MOVLT r0, r1

	# Compare new r0 with r2. If r2 > r0, then move r2 to r0
	CMP r0, r2
	MOVLT r0, r2

	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

	
	
