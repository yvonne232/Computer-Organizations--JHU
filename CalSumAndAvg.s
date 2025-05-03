.text
.global main
main:
	
	SUB sp, sp, #4
	STR lr, [sp, #0]

`	# Initialize the loop, prompt the user for the input
	LDR r0, =promptMsg
	BL printf
	LDR r0, =scanFormat
	LDR r1, =number
	BL scanf

	startSentinelLoop:
		# If r4 = -1, end sentinel loop. Otherwise, keep going.
		LDR r4, =number
		LDR r4, [r4]
		CMP r4, #-1
		BEQ endSentinelLoop
	
	# End the sentinel loop when user input is -1
	endSentinelLoop:
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr



