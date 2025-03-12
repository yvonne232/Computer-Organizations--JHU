.text
.global main
main:
	# Savw return to OS on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
	# ---Call Function: miles2kilometer---
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
	
	# Call miles2kilometer function
	MOV r0, r4
	BL miles2kilometer
	
	# Print answer
	MOV r1, r0
	LDR r0, =output_km
	BL printf

	# Move kilometer to r4
	MOV r4, r1
	
	# ---Call Function: kph---
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

	#---Call Function: CToF---
	# Prompt for and read input
	LDR r0, =prompt_celsius
	BL printf
	LDR r0, =format_celsius
	LDR r1, =celsius
	BL scanf

	# Call CToF function
	BL CToF
	MOV r6, r0

	MOV r1, r6
	LDR r0, =output_fahrenheit
	BL printf
		
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

	
.data
	prompt_miles: .asciz "Enter speed in miles: "
	format_miles: .asciz "%d"
	mile: .word 0
	output_km: .asciz "Speed in kilometer: %d\n "
	
	prompt_hours: .asciz "Enter hours: "
	format_hours: .asciz "%d"
	hours: .word 0
	output_kph: .asciz "Kilometers per hour: %d\n"

	prompt_celsius: .asciz "Enter temperature in Celsius: "
	format_celsius: .asciz "%d"
	celsius: .word 0
	output_fahrenheit: .asciz "Temperature in Fahrenheit: %d\n"
	
	
