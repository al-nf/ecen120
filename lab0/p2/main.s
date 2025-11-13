;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    September 24, 2025
; @note
;*******************************************************************************

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main PROC
		EOR r0, r0, r0
		MOV r2, r0
		ADD r1, r0, #1
		MOV r3, r1
count	ADD r2, r2, r1
		ADD r3, r3, r3
		B	count
endless	B	endless
				ENDP
				END
