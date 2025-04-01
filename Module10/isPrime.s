.text
.global main
main:

	SUB sp, sp, #4
	STR lr, [sp, #0]

	# Initialize the loop, prompt the user for the input
	LDR r0, =promptMsg
	BL printf
	LDR r0, =scanFormat
	LDR r1, =number
	BL scanf

	startSentinelLoop:
		# If r1 = -1, end sentinel loop. Otherwise, keep going.
		CMP r1, #-1
		BEQ endSentinelLoop

		# Else, get the next user input, and continue the sentinel loop 
		LDR r0, =promptMsg
		BL printf
		LDR r0, =scanFormat
		LDR r1, =number
		BL scanf
		B startSentinelLoop

	endSentinelLoop:
		# End the sentinel loop if user input is -1
		# Pop stack
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr 
	

.data
promptMsg: .asciz "Enter a number: (-1 to quit)\n"
number: .word 0
scanFormat: .asciz "%d"

