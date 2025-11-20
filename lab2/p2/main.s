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

		LDR r0, =arr	
		MOV r1, #12
		ADD r5, #1
		ADD r3, r0, #4
		
loop	LDR r2, [r3]
		ADD r2, #5
		STR r2, [r3]
		ADD r5, #1
		CMP r5, #7
		BEQ endless
		ADD r3, #4
		B loop
		
endless B		endless
		ENDP
			
		ALIGN
arr		DCD 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
	
			END
