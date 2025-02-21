.text
.global main
main:
	SUB sp, sp, #4
	STR lr, [sp]

	MOV r4, #5
	MOV r5, #8
	
	# Print before swap
	LDR r0, =before_swap1
	MOV r1, r4
	BL printf
	
	LDR r0, =before_swap2
	MOV r1, r5
	BL printf
	
	# r4 = r4 ^ r5
	EOR r4, r4, r5
	# r5 = (r4 ^ r5) ^ r5 = r4
	EOR r5, r4, r5
	# r4 = (r4 ^ r5) ^ r4 = r5
	EOR r4, r4, r5

	LDR r0, =after_swap1
	MOV r1, r4
	BL printf

	LDR r0, =after_swap2
	MOV r1, r5
	BL printf
	
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
before_swap1: .asciz "Num1 before swap: %d\n"
before_swap2: .asciz "Num2 before swap: %d\n"
after_swap1: .asciz "Num1 after swap: %d\n"
after_swap2: .asciz "Num2 after swap: %d\n"

