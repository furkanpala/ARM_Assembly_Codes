LIMIT   EQU 120	; Define LIMIT as 120

                            AREA arrays, data, readwrite
                            ALIGN
prime_numbers_arr_begin     SPACE   (LIMIT + 1) * 4		; Reserve zeroed space with size (LIMIT + 1) * 4 bytes for prime numbers array
prime_numbers_arr_end   
is_prime_number_arr_begin   SPACE   LIMIT + 1			; Reserve zeroed space with size LIMIT + 1 bytes for is_prime_number array
is_prime_number_arr_end									; Since these are boolean values (either 0 or 1), 1 byte for each value is enough
								

        AREA sieve_algorithm, code, readonly
        ENTRY
        THUMB
        ALIGN
sieve   FUNCTION
        MOVS r1, #0     ; Using r1 as i for loop 1. i = 0
        B check1        ; Branch to check for loop 1
loop1   MOVS r2, r1     ; Move r1 to r2
        LSLS r2, #2     ; Multiply r2 by 4. Because word size for prime numbers array is 4 bytes
        MOVS r3, #0     ; Move 0 to r3
        STR r3, [r5,r2] ; primeNumbers[i] = 0
        MOVS r3, #1     ; Move 1 to r3
        STRB r3, [r6,r1] ; isPrimeNumber[i] = 1 (true)
        ADDS r1, #1     ; i = i + 1
check1  CMP r1, r0      ; Compare i with LIMIT
        BLE loop1       ; If i <= LIMIT, branch to loop1
        MOVS r1, #2     ; Move 2 to r1. Using r1 as i for loop 2. i = 2
        B check2        ; Branch to check for loop 2
loop2   LDRB r2, [r6,r1]; Load r2 with isPrimeNumber[i]
        CMP r2, #0      ; Compare isPrimeNumber[i] with false
        BEQ skip2       ; If isPrimeNumber[i] is false, skip this iteration and branch to skip2
        MOVS r2, r1     ; Move r1 to r2. Using r2 as j for loop 3
        MULS r2, r1, r2 ; j <= i * i
        B check3        ; Branch to check for loop 3
loop3   MOVS r3, #0     ; Move 0 to r3
        STRB r3, [r6,r2]; isPrimeNumbers[j] = 0 (false)
        ADDS r2,r1      ; j = j + i
check3  CMP r2,r0       ; Compare j with LIMIT
        BLE loop3       ; If j <= LIMIT, branch to loop 3
skip2   ADDS r1, #1     ; i = i + 1
check2  MOVS r2,r1      ; Move i to r2
        MULS r2,r1,r2   ; r2 <= i * i
        CMP r2,r0       ; Compare i * i with LIMIT
        BLE loop2       ; If i * i <= LIMIT, branch to loop 2
        MOVS r1, #0     ; index <= 0
        MOVS r2, #2     ; i <= 2
        B check4        ; Branch to check for loop 4
loop4   LDRB r3, [r6,r2]; r3 <= isPrimeNumber[i]
        CMP r3, #0      ; Compare isPrimeNumber[i] with false
        BEQ skip4       ; If isPrimeNumber[i] is false, skip this iteration and branch to skip4
        MOVS r3, r1     ; Move index to r3
        LSLS r3, #2     ; Multiply r3 by 4. Because word size for primeNumbers array is 4 bytes
        STR r2, [r5, r3]; primeNumbers[index] = i
        ADDS r1, #1     ; index++
skip4   ADDS r2, #1     ; i++
check4  CMP r2, r0      ; Compare i with LIMIT
        BLE loop4       ; If i <= LIMIT, branch to loop 4
        BX lr           ; Return
        ENDFUNC

        ALIGN
__main  FUNCTION
	EXPORT __main			    ; Export main function
        LDR r5, =prime_numbers_arr_begin    ; r5 <= start address of prime numbers array
        LDR r6, =is_prime_number_arr_begin  ; r6 <= start address of isPrimeNumber array
        LDR r0, =LIMIT                      ; r0 <= LIMIT. r0 is parameter register for sieve function
        BL sieve                            ; Call sieve function
stop    B stop          		    ; while(1)
        ENDFUNC
        END