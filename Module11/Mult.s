.text
.global main
main:
	# Program Dictionary
	# r0 - value m
	# r1 - value n
		
	# Push Stack
	SUB sp, sp, #4
	STR lr, [sp, #4]
	
	# Prompt for m
	LDR r0, =prompt_m
	BL printf
	LDR r0, =scanFormat
	LDR r1, =m
	BL scanf

	# Prompt for n
	LDR r0, =prompt_n
	BL printf
	LDR r0, =scanFormat
	LDR r1, =n
	BL scanf

	# Load m into r0, n into r1
	LDR r0, =m
	LDR r0, [r0]
	LDR r1, =n
	LDR r1, [r1]

	# Error checking: if n >= 1
	CMP r1, #1
	BLT ErrorMsg
	# Else, call Mult recursion function
	BL Mult

	ErrorMsg:
		# If n < 1, print error message
		LDR r0, =error_msg
		BL printf
		B EndProgram

	EndProgram:
		# Pop stack
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr
	
	
.data
prompt_m: .asciz "\nEnter value for m: "
prompt_n: .asciz "\nEnter value for n(n >= 1): "
scanFormat: .asciz "%d"
m: .word 0
n: .word 0
error_msg: .asciz "\n n must be equal to or larger than 1.\n"

# End Main

.text
Mult:
	# Program Dictionary
	# r4 - store r0(m) in r4
	# r5 - store r1(n) in r5

	# Push Stack
	SUB sp, sp, #12
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]

	# Store r0 in r4, r1 in r5
	MOV r4, r0
	MOV r5, r1

	# Recursion Function:
    	# if n == 1:
        #	return m
    	# else:
        #	 return m + mult(m, n - 1)

	# Base case: if n==1, return m
	CMP r1, #1
	BEQ BaseCase

	# Else, return m + mult(m, n-1)
	# n = n-1
	SUB r1, r5, #1
	BL Mult
	ADD r0, r4, r0
	B Return

	BaseCase:
		MOV r0, r4
		B Return
		

	# Return the function
	Return:
		# Pop Stack
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		ADD sp, sp, #12
		MOV pc, lr


# End Mult

