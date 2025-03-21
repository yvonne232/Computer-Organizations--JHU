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
	LDR r1, =grade
	BL scanf
	
	# Load r0
	LDR r0, =grade
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
	ORR r0, r0, r1

	# Print error message if r0 = 0
	CMP r1, #1
	BNE ErrorMsg
	B elseError

	elseError:

	# If grade is 90-100, then print grade A message
	CMP r4, #90
	BGE printA
	
	# If grade is 80-90, then print grade B message
	CMP r4, #80
	BGE printB

	# If grade if 70-80, then print grade C message
	CMP r4, #70
	BGE printC
	
	# Else, it is gradeF
	B printF

	ErrorMsg:
		# Function: ErrorMsg
		# Purpose: print error message
		LDR r0, =error
		BL printf
		# B PrintDone has to be put here. Don't know why though. I tried different ways and only this works.
		B printDone
	
	printA:
		# Function: printA
		# Purpose: print grade A message
		LDR r0, =gradeA_msg
		BL printf
		B printDone
	
	printB:
		# Function: printB
		# Purpose: print grade B messgae
		LDR r0, =gradeB_msg
		BL printf
		B printDone

	printC:
		# Function: printC
		# Purpose: print grade C message
		LDR r0, =gradeC_msg
		BL printf
		B printDone

	printF:
		# Function: printF
		# Purpose: print grade F message
		LDR r0, =gradeF_msg
		BL printf
		B printDone
		

	printDone:
		# Function: PrintDone
		# Purpose: when it is done printing, pop stack
		LDR lr, [sp]
		LDR r4, [sp, #4]
    		ADD sp, sp, #8
    		MOV pc, lr
	
	



.data
error: .asciz "Grade must be 0-100.\n "
gradeA_msg: .asciz "Grade: A \n"
gradeB_msg: .asciz "Grade: B \n"
gradeC_msg: .asciz "Grade: C \n"
gradeF_msg: .asciz "Grade: F \n"

# End printGrades
	
	

	
	
	
