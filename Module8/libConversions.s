.global miles2kilometer
.global kph
.global CToF

.text
miles2kilometer:
	# miles2kilometer(int miles)
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]
	
	# r0 = r0 * 161 / 100
	# Since 1.61 is float, we need special registers for float number and this avoids that
	MOV r1, #161
	MUL r0, r0, r1
	MOV r1, #100
	BL __aeabi_idiv

	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
# END miles2kilometer

.text
kph:
	# kph(int hours, int miles)
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# r0 is hours, r1 is miles
	# r2 is now hours
	MOV R2, R0
	# move r1 to r0, so r0 could be used for miles2kilometer
	MOV R0, R1
	BL miles2kilometer
	# r0 is now kilometer
	# r0 = r0 / hours
	MOV r1, r2
	BL __aeabi_idiv
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
# End kph
	
.text
CToF:
	#CToF (Celsius to Fahrenheit)	
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]
	
	# F = (C * 9 / 5) + 32
	MOV r1, #9
	# r0 = r0 * 9
	MUL r0, r0, r1
	MOV r1, #5
	# r0 = r0/5
	BL __aeabi_idiv
	MOV r1, #32
	# r0 = r0 + 32
	ADD r0, r0, r1
	
	# Pop stacl
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
# End CToF
	 
