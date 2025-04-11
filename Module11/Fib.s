.text
.global main
main:
	# Program dictionary
	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# Prompt user for a number to calculate Fibonacci
	LDR r0, =prompt
	BL printf
	LDR r0, =scanFormat
	LDR r1, =number
	BL scanf

	# Call Fib recursion function
	LDR r0, =number
	LDR r0, [r0]
	BL Fib

	# Print output
	MOV r1, r0
	LDR r0, =output
	BL printf
	
	# Pop stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
	

.data
prompt: .asciz "\nEnter a number to calculate Fibonacci:"
scanFormat: .asciz "%d"
number: .word 0
output: .asciz "\nFibonacci(%d) = %d\n"

# End Main

.text
Fib:
	# Program dictionary
	# r4 - input number
	# r5 - Fib(n-1)
	# r6 - Fib(n-2)

	# Push Stack
	SUB sp, sp, #16
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]

	MOV r4, r0

	# Python:
	# if n == 0:
        #	return 0
    	# if n == 1:
        #	return 1
    	# return fib(n - 1) + fib(n - 2)
	

	# If n == 0 or n == 1 (n<=1)  return 0
	CMP r4, #1
	BGT Else
	MOV r0, r4
	B Return
	
	# Else, return fib(n-1) + fib(n-2)
	Else:
		# Cal fib(n-1)
		MOV r0, r4
		SUB r0, r0, #1
		BL Fib
		# Save fib(n-1) in r5
		MOV r5, r0
		
		# cal fib(n-2)
		MOV r0, r4
		SUB r0, r0, #2
		BL Fib
		# Save fib(n-2) in r6
		MOV r6, r0

		# return fib(n-1) + fib(n-2)
		ADD r0, r5, r6
		B Return
				

	# Return the function
	Return:
		# Pop the stack
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		ADD sp, sp, #16
		MOV pc, lr
	
	
# End Fib

