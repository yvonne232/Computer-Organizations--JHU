.text
.global main
main:
	# main	
	# Purpose: Prompt for and read grades, and then call printGrades function and print grades

	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Prompt for and read grades and name
	LDR r0, =prompt_name
	BL printf
	LDR r0, =fprmat_name
	LDR r1, =name
	BL scanf
	
	LDR r0, =prompt_score
	BL printf
	LDR r0, =format_score
	LDR r1, =grade
	BL scanf
	
	# print name
	LDR r0, =output_name
	BL printf

	# Call printGrades function
	LDR r0, =grade
	LDR r0, [r0]
	BL printGrades
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
prompt_score: .asciz "\nEnter student average grade between 0-100: "
prompt_name: .asciz "\nEnter student name: "
format_score: .asciz "%d"
format_name: .asciz "%s"
output_name: "Student's name is
name: .space 50
grade: .word 0
output_name: "Student is %s. \n"

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

	# Print error message if r4 < 0 or r4 > 100
	# If use ORR, always get error. Not sure why
	CMP r4, #0
	BLT ErrorMsg
	CMP r4, #100
	BGT ErrorMsg

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
	
	

	
	
	
