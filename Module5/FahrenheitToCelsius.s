.text
.global main
main:
	SUB sp, sp, #4
	STR lr, [sp]

	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =Fahrenheit
	BL scanf
	
	# C = (F - 32) * 5/9
	LDR r0, =Fahrenheit
	LDR r0, [r0]
	# r0 = r0 - 32
	SUB r0, r0, #32
	MOV r1, #5
	# r0 = r0 * 5
	MUL r0, r0, r1
	MOV r1, #9
	# r0 = r0 / 9
	BL __aeabi_idiv

	MOV r1, r0
	LDR r0, =output
	BL printf
	
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt: .asciz "Enter temperature in Fahrenheit: "
	formatString: .asciz "%d"
	Fahrenheit: .word 0
	output: .asciz "Temperature in Celsius: %d\n"
	

