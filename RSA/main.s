.text
.global main

.extern printf
.extern scanf
.extern fopen
.extern fclose
.extern fprintf
.extern fscanf
.extern fflush

main:
    push {r4-r12, lr}

menu:
    ldr r0, =menu_text
    bl printf

    ldr r0, =scan_format
    ldr r1, =menu_choice
    bl scanf

    ldr r0, =menu_choice
    ldr r0, [r0]

    cmp r0, #1
    beq generate_keys

    cmp r0, #2
    beq encrypt_message

    cmp r0, #3
    beq decrypt_message

    cmp r0, #4
    beq exit_program

    b menu

/* ------------------------------------ */
/* Generate Keys */
generate_keys:
prompt_p:
    ldr r0, =msg_p
    bl printf
    ldr r0, =scan_format
    ldr r1, =p
    bl scanf
    ldr r4, =p
    ldr r4, [r4]

    mov r0, r4
    bl isPrime
    cmp r0, #1
    bne prompt_p

prompt_q:
    ldr r0, =msg_q
    bl printf
    ldr r0, =scan_format
    ldr r1, =q
    bl scanf
    ldr r5, =q
    ldr r5, [r5]

    mov r0, r5
    bl isPrime
    cmp r0, #1
    bne prompt_q

    cmp r4, r5
    beq prompt_q

    mul r6, r4, r5

    sub r7, r4, #1
    sub r8, r5, #1
    mov r9, r7
    mul r7, r9, r8

prompt_e:
    ldr r0, =msg_e
    bl printf
    ldr r0, =scan_format
    ldr r1, =e
    bl scanf
    ldr r8, =e
    ldr r8, [r8]

    mov r0, r8
    mov r1, r7
    bl cpubexp

    mov r0, r8
    mov r1, r7
    bl cprivexp
    mov r9, r0

    ldr r0, =msg_pub
    mov r1, r6
    mov r2, r8
    bl printf

    ldr r0, =msg_priv
    mov r1, r9
    bl printf

    ldr r0, =0
    bl fflush

    b menu

/* ------------------------------------ */
/* Encrypt Message */
encrypt_message:
    ldr r0, =msg_input_plaintext
    bl printf
    ldr r0, =scan_string_format
    ldr r1, =plaintext
    bl scanf

    ldr r0, =file_encrypted
    ldr r1, =mode_write
    bl fopen
    mov r10, r0

    ldr r1, =plaintext
encrypt_loop:
    ldrb r2, [r1], #1
    cmp r2, #0
    beq encrypt_done

    mov r0, r2
    mov r1, r8
    mov r2, r6
    bl encrypt
    mov r3, r0

    ldr r0, =format_int
    mov r1, r10
    mov r2, r3
    bl fprintf

    b encrypt_loop

encrypt_done:
    mov r0, r10
    bl fclose
    b menu

/* ------------------------------------ */
/* Decrypt Message */
decrypt_message:
    ldr r0, =file_encrypted
    ldr r1, =mode_read
    bl fopen
    mov r10, r0

    ldr r0, =file_plaintext
    ldr r1, =mode_write
    bl fopen
    mov r11, r0

decrypt_loop:
    ldr r0, =format_int
    mov r1, r10
    ldr r2, =cipher_buffer
    bl fscanf

    cmp r0, #1
    bne decrypt_done

    ldr r0, =cipher_buffer
    ldr r0, [r0]
    mov r1, r9
    mov r2, r6
    bl decrypt
    mov r3, r0

    ldr r0, =format_char
    mov r1, r11
    mov r2, r3
    bl fprintf

    b decrypt_loop

decrypt_done:
    mov r0, r10
    bl fclose
    mov r0, r11
    bl fclose
    b menu

/* ------------------------------------ */
/* Exit Program */
exit_program:
    pop {r4-r12, pc}

/* ------------------------------------ */
.data
menu_text: .asciz "Select an option:\n1 - Generate Public and Private Keys\n2 - Encrypt a Message\n3 - Decrypt a Message\n4 - Exit\n"
scan_format: .asciz "%d"
scan_string_format: .asciz "%s"
menu_choice: .word 0

msg_p: .asciz "Enter prime number p: "
msg_q: .asciz "Enter prime number q: "
msg_e: .asciz "Enter public exponent e: "
msg_pub: .asciz "Public Key (n=%d, e=%d)\n"
msg_priv: .asciz "Private Key d = %d\n"

msg_input_plaintext: .asciz "Enter a plaintext message (no spaces): "
plaintext: .space 256

file_encrypted: .asciz "encrypted.txt"
file_plaintext: .asciz "plaintext.txt"
mode_write: .asciz "w"
mode_read: .asciz "r"

format_int: .asciz "%d\n"
format_char: .asciz "%c"
cipher_buffer: .word 0

p: .word 0
q: .word 0
e: .word 0
