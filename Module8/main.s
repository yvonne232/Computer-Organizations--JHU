.text
.global main
main:
	# Savw return to OS on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
	# Call Function: miles2kilometer
	# Prompt for and read input
	LDR r0, =prompt_miles
	BL printf
	# Scanf
	LDR r0, =format_miles
	LDR r1, =mile
	BL scanf
	# Move miles to r4
	LDR r4, =mile
	LDR r4, [r4]
	
	# Call mile2kilometer function
	MOV r0, r4
	BL miles2kilometer
	
	# Print answer
	MOV r1, r0
	LDR r0, =output_km
	BL printf
	
	# Call Function: kph
	# Prompt for and read input
	LDR r0, =prompt_hours
	BL printf
	LDR r0, =format_hours
	LDR r1, =hours
	BL scanf
	# Move hours to r5
	LDR r5, =hours
	LDR r5, [r5]

	# R0: hours, R1: miles; call kph function
	MOV r0, r5
	MOV r1, r4
	BL kph
	
	# Print answer
	MOV r1, r0
	LDR r0, =output_kph
	BL printf	
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

	
.data
	prompt_miles: .asciz "Enter miles: "
	format_miles: .asciz "%d"
	mile: .word 0
	output_km: .asciz "Speed in kilometer: %d\n "
	
	prompt_hours: .asciz "Enter hours: "
	format_hours: .asciz "%d"
	hours: .word 0
	output_kph: .asciz "Kilometers per hour: %d\n"
	
	
