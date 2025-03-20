.text
.global main
main:
	# main	
	# Purpose: Prompt for and read grades, and then call printGrades function and print grades

	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Prompt for and read grades
	LDR r0, =prompt
	BL printf
	LDR r0, =format
	LDR r0, [r0]
	BL printGrades
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt: .asciz "\nEnter a grade between 0-100: "
format: .asciz "%d"
grade: .word 0

# End Main	

.text
printGrades:
	# Function: printGrades
	# Purpose: If the average is <0 or >100,  print an error. Else calculate a grade as 90-100 as A, 80-90 as B, 70-80 as C, else F.
	# Input: r0 - score(0-100)
	# Output: grade

	# Push stack
	SUB sp, sp, #8
	STR lr, [sp]
	STR r4, [sp, #4]
	
	# Store r0 in r4
	MOV r4, r0
	
	# Check if the input is 0-100
	MOV r0, #0
	CMP r4, #0
	ADDGE r0, r0, #1
	MOV r1, #0
	CMP r4, #100
	ADDLE r1, r1, #1
	OR r0, r0, r1

	LDR lr, sp
	LDR r4, [sp, #4]
	ADD sp, sp, #8
	MOV pc, le

# End printGrades
	
	

	
	
	
