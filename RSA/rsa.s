.text
.global main
main:
	# Program Dictionary
	# r4 - store p in r4
	# r5 - store q in r5
	# r6 - store modulus n = p * q in r6
	# r7 - store phi(n) = (p-1) * (q-1) in r7
	
	SUB sp, sp, #28
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]
	STR r9, [sp, #24]
	
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

		# Store q in r5
    		LDR r5, =q
    		LDR r5, [r5]

		# Load q into r0 and check for prime
    		MOV r0, r5
    		BL isPrime
		
		CMP r0, #1
    		BNE NotPrimeQ

		# If prime, finish
    		B PromptPandQFinish

	NotPrimeQ:
    		LDR r0, =not_prime
    		BL printf
    		B PromptQ
	
	PromptPandQFinish:
		B ComputeModulusAndPhi

	ComputeModulusAndPhi:
		MUL r6, r4, r5	// n = p * q, n is the public key
		SUB r7, r4, #1	// p = p-1
		SUB r8, r5, #1  // q = q-1
		MUL r7, r7, r8	// fi(n) =  (p - 1)(q - 1); store fi(n) in r7

		LDR r0, =msg_n
    		MOV r1, r6
    		BL printf

		LDR r0, =msg_phi
    		MOV r1, r7
    		BL printf
		
		# Compute public key component (e)
		MOV r0, r7	// Pass phi in r7 to the function
		BL cpubexp
		MOV r8, r0	// Save e in r8

		# Debug Print e and phi
        	LDR r0, =debug_e
        	MOV r1, r8
        	MOV r2, r7
        	BL printf

		
		# Compute private key exponent
		MOV r0, r8        // r0 = e
    		MOV r1, r7        // r1 = phi
		BL cprivexp
		MOV r9, r0	// Store d in r9
		
		# Print d
    		LDR r0, =msg_d
    		MOV r1, r9
    		BL printf

		B Done
	

					
	Done:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		LDR r7, [sp, #16]
		LDR r8, [sp, #20]
		LDR r9, [sp, #24]
		ADD sp, sp, #28
		MOV pc, lr

.data
prompt_p: .asciz "Enter prime number p (p < 50): "
prompt_q: .asciz "Enter prime number q (q < 50): "
prompt_e: .asciz "Enter public exponent e (1 < e < phi(n), and gcd(e, phi(n)) = 1): "
scan_format: .asciz "%d"
p: .word 0
q: .word 0
e: .word 0
d: .word 0
not_prime: .asciz "\The number is not a prime. Please enter again.\n"
is_prime:    .asciz "\The number is a prime.\n"
msg_pubkey: .asciz "Public Key (n, e) = (%d, %d)\n"
msg_n: .asciz "Modulus n = %d\n"
msg_phi: .asciz "Totient phi(n) = %d\n"
msg_e: .asciz "Public exponent e = %d\n"
invalid_e_msg: .asciz "\nInvalid e. Must satisfy: 1 < e < phi and gcd(e, phi) = 1.\n"
msg_d: .asciz "Private exponent d = %d\n"

debug_e: .asciz "Debug Before cprivexp: e = %d, phi = %d\n"
trying_x: .asciz "Trying x = %d\n"

# End Main

.text
isPrime:
	# Function purpose: check if r0 is prime number
	# Input: r0 = number to check
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
    		B Return_primecheck

	NotPrime:
    		MOV r0, #0
		B Return_primecheck

	Return_primecheck:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
    		LDR r5, [sp, #8]
    		LDR r6, [sp, #12]
    		LDR r7, [sp, #16]
		ADD sp, sp, #20
		MOV pc, lr

# End isPrime	

.text
gcd:
	# Function purpose: find the greatest common divisor of a and b
	# Input: r0 = a (e), r1 = b (phi)
    	# returns r0 = gcd(a, b)

	# Function pseudo code:
	# int gcd(int a, int b) {
    	#    while (b != 0) {
        #		int r = a % b;
        #		a = b;
        #		b = r;
    	#    }
    	# return a;
	# }

	# Program Dictionary
	# r4: store r0 in r4

	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	
	gcd_loop:
		CMP r1, #0
    		BEQ gcd_done
	
		MOV r4, r0	// Store r0 in r4
		BL __aeabi_idiv       // r0 = a / b
		MOV r2, r0            // r2 = quotient = a / b
		MUL r3, r2, r1        // r3 = quotient * b
		SUB r0, r4, r3        // r0 = a - (quotient * b) = a % b

		MOV r5, r1            // r5 = old b
    		MOV r1, r0            // new b = remainder
    		MOV r0, r5            // new a = old b
		B gcd_loop
	
	gcd_done:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		ADD sp, sp, #8
		MOV pc, lr
.data
# End gcd

.text
cprivexp:
	# Function purpose: compute private key exponent d
	# loop through x = 1, 2, ... until we find an integer d such that (1 + x * phi) MOD e == 0. Then d = (1 + x * phi) / e
	# Input: r0 = e, r1 = phi
	# returns d in r0

	# Program Dictionary
    	# r4 = Save e
    	# r5 = Save phi
	# r6 = temp numerator
	# r7 = temp remainder
	# r8 = temp quotient
	# r9 = Save x counter

	SUB sp, sp, #28
    	STR lr, [sp, #0]
    	STR r4, [sp, #4]   // Save e
    	STR r5, [sp, #8]   // Save phi
    	STR r6, [sp, #12]  // temp numerator
    	STR r7, [sp, #16]  // temp remainder
    	STR r8, [sp, #20]  // temp quotient
    	STR r9, [sp, #24]  // Save x counter

	# x starts from 1
	MOV r9, #1        // x counter
	MOV r4, r0        // Save e in r4
    	MOV r5, r1        // Save phi in r5  
	LDR r3, =10000

	d_loop:
		CMP r9, r3
    		BGE not_found       // If x >= 10000, give up

		MUL r6, r9, r5      // r6 = x * phi
    		ADD r6, r6, #1      // r6 = 1 + x * phi

    		MOV r0, r6          // numerator
    		MOV r1, r4          // e
    		BL __aeabi_idivmod  // Call IDIVMOD (returns quotient in r0, remainder in r1)

		MOV r8, r0          // save quotient
    		MOV r7, r1          // save remainder

    		CMP r7, #0
    		BEQ d_found         // if remainder == 0, found d

		ADD r9, r9, #1
    		B d_loop	

	
	d_found:
		// Recompute numerator = 1 + x * phi, in case the registers get weird
    		MUL r6, r9, r5
   		ADD r6, r6, #1

    		MOV r0, r6      // numerator = 1+x*phi
    		MOV r1, r4      // e
    		BL __aeabi_idiv // final division to get d
		B Return_cprivexp
		
	Return_cprivexp:

		LDR lr, [sp, #0]
    		LDR r4, [sp, #4]
    		LDR r5, [sp, #8]
    		LDR r6, [sp, #12]
    		LDR r7, [sp, #16]
    		LDR r8, [sp, #20]
		LDR r9, [sp, #24]
    		ADD sp, sp, #28
    		MOV pc, lr

	not_found:
    		MOV r0, #-1        // return -1 if not found
		B Return_cprivexp

# End cprivexp

.text
cpubexp:
	# Function purpose: compute public key component
	# Prompt for e, validate e
	# Input: r0 = phi
    	# Output: r0 = valid e

	SUB sp, sp, #12
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	
	MOV r4, r0	// Save phi in r4

	PromptE:
		LDR r0, =prompt_e
    		BL printf
    		LDR r0, =scan_format
    		LDR r1, =e
    		BL scanf

		# Store e in r5
		LDR r5, =e
		LDR r5, [r5]

		LDR r0, =msg_e
    		MOV r1, r5
    		BL printf

		# Check: if e <= 1
		CMP r5, #1
		BLE InvalidE
		
		# Check: if e >= phi
		CMP r5, r4
		BGE InvalidE

		# Check: if gcd(e, phi) == 1
		MOV r0, r5      // r0 = e
		MOV r1, r4	// r1 = phi
		BL gcd
		CMP r0, #1
		BNE InvalidE
		
		B Return_cpubexp

	InvalidE:
		LDR r0, =invalid_e_msg
		BL printf
		B PromptE	
	
	Return_cpubexp:
		# Valid e, return in r

		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		ADD sp, sp, #12
		MOV r0, r5
		MOV pc, lr

# End cpubexp
