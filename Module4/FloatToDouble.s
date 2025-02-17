.text
.global main
main:
	# Push the stack record
 	# Need to reserve 8 spaces. Not sure why though. I just tried multiple combinations since the result is always incorrect and this works. I am guessing double needs 8 bytes in the stack.
	SUB sp, sp, #8
	STR lr, [sp, #0]
	
	# Prompt the user for float number
	LDR r0, =prompt1
	BL printf

	# Read the user's input number
	LDR r0, =format1
	LDR r1, =floatNum
	BL scanf

	# Convert 32 bits float to 64 bits double
	LDR r0, =floatNum
	VLDR s0, [r0]	
	VCVT.f64.f32 d0, s0
	
	# Print double; double needs 2 base registers; single needs 1 base registers; https://developer.arm.com/documentation/dui0646/b/The-Cortex-M7-Instruction-Set/Floating-point-instructions/VMOV-two-ARM-core-registers-and-a-double-precision-register 
	LDR r0, =output1
	VMOV r2, r3, d0 
	BL printf
	
	# Pop the stack record
	LDR lr, [sp, #0]
	ADD sp, sp, #8
	MOV pc, lr

.data
prompt1: .asciz "Enter a float number:"
format1: .asciz "%f" 	
# Get bus error if not aligned
# Float needs 4 spaces
.align 4 
floatNum: .space 4
output1: .asciz "You entered: %f\n"

# Syntax: https://developer.arm.com/documentation/dui0379/e/vfp-instructions/vcvt--between-single-precision-and-double-precision-
# load the float number to s0 register; sn registers are for single precision number; VLDR is for sn and dn; LDR is for rn
# double needs 2 base registers; single needs 1 base registers; https://developer.arm.com/documentation/dui0646/b/The-Cortex-M7-Instruction-Set/Floating-point-instructions/VMOV-two-ARM-core-registers-and-a-double-precision-register
	
