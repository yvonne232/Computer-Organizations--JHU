.text
.global main
main:
	# Push the stack record
	SUB sp, sp, #4
	STR lr, [sp]
	
	LDR r0, =prompt1
	BL printf
	LDR r0, =format1
	LDR r1, =num
	BL scanf
	
	# Calculate 1's complement, and add 1
	LDR r0, =num
	LDR r0, [r0]
	# r0 = ~r0
	MVN r0, r0
	# r0 = r0 + 1
	ADD r0, r0, #1
	
	MOV r1, r0
	LDR r0, =output
	BL printf
	
	# Pop the stack record
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt1: .asciz "Enter an integer: "
num: .word 0
format1: .asciz "%d"
output: .asciz "The negative of the integer is: %d\n"


	
