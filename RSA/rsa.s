.text
.global main
main:
	# Program Dictionary
	# r4 - store p in r4
	# r5 - store q in r5
	
	SUB sp, sp, #12
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	
	PromptP:
		# Prompt and read p
		LDR r0, =prompt_p
		BL printf
		LDR r0, =scan_format
		LDR r1, =p
		BL scanf
		
		# Store p in r4
		LDR r4, =p
		LDR r4, [r4]

		# Load p into r0 and check for prime
		MOV r0, r4
		BL isPrime
	
		# If it is not prime, prompt again for p
		CMP r0, #1
    		BNE NotPrimeP
		
		# If it is prime, proceed to q
		B PromptQ
    	
	NotPrimeP:
   		LDR r0, =not_prime
    		BL printf
    		B PromptP
	
	PromptQ:
		# Prompt and read q
    		LDR r0, =prompt_q
    		BL printf
    		LDR r0, =scan_format
    		LDR r1, =q
    		BL scanf

		# Load q into r0 and check for prime
    		LDR r0, =q
    		LDR r0, [r0]
    		BL isPrime
		
		CMP r0, #1
    		BNE NotPrimeQ

		# If prime, finish
    		B Done

	NotPrimeQ:
    		LDR r0, =not_prime
    		BL printf
    		B PromptQ
	
	Done:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		ADD sp, sp, #12
		MOV pc, lr

.data
prompt_p: .asciz "Enter prime number p (p < 50): "
prompt_q: .asciz "Enter prime number q (q < 50): "
scan_format: .asciz "%d"
p: .word 0
q: .word 0
not_prime: .asciz "\The number is not a prime. Please enter again.\n"
is_prime:    .asciz "\The number is a prime.\n"

# End Main

.text
isPrime:
	# r0 = number to check
	# returns r0 = 1 if prime, 0 otherwise

	# Program Dictionary
	# r4 - Store input number into r4
	# r5 - Divisor, which starts from 2
	# r6 - n / 2
	# r7 - flag number, assume it is not prime

	SUB sp, sp, #20
	STR lr, [sp, #0]
	STR r4, [sp, #4]
    	STR r5, [sp, #8]
    	STR r6, [sp, #12]
    	STR r7, [sp, #16]
 
	MOV r4, r0	// Store input number into r4
	MOV r5, #2      // Divisor starts from 2
	MOV r6, r4, LSR #1   // r6 = n / 2
	MOV r7, #0	// Flag number, assume it is not prime
	
	checkPrimeLoop:
		CMP r5, r6
    		BGT CheckDone   // If divisor > n/2, done

		MOV r0, r4
    		MOV r1, r5
    		BL __aeabi_idiv
    		MOV r2, r0      // quotient
    		MUL r2, r2, r5  // quotient * divisor
    		SUB r2, r4, r2  // remainder = n - (q * d)
    		CMP r2, #0
    		BEQ NotPrime    // If divisible, not a prime

    		ADD r5, r5, #1
    		B checkPrimeLoop

	CheckDone:
		MOV r0, #1      // Is prime
    		B Return

	NotPrime:
    		MOV r0, #0
		B Return

	Return:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
    		LDR r5, [sp, #8]
    		LDR r6, [sp, #12]
    		LDR r7, [sp, #16]
		ADD sp, sp, #20
		MOV pc, lr

# End isPrime	
