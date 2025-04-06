.text
.global main
main:
	# Program dictionary:
	# r4 - user input for maximum value
	# r5 - lower bound of guesses
	# r6 - upper bound of guesses
	# r7 - guess; (low + high) / 2
	# r8 - user answer; higher(h) or lower(l) or correct(c)

	# Push stack
	SUB sp, sp, #24
	STR lr, [sp, #0]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]


	# Prompt user for maximum value
	LDR r0, =prompt_max
	BL printf
	LDR r0, =format_max
	LDR r1, =max
	BL scanf

	# Load maximum value into r4
	LDR r4, =max
	LDR r4, [r4]

	# Initialize low = 1, high = maximum value; r5 - lower bound; r6 - higher bound
	MOV r5, #1
	MOV r6, r4

	guessLoop:
		# guess = (low + high) / 2
		ADD r0, r5, r6
		MOV r1, #2
		BL __aeabi_idiv
		MOV r7, r0
		# guess is stored at r7

		# Ask user if the guess is correct
		LDR r0, =guessMsg
		MOV r1, r7
		BL printf

		LDR r0, =ifCorrect_msg
		BL printf

		# Scan the user answer - higher(h) or lower (l) or correct(c)
		LDR r0, =answer_format
		LDR r1, =user_answer
		BL scanf

		# Store user answer in r8; It is char, so use LDRB
		LDR r9, =user_answer
		LDRB r8, [r9]
		
		# If it is c, then it is correct
		CMP r8, #'c'
		BEQ guessCorrect

		# If it is h, then it is high
		CMP r8, #'h'
		BEQ guessHigh

		# If it is l, then it is low
		CMP r8, #'l'
		BEQ guessLow

		guessCorrect:
			# When guess is correct, print correct message and end the loop
			LDR r0, =correctMsg
			MOV r1, r7
			BL printf
			B endGuessLoop

		guessHigh:
			# When guess is high, update lower bound r5; r5 = guess + 1
			ADD r5, r7, #1
			B guessLoop
		
		guessLow:
			# When guess is low, update higher bound r6; r6 = guess - 1
			SUB r6, r7, #1
			B guessLoop
			
			

	endGuessLoop:
		# Pop stack
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		LDR r7, [sp, #16]
		LDR r8, [sp, #20]
		ADD sp, sp, #24
		MOV pc, lr

.data
prompt_max: .asciz "Enter the maxiumum value:\n"
format_max: .asciz "%d"
max: .word 0
guessMsg: .asciz "My guess is %d. \n"
ifCorrect_msg: .asciz "Is this number higher (h), lower (l), or correct(c)? \n"
answer_format: .asciz " %c"
user_answer: .word 0
correctMsg: .asciz "I guessed it! Your number is %d. \n"

