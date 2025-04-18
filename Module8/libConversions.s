.global miles2kilometer
.global kph
.global CToF
.global InchesToFt

# Function: miles2kilometer
# Purpose: Convert miles to kilometers
# Input:r0 - miles
# Output: r0 - Kilometers
# Comment: Since 1.61 is float and we need special registers for floating numbers. Using 161/100 we bypass floating point registers and operations
# To achieve better precision, we could use 1610/1000 or even 16100/10000. This way, we preserve more decimal places
.text
miles2kilometer:
	# miles2kilometer(int miles)
	# Push stack
	SUB sp, sp, #4
	STR lr, [sp]
	
	# r0 = r0 * 161 / 100
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

# Function: kph
# Purpose: Calculate kilometers per hour
# Input: r0 - hours, r1 - miles
# Output: r0 - kph
.text
kph:
	# kph(int hours, int miles)
	# Push stack
	SUB sp, sp, #12
	STR lr, [sp]
	STR r0, [sp, #4]
	# Has to store in the stack. Otherwise it keeps giving wrong results.

	# r0 is hours, r1 is miles
	# move r1 to r0, so r0 could be used for miles2kilometer
	MOV R0, R1
	BL miles2kilometer
	# r0 is now kilometer

	STR r0, [sp, #8]

	# Debug: Print kilometers
    	MOV r1, r0
    	LDR r0, =debug_km
    	BL printf

	# r0 = r0 / hours
	LDR r0, [sp, #8]
	LDR r1, [sp, #4]
	BL __aeabi_idiv

	STR r0, [sp, #8]

	LDR r0, [sp, #8]
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #12
	MOV pc, lr
.data
debug_km: .asciz "DEBUG: Kilometers = %d\n"
debug_kph: .asciz "DEBUG: KPH Result = %d\n"
# End kph

# Function: CToF
# Purpose: Convert celsius to Fahrenheit
# Input: r0 - celsius
# Output: r0 - fahrenheit	
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
	# r0 = r0 + 32
	ADD r0, r0, #32
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
# End CToF


# Function: InchesToFt
# Purpose: Convert inches to feet
# Input: r0 - inches
# Output: r0 - feet; r1 - remaining inches
.text
InchesToFt:
	# InchesToFt (Inches to Feet)
	# Push stack
	SUB sp, sp, #8
	STR lr, [sp]
	STR r0, [sp, #4]
	# explicitly save r0; if use MOV r2, r0, I always get error, don't know why 
	
	# MOV r2, r0
	MOV r1, #12
	# r0 = r0 / 12 => feet
	BL __aeabi_idiv
	# Store feet in r3
	MOV r3, r0
	# r2 - total inches
	LDR r2, [sp, #4]
	# r4: total feet in inches
	MOV r1, #12
	MUL r4, r3, r1
	# Store remaining inches in r1
	SUB r1, r2, r4
	# So, we return r0: total feet and r1: remaining inches
	
	# Pop stack
	LDR lr, [sp]
	ADD sp, sp, #8
	MOV pc, lr
.data
# End InchesToFt
	
	 
