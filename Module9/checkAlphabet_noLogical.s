.text
.global main
main:
	# Main method
	# Purpose: prompt for and read a character, and call the isAlpha_bitwise function to check if the char is an alphabet
	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Prompt user for a character
	LDR r0, =prompt
	BL printf
	LDR r0, =format
	LDR r1, =char
	BL scanf
	
	# Input is r0-char
	LDR r0, =char
	LDRB r0, [r0]
	# Without LDRB, it is always wrong. 
	# LDRB loads a byte instead of a word like LDR. And strings are made up of bytes not words
	# So, load the string/array byte by byte into a register

	# The no logical way I implement is through bitwise check
	BL isAlpha_bitwise

	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt: .asciz "Enter a character: "
format: .asciz "%c"
# Char should be initialized as byte 0. Or it just error out for me.
char: .byte 0

# End Main

.text
isAlpha_bitwise:

	# Function: isAlpha_bitwise
	# Purpose: check if a char is an alphabet.
	# Input: r0 - char
	# Output: true message or false message. 
	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Change to lower case first
	ORR r0, r0, #0x20
	# Compare them bitwise
	CMP r0, #0x61
	BLT notAlpha2
	CMP r0, #0x7A
	BGT notAlpha2

	# Else, we find alphabetic char
	B alphaFound2


	notAlpha2:
		LDR r0, =msg_false_noLogical
		BL printf
		B EndCheck2

	alphaFound2:
		LDR r0, =msg_true_noLogical
		BL printf
		B EndCheck2
	
	EndCheck2:
		# Pop stack
		LDR lr, [sp]
		ADD sp, sp, #4
		MOV pc, lr
	
.data
msg_false_noLogical: .asciz "It is not an alphabetic character. (non logical) \n"	
msg_true_noLogical: .asciz " It is an alphabetic character. (non logical) \n"

# End isAlpha_bitwise
