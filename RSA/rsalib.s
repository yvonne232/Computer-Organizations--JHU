.text

.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt
.global isPrime

/* ------------------------------------ */
/* gcd: Find greatest common divisor */
gcd:
    push {r2, lr}
gcd_loop:
    cmp r1, #0
    beq gcd_done
    mov r2, r1
    mov r3, r0
    bl modulo
    mov r0, r2
    mov r1, r3
    b gcd_loop
gcd_done:
    pop {r2, pc}

/* ------------------------------------ */
/* pow: Modular exponentiation */
pow:
    push {r3-r7, lr}
    mov r3, r0      @ base
    mov r4, r1      @ exponent
    mov r5, r2      @ modulus
    mov r6, #1      @ result = 1

pow_loop:
    cmp r4, #0
    beq pow_done
    ands r7, r4, #1
    beq skip_mul
    mov r7, r6
    mul r6, r7, r3
    mov r0, r6
    mov r1, r5
    bl modulo
    mov r6, r0
skip_mul:
    mov r7, r3
    mul r3, r7, r7
    mov r0, r3
    mov r1, r5
    bl modulo
    mov r3, r0
    lsrs r4, r4, #1
    b pow_loop

pow_done:
    mov r0, r6
    pop {r3-r7, pc}

/* ------------------------------------ */
/* modulo: manual remainder operation */
modulo:
    push {r2, r3, lr}
    mov r2, r0
    mov r3, r1
    bl __aeabi_idiv
    mul r1, r0, r3
    sub r0, r2, r1
    pop {r2, r3, pc}

/* ------------------------------------ */
/* cpubexp: validate e */
cpubexp:
    push {r2, lr}
    cmp r0, #1
    ble cpubexp_invalid
    cmp r0, r1
    bge cpubexp_invalid
    mov r2, r1
    bl gcd
    cmp r0, #1
    bne cpubexp_invalid
    pop {r2, pc}

cpubexp_invalid:
    b cpubexp_invalid

/* ------------------------------------ */
/* cprivexp: Compute d (fixed correct modular inverse) */
cprivexp:
    push {r2-r7, lr}

    mov r2, r0      @ e
    mov r3, r1      @ phi
    mov r4, #1      @ d candidate

find_d_loop:
    mul r5, r2, r4   @ e * d
    mov r0, r5
    mov r1, r3
    bl modulo
    cmp r0, #1
    beq found_d
    add r4, r4, #1
    b find_d_loop

found_d:
    mov r0, r4
    pop {r2-r7, pc}

/* ------------------------------------ */
/* encrypt: Ciphertext = (plaintext ^ e) mod n */
encrypt:
    bl pow
    bx lr

/* ------------------------------------ */
/* decrypt: Plaintext = (ciphertext ^ d) mod n */
decrypt:
    bl pow
    bx lr

/* ------------------------------------ */
/* isPrime: Check if number is prime */
isPrime:
    push {r1-r4, lr}
    cmp r0, #2
    blt not_prime
    mov r1, #2
    mov r2, r0
    lsrs r2, r2, #1
prime_loop:
    cmp r1, r2
    bgt prime_success
    mov r3, r0
    mov r4, r1
    bl modulo
    cmp r0, #0
    beq not_prime
    add r1, r1, #1
    b prime_loop
prime_success:
    mov r0, #1
    pop {r1-r4, pc}
not_prime:
    mov r0, #0
    pop {r1-r4, pc}
