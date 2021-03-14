index       EQU 6	; Define index as 6

            AREA factorial_array, data, readwrite
            ALIGN
arr_begin   SPACE (index + 1) * 4	; Reserve zeroed space with size (index + 1) * 4 bytes
arr_end

            AREA recursive_factorial, code, readonly
            ENTRY
            THUMB
            
            ALIGN
factorial   FUNCTION
			PUSH {lr}			; Push link register to stack. Since this is a recursive function we need to store where program left
            CMP r0, #2          ; Compare n with 2 since r0 is used as parameter register. In this case parameter is n
            BGE recursive_call  ; If n >= 2, continue to recursive function call
            MOVS r2, #1			; If n < 2, load 1 to return register
            B return            ; and branch to return phase
recursive_call
			PUSH {r0}			; Push parameter register to stack
            SUBS r0, r0, #1     ; n = n - 1
            BL factorial        ; Call factorial function
			POP {r0}			; Pop parameter register from stack
            MULS r2, r0, r2     ; r2 <= n * factorial(n-1)
return      POP {pc}       	    ; Pop link register and return
            ENDFUNC
            
            ALIGN 2
__main      FUNCTION
			EXPORT __main		; Export main function
            LDR r5, =arr_begin	; Load starting address of array to r5
			LDR r6, =index		; Load index value to r6
            MOVS r0, #0         ; Using r0 as i. i <= 0
            B   check           ; Branch to loop check
loop        BL factorial        ; Call factorial function
            MOVS r3, r0         ; Move r0 to r3
            LSLS r3, #2         ; Multiply i by 4 because word size is 4 bytes
            STR r2, [r5,r3]     ; arr[i] = factorial(i) since r2 is used as return register
            ADDS r0, #1         ; i = i + 1
check       CMP r0, r6      	; Compare i with index
            BLE loop            ; If i is lower or equal then index, branch to loop

stop        B stop              ; while(1)
            ENDFUNC
            END