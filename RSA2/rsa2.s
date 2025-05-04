.text
.global main

.extern printf
.extern scanf
.extern fopen
.extern fclose
.extern fprintf

main:
	
	SUB sp, sp, #28
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]
	STR r9, [sp, #24]
	
	# Main Menu
	menu_loop:
		LDR r0, =menu_text
    		BL printf

    		LDR r0, =scan_format
    		LDR r1, =menu_choice
    		BL scanf

    		LDR r0, =menu_choice
    		LDR r0, [r0]

    		CMP r0, #1
    		BEQ do_generate_keys
	
		CMP r0, #2
		BEQ do_encrypt_message

		CMP r0, #3
		BEQ do_decrypt_message
		
		CMP r0, #4
    		BEQ Done
	
		B menu_loop     @ re-show menu if input was invalid

	do_generate_keys:
    		BL generate_keys
    		B menu_loop

	do_encrypt_message:
		BL run_tests
    		BL encrypt_message
    		B menu_loop
	
	do_decrypt_message:
		BL decrypt_message
		B menu_loop
				
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
scan_string_format: .asciz "%s"
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
invalid_e_msg: .asciz "Invalid e. Must satisfy: 1 < e < phi and gcd(e, phi) = 1.\n"
msg_d: .asciz "Private exponent d = %d\n"
n_val: .word 0
e_val: .word 0
d_val: .word 0

debug_e: .asciz "Debug Before cprivexp: e = %d, phi = %d\n"
trying_x: .asciz "Trying x = %d\n"

menu_text: .asciz "\nSelect an option:\n1 - Generate Public and Private Keys\n2 - Encrypt a Message\n3 - Decrypt a Message\n4 - Exit\n\n"
menu_choice: .word 0

sample_input: .asciz "Hello from Team 1"
debug_pow_msg: .asciz "Debug: %d^%d = %d (before mod)\n"
debug_pow_result_msg: .asciz "Debug: pow result = %d\n"
pow_test_msg:      .asciz "\nTesting pow function: 5^3...\n"
pow_test_result:   .asciz "pow(%d, %d) = %d (expected 125)\n\n"
mod_test_msg:      .asciz "Testing mod function: 17 mod 5...\n"
mod_test_result:   .asciz "%d mod %d = %d (expected 2)\n\n"
modexp_debug_input:  .asciz "Testing modexp function: computing %d^%d mod %d\n"
modexp_debug_pow:    .asciz "pow result: %d\n"
modexp_debug_result: .asciz "final result: %d\n\n"
test_case_msg:      .asciz "\nRunning modexp test case: 5^3 mod 13 (expect 8)\n"
test_result_msg:    .asciz "modexp(%d,%d,%d) = %d\n"


debug_char:     .asciz "Processing char: %c (ASCII %d)\n"
encrypt_success_msg:    .asciz "Encryption complete!\n"
encrypted_char:   .asciz "  Encrypted to: %d\n\n"
test_msg:      .asciz "\nTesting modexp: 5^3 mod 13...\n"
test_result:   .asciz "modexp(%d,%d,%d) = %d (expected 8)\n"
success_msg:  .asciz "Test PASSED (got expected result 8)\n"
fail_msg:     .asciz "Test FAILED (expected 8)\n"

input_filename:  .asciz "plaintxt.txt"
output_filename: .asciz "encrypted.txt"
read_mode:       .asciz "r"
write_mode:      .asciz "w"
char_format:     .asciz "%c"
input_error_msg: .asciz "Error opening input file.\n"
output_error_msg:.asciz "Error opening output file.\n"

sample_input_decrypt: .word 23, 45, 78, 89, 90, 0   @ Example encrypted numbers, null-terminated
debug_num:          .asciz "Decrypting number: %d\n"
debug_num_msg: .asciz "Encrypted number: %d\n"
decrypted_char:     .asciz "  Decrypted to: %c (ASCII %d)\n\n"
decrypt_success_msg: .asciz "Decryption complete!\n"

# End Main

/* ------------------------------------ */
/* Generate Keys Main Function */
.text
generate_keys:
	# Program Dictionary
	# r4 - store p in r4
	# r5 - store q in r5
	# r6 - store modulus n = p * q in r6
	# r7 - store phi(n) = (p-1) * (q-1) in r7
	# r8 - store e in r8
	# r9 - store d in r9
	
	SUB sp, sp, #28
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]
	STR r9, [sp, #24]
	
	# Prompt p and check if it is prime number
	BL PromptForP
	MOV r4, r0	// Save p in r4
		
	# Prompt q and check if it is prime number
	BL PromptForQ
	MOV r5, r0	// Save q in r5

	# Calculate modulo n = p * q; input r0 - p, r1 - q
	MOV r0, r4
	MOV r1, r5
	BL modulo
	MOV r6, r0	// save modulus n = p * q in r6

	# Calculate fi(n) = (p-1)(q-1); and store fi(n) in r7
	MOV r0, r4
	MOV r1, r5
	BL computePhi
	MOV r7, r0	// Save phi in r7
		
	# Compute public key component (e)
	MOV r0, r7	// Pass phi in r7 to the function
	BL cpubexp
	MOV r8, r0	// Save e in r8
	
	# Compute private key exponent
	MOV r0, r8        // r0 = e
    	MOV r1, r7        // r1 = phi
	BL cprivexp
	MOV r9, r0	// Store d in r9

	# Store n and e and d permanently
	LDR r0, =n_val
    	STR r6, [r0]

    	LDR r0, =e_val
    	STR r8, [r0]
	
	LDR r0, =d_val
	STR r9, [r0]

	B generateKeys_Done
	
					
	generateKeys_Done:
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		LDR r7, [sp, #16]
		LDR r8, [sp, #20]
		LDR r9, [sp, #24]
		ADD sp, sp, #28
		MOV pc, lr


/* ------------------------------------ */
/* Generate Keys Helper Functions */
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
	
	CMP r4, #1
	BLE NotPrime    // If n <= 1, it is not prime
	
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
		MOV r2, r9      @ Copy r9 to temporary
    		MUL r6, r2, r5
   		ADD r6, r6, #1

    		MOV r0, r6      // numerator = 1+x*phi
    		MOV r1, r4      // e
    		BL __aeabi_idiv // final division to get d
		MOV r4, r0

		# Print d
    		LDR r0, =msg_d
    		MOV r1, r4
    		BL printf
		
		MOV r0, r4
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
		LDR r0, =e    // load address of e
    		LDR r0, [r0]  // load value of e into r0

		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		ADD sp, sp, #12
		MOV pc, lr

# End cpubexp

.text
PromptForP:
	# Function Purpose: Prompt for p and validate if it is prime
	# Input: no inputs
	# Output: r0 - p
	
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]

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

		B Return_PromptForP
	
	NotPrimeP:
   		LDR r0, =not_prime
    		BL printf
    		B PromptP
	
	Return_PromptForP:
		LDR r0, =p
		LDR r0, [r0]

		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		ADD sp, sp, #8
		MOV pc, lr

# End PromptForP

.text
PromptForQ:
	# Function Purpose: Prompt for q and validate if it is prime
	# Input: no inputs
	# Output: r0 - q
	
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]

	PromptQ:
		# Prompt and read q
    		LDR r0, =prompt_q
    		BL printf
    		LDR r0, =scan_format
    		LDR r1, =q
    		BL scanf

		# Store q in r4
    		LDR r4, =q
    		LDR r4, [r4]

		# Load q into r0 and check for prime
    		MOV r0, r4
    		BL isPrime
		
		CMP r0, #1
    		BNE NotPrimeQ

		# If prime, finish
    		B Return_PromptForQ

	NotPrimeQ:
    		LDR r0, =not_prime
    		BL printf
    		B PromptQ

	Return_PromptForQ:
		LDR r0, =q
		LDR r0, [r0]

		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		ADD sp, sp, #8
		MOV pc, lr
	
# End PromptForQ

.text
modulo:
	# Function Purpose: Calculate modulus n = p * q
	# Input: r0 - p, r1 - q	
	# Output: r0 - n
	
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	
	MOV r2, r0      // Copy r0 to temporary
	MUL r0, r2, r1	// n = p * q, n is the public key
	MOV r4, r0	// save n in r4

	LDR r0, =msg_n
    	MOV r1, r4
    	BL printf
	
	MOV r0, r4
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	ADD sp, sp, #8
	MOV pc, lr
# End modulo

.text
computePhi:
	# Function Purpose: Calculate Phi
	# Input: r0 - p, r1 - q
	# output: r0 - phi
	
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]

	SUB r0, r0, #1	// p = p-1
	SUB r1, r1, #1  // q = q-1
	MOV r2, r0      @ Copy r0 to temporary
	MUL r4, r2, r1	// fi(n) =  (p - 1)(q - 1); store fi(n) in r4
	
	LDR r0, =msg_phi
    	MOV r1, r4
    	BL printf
	
	MOV r0, r4
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	ADD sp, sp, #8
	MOV pc, lr

# End computePhi



/* ------------------------------------ */
/* Encrypt the message*/
.text
encrypt_message:
	# Function purpose: main encrypt message function
	
	# Program Dictionary:
	# r4 - value n
	# r5 - value e
	# r6 - string pointer

	SUB sp, sp, #24
    	STR lr, [sp, #0]
    	STR r4, [sp, #4]   @ base
    	STR r5, [sp, #8]   @ exponent
    	STR r6, [sp, #12]  @ modulus
    	STR r7, [sp, #16]  @ result
	STR r8, [sp, #20]
    	

    	# Load n and e back from memory
    	LDR r0, =n_val
    	LDR r4, [r0] 		@ r4 = n

    	LDR r0, =e_val
	LDR r5, [r0]		@ r5 = e

	LDR r0, =msg_n		@ Debug: print n and e
    	MOV r1, r4		@ r4 = n
    	BL printf

    	LDR r0, =msg_e		@ r5 = e
    	MOV r1, r5
    	BL printf

	LDR r6, =sample_input     @ r6 = pointer to current character

	@ Then start the loop
	B process_loop
	
	process_loop:
		LDRB r7, [r6], #1      @ r7 = current character
    		CMP r7, #0             @ Check for null terminator
    		BEQ done_processing
    
    		@ Skip space characters (ASCII 32)
    		CMP r7, #32
    		BEQ process_loop
    
    		@ Print original character
    		PUSH {r0-r3}
    		LDR r0, =debug_char
    		MOV r1, r7
    		MOV r2, r7
    		BL printf
    		POP {r0-r3}

		# Encrypt: c = m^e mod n
    		MOV r0, r7
    		MOV r1, r5
    		MOV r2, r4
    		BL modexp
    		MOV r8, r0
    
    		# Print encrypted result
    		PUSH {r0-r3}
    		LDR r0, =encrypted_char
    		MOV r1, r8
    		BL printf
    		POP {r0-r3}

		B process_loop

	done_processing:
    		LDR r0, =encrypt_success_msg
    		BL printf

		LDR lr, [sp, #0]
    		LDR r4, [sp, #4]
    		LDR r5, [sp, #8]
    		LDR r6, [sp, #12]
    		LDR r7, [sp, #16]
		LDR r8, [sp, #20]
    		ADD sp, sp, #24
    		MOV pc, lr
	
# End encrypt_message

/* ------------------------------------ */
/* Encrypt message helper function */
.text
pow:
	# Function: Exponential Function: result = m^e
	# Input: r0 = base (m), r1 = exponent (e)
	# Output: r0 = result

	# Program Dictionary:
	# r4 - current base m
	# r5 - exponent e
	
	SUB sp, sp, #16
	STR lr, [sp, #0] 
	STR r4, [sp, #4]
    	STR r5, [sp, #8]
	STR r6, [sp, #12]  @ result

	MOV r4, r0           @ Store base in r4
	MOV r5, r1           @ Store exponent in r5

	@ Handle special cases
    	CMP r5, #0
    	MOVEQ r6, #1
    	BEQ pow_done
    
    	MOV r6, r4        @ Initialize result = base
    	SUB r5, r5, #1    @ We already have 1 multiplication
    
    	pow_loop:
        	CMP r5, #0
        	BEQ pow_done
        
        	MUL r6, r6, r4  @ result *= base
        	SUBS r5, r5, #1 @ decrement counter
        
        	BNE pow_loop
    
	pow_done:
    		MOV r0, r6        @ Return result
    		LDR lr, [sp, #0]
    		LDR r4, [sp, #4]
    		LDR r5, [sp, #8]
    		LDR r6, [sp, #12]
    		ADD sp, sp, #16
    		MOV pc, lr

# End pow

.text
modexp:
	# Function: Modular Exponentiation using exponential: c = m^e mod n
	# Input: r0 = base (m), r1 = exponent (e), r2 = modulus (n)
	# Output: r0 = result (c)

	    PUSH {r4-r6, lr}
    MOV r4, r0        @ base
    MOV r5, r1        @ exponent
    MOV r6, r2        @ modulus
    
    # Compute pow(base, exp)
    BL pow
    MOV r1, r6        @ modulus
    BL mod_reduce     @ pow result % modulus
    
    POP {r4-r6, pc}

	
.text
mod_reduce:
	# Function: Modular Reduction: r0 = r0 mod r1
    	PUSH {lr}
    	BL __aeabi_idivmod     @ r1 = r0 % r1
    MOV r1, #5
    MOV r3, #3
    BL printf

    # ================================
    # TEST CASE 2: Verify 17 mod 5 = 2
    # ================================
    LDR r0, =mod_test_msg
    BL printf
    
    MOV r0, #17       @ dividend
    MOV r1, #5        @ divisor
    BL mod_reduce     @ r0 = 17 mod 5
    
    MOV r3, r0        @ save result
    LDR r0, =mod_test_result
    MOV r1, #17
    MOV r2, #5
    BL printf

    # ============================================
    # TEST CASE 3: Verify modexp(5,3,13) = 8
    # ============================================
    LDR r0, =test_case_msg
    BL printf
    
    MOV r0, #5         @ base
    MOV r1, #3         @ exponent
    MOV r2, #13        @ modulus
    BL modexp
    
    # Verify test result
    MOV r4, r0         @ save result
    LDR r0, =test_result_msg
    MOV r1, #5
    MOV r2, #3
    MOV r3, #13
    MOV r4, r4         @ actual result
    BL printf

   
    # Epilogue
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr



/* ------------------------------------ */
/* Decrypt the message from string input */
.text
decrypt_message:
    # Function purpose: Decrypt message from string input
    # Register usage:
    # r4 - modulus n
    # r5 - private key d
    # r6 - encrypted number pointer
    # r7 - current encrypted number
    # r8 - decrypted character
    # r9 - flag for number parsing
    
    SUB sp, sp, #28
    STR lr, [sp, #0]
    STR r4, [sp, #4]   @ n
    STR r5, [sp, #8]   @ d
    STR r6, [sp, #12]  @ string pointer
    STR r7, [sp, #16]  @ current char
    STR r8, [sp, #20]  @ current number
    STR r9, [sp, #24]  @ number flag (0 = not parsing, 1 = parsing)

    # Load n and d from memory
    LDR r6, =n_val
    LDR r6, [r6]        @ r6 = n
    
    LDR r7, =d_val
    LDR r7, [r7]        @ r7 = d
    
    # Load address of encrypted numbers
    LDR r4, =sample_input_decrypt
    
    decrypt_loop:
        # Load next number to decrypt
        LDR r5, [r4], #4    @ r5 = *r4, then r4 += 4
        
        # Check for termination (0 value)
        CMP r5, #0
        BEQ decrypt_done
        
        # Here would be the actual decryption:
        # MOV r0, r5        @ encrypted number
        # MOV r1, r7        @ private exponent d
        # MOV r2, r6        @ modulus n
        # BL modexp         @ result = encrypted^d mod n
        
        # For now just print the encrypted number (debug)
        MOV r1, r5
        LDR r0, =debug_num_msg
        BL printf
        
        B decrypt_loop

decrypt_done:
    # Print completion message
    LDR r0, =decrypt_success_msg
    BL printf

    # Restore registers and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r9, [sp, #24]
    ADD sp, sp, #28
    MOV pc, lr

decrypt_number:
    # Decrypt the number in r8 using (d,n) in r5,r4
    # Preserves all registers except r0-r3
    
    PUSH {r4-r9, lr}
    
    # Print encrypted number
    LDR r0, =debug_num
    MOV r1, r8
    BL printf
    
    # RSA decrypt: m = c^d mod n
    MOV r0, r8        @ c (encrypted number)
    MOV r1, r5        @ d
    MOV r2, r4        @ n
    BL modexp         @ m = c^d mod n
    
    # Print decrypted character
    MOV r2, r0        @ Save ASCII value
    LDR r0, =decrypted_char
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    LDR r9, [sp, #24]
    ADD sp, sp, #28
    MOV pc, lr

decrypt_number:
    # Decrypt the number in r8 using (d,n) in r5,r4
    # Preserves all registers except r0-r3
    
    PUSH {r4-r9, lr}
    
    # Print encrypted number
    LDR r0, =debug_num
    MOV r1, r8
    BL printf
    
    # RSA decrypt: m = c^d mod n
    MOV r0, r8        @ c (encrypted number)
    MOV r1, r5        @ d
    MOV r2, r4        @ n
    BL modexp         @ m = c^d mod n
    
    # Print decrypted character
    MOV r2, r0        @ Save ASCII value
    LDR r0, =decrypted_char
    MOV r1, r2        @ Pass ASCII value twice (for %c and %d)
    BL printf
    
    POP {r4-r9, lr}
    MOV pc, lr
