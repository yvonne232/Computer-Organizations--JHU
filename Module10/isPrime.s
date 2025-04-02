.text
.global main
main:

	# Program dictionary
	# r4 - save user input number
	# r5 - divisor, sentinel loop input, from 2 to n/2
	# r6 - upper bound of the numbers, n/2

	SUB sp, sp, #12
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]

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

		# Error checking: if input is 0, 1, 2 or any negative number other than -1 are entered, print the error message and get next input from user
		CMP r4, #3
		BLT InvalidInput
		B getNextInput

		# Check if the input is a prime number
		# r6 = r4 / 2
		MOV r6, r4, LSR #1 
		MOV r5, #2
		MOV r7, #0

		# Check if a number is a prime	
		checkPrimeLoop:
			# If r5 is larger than n/2, then ends this lop
			CMP r5, r6
			BGT endCheckPrimeLoop

			# Calculate remainder
			MOV r0, r4
			MOV r1, r5
			BL __aeabi_idiv
			# r8 is quotient
			MOV r8, r0

			# r9 = quotient * divisor
			MUL r9, r8, r5
			# r9 is remainder
			SUB r9, r4, r9	

			# If remainder is 0, then r7 = 1, which means it is divisible
			CMP r9, #0
			MOVEQ r7, #1

			# Go to next iteration: r5 += 1
			ADD r5, r5, #1
			B checkPrimeLoop
		
		endCheckPrimeLoop:
			# If r7 = 0, then it is not a prime number
			CMP r7, #0
			BNE notPrime
			B getNextInput

			# Else, it is prime number
			LDR r0, =prime_msg
			MOV r4, r1
			BL printf
			B getNextInput

		
			
		# Print out the error message and get next valid input
		InvalidInput: 
			LDR r0, =errorMsg
			BL printf

		# get the next user input, and continue the sentinel loop 
		getNextInput:
			LDR r0, =promptMsg
			BL printf
			LDR r0, =scanFormat
			LDR r1, =number
			BL scanf
			B startSentinelLoop
		
		# Check if a number is a prime	
		checkPrimeLoop:
			# If r5 is larger than n/2, then ends this lop
			CMP r5, r6
			BGT endCheckPrimeLoop


		
		notPrime:
			LDR r0, =notPrime_msg
			MOV r1, r4
			BL printf
		

	endSentinelLoop:
		# End the sentinel loop if user input is -1
		# Pop stack
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		ADD sp, sp, #12
		MOV pc, lr 
	

.data
promptMsg: .asciz "\nEnter a number: (-1 to quit)\n"
number: .word 0
scanFormat: .asciz "%d"
errorMsg: .asciz "Error: Input must be >2 or -1 to quit.\n"
notPrime_msg: .asciz "Number %d  is not prime.\n"
prime_msg: .acsiz "Number %d is prime. \n"
