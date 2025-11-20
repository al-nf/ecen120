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
		LDR r0, =sequence
		LDR r1, [r0]
		ADD r0, #4
		LDR r2, [r0]
		LDR r3, =numElements
		LDR r3, [r3]
		SUB r3, #2
		MOV r4, #0
		ADD r0, #4
loop	ADD r5, r1, r2
		STR r5, [r0]
		ADD r4, #1
		CMP r4, r3
		BEQ endless
		ADD r0, #4
		MOV r1, r2
		MOV r2, r5
		B loop
			
endless B		endless
		ENDP
			
		ALIGN
numElements	DCD		15
sequence	DCD		0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
			END
