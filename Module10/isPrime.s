.text
.global main
main:

	# Program dictionary
	# r4 - save user input number

	SUB sp, sp, #4
	STR lr, [sp, #0]
	STR r4, [sp, #4]

	# Initialize the loop, prompt the user for the input
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

		# Else, get the next user input, and continue the sentinel loop 
		LDR r0, =promptMsg
		BL printf
		LDR r0, =scanFormat
		LDR r1, =number
		BL scanf
		B startSentinelLoop

		# Error checking: if input is 0, 1, 2 or any negative number other than -1 are entered, print the error message
		CMP r4, #2
		BLE InvalidInput

		InvalidInput: 
			LDR r0, =errorMsg
			BL printf
			B startSentinelLoop
		

		# Initialize checking prime loop
		
			

	endSentinelLoop:
		# End the sentinel loop if user input is -1
		# Pop stack
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		ADD sp, sp, #4
		MOV pc, lr 
	

.data
promptMsg: .asciz "Enter a number: (-1 to quit)\n"
number: .word 0
scanFormat: .asciz "%d"
errorMsg: .asciz "Error: Input must be >2 or -1 to quit.\n"

