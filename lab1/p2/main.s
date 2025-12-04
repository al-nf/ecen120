;******************** (C) Alan Fung, Gavin Morris ********************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    October 1, 2025
; @note
;*******************************************************************************

	
		AREA main, CODE, READONLY
		EXPORT __main
		ENTRY

__main PROC

		LDR r1, =value
		LDR r2, [r1]
		NEG r3, r2
endless B		endless
		ENDP
			
		ALIGN
value	DCD 0xFFFFFFFF
	
			END
