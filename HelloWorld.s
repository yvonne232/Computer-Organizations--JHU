.text
.global main
main:
	SUB sp, sp, #4
	STR lr, [sp]
	LDR r0, =helloWorld
	BL printf
	
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
helloWorld: .asciz "Hello World\n"
#End main




