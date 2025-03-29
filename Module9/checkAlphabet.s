.text
.global main
main:
	# Main method
	# Purpose: prompt for and read a character, and call the isAlpha_logical function to check if the char is an alphabet
	
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
	# Then call isAlpha_logical function
	LDR r0, =char
	LDRB r0, [r0]
	# Without LDRB, it is always wrong. 
	# LDRB loads a byte instead of a word like LDR. And strings are made up of bytes not words
	# So, load the string/array byte by byte into a register
	
	BL isAlpha_logical
	
	CMP r0, #1
	# If r0 = 1, then print true message
	LDREQ r0, =msg_true
	# If r0 != 1, then print false message
	LDRNE r0, =msg_false
	BL printf

	BL isAlpha_bitwise


	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
		
	

.data
prompt: .asciz "Enter a character: "
format: .asciz "%c"
char: .byte 0
msg_true: .asciz "It is an alphabetic character. (Logical)\n"
msg_false: .asciz "It is not an alphabetic character. (Logical) \n"

# End Main

.text
isAlpha_logical:
	# Function: isAlpha_logical
	# Purpose: check if a char is an alphabet in a logical way
	# Input: r0 - char
	# Output: r0. If it is true, then r0 = 1; if it is false, then r0 = 0
	
	# Push stack 
	SUB sp, sp, #4
	STR lr, [sp]
	
	# Check: (char >= 'A' && char <= 'Z') || (char >= 'a' && char <= 'z')
	# If it is upper case, r0 = 1
	# Elseif check lower case
	CMP r0, #'A'
	BLT checkLower
	
	CMP r0, #'Z'
	BLE alphaFound
	
	checkLower:
		CMP r0, #'a'
		BLT notAlpha
		
		CMP r0, #'z'
		BLE alphaFound
	
	

	notAlpha:
		MOV r0, #0
		B EndCheck
		
	alphaFound:
		MOV r0, #1
		B EndCheck


	EndCheck: 
		# Pop stack
		LDR lr, [sp]
		ADD sp, sp, #4
		MOV pc, lr

# End isAlpha_logical

.text
isAlpha_bitwise:
	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Change to lower case first
	ORR r0, r0, #0x20
	CMP r0, #0x61
	BLT notAlpha2
	CMP r0, #0x7A
	BGT notAlpha2

	# Else, find Alpha
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

# End isAlpha_noLogical	
