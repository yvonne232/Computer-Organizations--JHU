.text
.global main
main:
	# Program Dictionary:
	# r4 - sentinal flag - if r4 = -1, end the sentinel loop
	# r5 - count
	# r6 - sum
	
	SUB sp, sp, #4		@ Push Stack
	STR lr, [sp, #0]
	
	MOV r5, #0                @ count = 0
    	MOV r6, #0                @ sum = 0

	sentinel_loop:
		# Prompt message
    		LDR r0, =promptMsg
    		BL printf

		# Read input into variable
		LDR r0, =scanFormat
		LDR r1, =number
		BL scanf
		
		# Load input value into r4
		LDR r4, =number
		LDR r4, [r4]

		# Check for sentinel (-1)
		CMP r4, #-1
		BEQ finish

		# sum += r4
    		ADD r6, r6, r4

    		# count += 1
    		ADD r5, r5, #1
		
		# Prompt user for the next input
    		B sentinel_loop

	
	# End the sentinel loop when user input is -1
	finish:
		# Print count
		LDR r0, =countMsg
    		MOV r1, r5
    		BL printf

		# Print sum
		LDR r0, =sumMsg
    		MOV r1, r6
    		BL printf
		
		# average = sum / count
    		MOV r0, r6              @ dividend (sum)
    		MOV r1, r5              @ divisor (count)
    		BL __aeabi_idiv
    		MOV r1, r0              @ move result to r1 for printf
		
		# Print average
		LDR r0, =avgMsg
    		BL printf
		
		# Pop stack
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr


.data
promptMsg:    .asciz "Enter an integer (-1 to stop): "
scanFormat:   .asciz "%d"
countMsg:     .asciz "Total numbers entered: %d\n"
sumMsg:       .asciz "Sum of values: %d\n"
avgMsg:       .asciz "Average of values: %d\n"
number:       .word 0

