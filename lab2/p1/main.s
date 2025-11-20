;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 8, 2025
; @note
;*******************************************************************************
	
		AREA main, CODE, READONLY
		EXPORT __main
		ENTRY

__main PROC

		MOV r0, #10 ;count of numbers in array
		LDR r1, =Array1 ;initialize r1 with address of Array1
		LDR r2, =Array2 ;initialize r2 with address of Array2
		MOV r6, #10 ;count # of elements in r

loop 	LDR r3, [r1]
		LDR r4, [r2]
		SUBS r5, r3, r4
		BNE ntequal
		
		ADD r1, r1, #4 ; r1 points to next number in Array1
		ADD r2, r2, #4 ; r2 points to next number in Array2
		SUBS r6, r6, #1
		BNE loop
		
		MOV r5, #1 ; arrays are identical
		B endless
		
ntequal MOV r5, #-1 ; arrays are not identical
endless B endless
		ENDP
			
		ALIGN
Array1 DCD 12, 17, 5, 11, -2, -1, -4, 6, -3, 0 ; ten 32-bit numbers
Array2 DCD 12, 17, 5, 11, -2, -1, -4, 6, -3, 0 ; ten 32-bit numbers
	
		END
