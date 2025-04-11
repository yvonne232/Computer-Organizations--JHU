.text
.global main
main:
	# Program dictionary
	# r0 - fib function input
	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# Prompt user for a number to calculate Fibonacci
	LDR r0, =prompt
	BL printf
	LDR r0, =scanFormat
	LDR r1, =number
	BL scanf

	# Load number into r0 as function input
	LDR r0, =number
	LDR r0, [r0]
	
	# If r0 is less than 0, print error messgae
	CMP r0, #0
	BLT ErrorMsg
	
	# Else, call recursion function
	BL Fib
    	# Print output
    	MOV r1, r0
    	LDR r0, =output
    	BL printf
    	B EndProgram

	ErrorMsg:
		LDR r0, =error
		BL printf
		B EndProgram
	
	EndProgram:
		# Pop stack
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr
	

.data
prompt: .asciz "\nEnter a number to calculate Fibonacci: "
scanFormat: .asciz "%d"
number: .word 0
output: .asciz "\nFibonacci = %d\n"
error: .asciz "Input must be equal to or greater than 0.\n "

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
	
	# Save input number in r4
	MOV r4, r0

	# Python:
	# if n == 0:
        #	return 0
    	# if n == 1:
        #	return 1
    	# return fib(n - 1) + fib(n - 2)
	

	# If n == 0 or n == 1 (n<=1)  return n 
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

