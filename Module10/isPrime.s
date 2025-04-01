.text
.global main
main:

	# Program dictionary
	# r4 - save user input number

	SUB sp, sp, #8
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

		# Error checking: if input is 0, 1, 2 or any negative number other than -1 are entered, print the error message
		CMP r4, #3
		BLT InvalidInput

		# Else, check if the input is a prime number


		# Print out the error message and get next valid input
		InvalidInput: 
			LDR r0, =errorMsg
			BL printf
			B getNextInput

		# get the next user input, and continue the sentinel loop 
		getNextInput:
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
		LDR r4, [sp, #4]
		ADD sp, sp, #8
		MOV pc, lr 
	

.data
promptMsg: .asciz "\nEnter a number: (-1 to quit)\n"
number: .word 0
scanFormat: .asciz "%d"
errorMsg: .asciz "Error: Input must be >2 or -1 to quit.\n"

