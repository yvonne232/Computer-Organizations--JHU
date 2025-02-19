.text
.global main
main:
	SUB sp, sp, #4
	STR  lr, [sp]
	
	LDR r0, =prompt
	BL printf
	LDR r0, =formatString
	LDR r1, =Celsius
	BL scanf
	
	# F = (C * 9/5) + 32
	LDR r0, =Celsius
	LDR r0, [r0]
	MOV r1, #9
	# r0 = r0 * 9
	MUL r0, r0, r1
	MOV r1, #5
	# r0 = r0 / 5
	BL __aeabi_idiv
	MOV r1, #32
	# r0 = r0 + 32
	ADD r0, r0, r1

	MOV r1, r0
	LDR r0, =output
	BL printf
	
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
	prompt: .asciz "Enter temperature in Celsius: "
	formatString: .asciz "%d"
	Celsius: .word 0
	output: .asciz "Temperature in Fahrenheit: %d\n"
