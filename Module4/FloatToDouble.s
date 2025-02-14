.text
.global main
main:
	# Push the stack record
	SUB sp, sp, #4
	STR lr, [sp, #0]
	
	# Prompt the user for float number
	LDR r0, =prompt1
	BL printf

	# Read the user's input number
	LDR r0, =format1
	LDR r1, =floatNum
	BL scanf

	# Convert 32 bits float to 64 bits double
	# Syntax: https://developer.arm.com/documentation/dui0379/e/vfp-instructions/vcvt--between-single-precision-and-double-precision-
	# load the float number to s0 register; sn registers are for single precision number; VLDR is for sn and dn; LDR is for rn
	LDR r0, =floatNum
	VLDR s0, [r0] 	
	# convert float s0 to double d0; dn registers are for double precision number
	VCVT.f64.f32 d0, s0
	
	# Print double 
	LDR r0, =output1
	# double needs 2 base registers; single needs 1 base registers; https://developer.arm.com/documentation/dui0646/b/The-Cortex-M7-Instruction-Set/Floating-point-instructions/VMOV-two-ARM-core-registers-and-a-double-precision-register
	VMOV r2, r3, d0 
	BL printf
	
	# Pop the stack record
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr
	
	 
	
.data
	prompt1: .asciz "Enter a float number:"
	format1: .asciz "%f" 	
	floatNum: .space 4
	output1: .asciz "You entered: %f\n"
