.text
.global main
main:	
	SUB sp, sp, #4
	STR lr, [sp]
	
	LDR r0, =prompt
	BL printf
	LDR r0, =format
	LDR r1, =num
	BL scanf
	
	LDR r0, =num
	LDR r0, [r0]
	# a * 10 = a * 8 + a * 2
	LSL r2, r0, #3
	LSL r3, r0, #1
	ADD r0, r3, r2
	
	MOV r1, r0
	LDR r0, =output
	BL printf
	
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
prompt: .asciz  "Enter a number: "
format:	.asciz "%d"
num: .word 0
output: .asciz "Multiply by 10 is: %d \n"
