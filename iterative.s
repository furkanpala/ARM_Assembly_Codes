index 		EQU 6	; Define index as 6

			AREA	array, DATA, readwrite	; Define this area as data part in read-write memory
			ALIGN
arr_begin	SPACE	(index + 1) * 4	; Reserve a zeroed block of memory with size of index * 4 bytes
arr_end

			AREA iterative_factorial, CODE, readonly	; Define this area as code part in readonly memory
			ENTRY
			THUMB
				
			ALIGN
factorial	FUNCTION
			PUSH {r2,r3,r4,r6}	; Push modified registers r2,r3,r4,r6 to stack
			MOVS r2, #0 		; Move 0 to r2
			MOVS r3, #1			; Move 1 to r3
			STR r3, [r1] 		; arr[0] = 0
			MOVS r2, #1			; Move 1 to r2. I am using r2 as i of for loop
			B	check			; Branch to loop check
loop		MOVS r3,r2			; r3 <= i
			LSLS r3, #2			; Multiply index value by 4 because word size is 4 bytes
			SUBS r4, r3, #4 	; r4 <= i - 1
			LDR r6, [r1, r4]	; r6 <= arr[i - 1]
			MULS r6, r2, r6		; r6 <= i * arr[i - 1]
			STR r6,[r1,r3]		; arr[i] = r6
			ADDS r2, #1			; i = i + 1
check		CMP r2, r0			; Compare i with n
			BLE loop			; If i <= n, branch to loop
			POP {r2,r3,r4,r6}	; Pop modified registers r2,r3,r4,r6 from stack
			BX LR
			ENDFUNC
				
				
			ALIGN 4
__main		FUNCTION
			EXPORT __main		; Export main function
			
			LDR r5, =arr_begin	; Load start address of the array to r5
			LDR r0, =index		; Load index value to r0
			MOVS r1, r5			; Move r5 to r1 since r1 is a parameter register
			BL factorial		; Call factorial function
stop		B stop				; while(1)
			ENDFUNC
			END
			