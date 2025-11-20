;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 1, 2025
; @note
;*******************************************************************************

	
		AREA main, CODE, READONLY
		EXPORT __main
		ENTRY

__main PROC

		LDR r1, =list
		LDR r2, [r1]
		LSL r2, r2, #1
		STR r2, [r1]
		ADD r1, r1, #4
		LDR r2, [r1]
		LSL r2, r2, #1
		STR r2, [r1]
		ADD r1, r1, #4
		LDR r2, [r1]
		MOV r2, r2, LSL #1
		STR r2, [r1]
endless B		endless
		ENDP
			
		ALIGN
list	DCD 3,4,5
	
			END
