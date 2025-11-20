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

		LDR 	r0, =0x15
		LDR 	r1, =label1
		LDR 	r2, [r1]	; puts 0x6 into r2
		ADD 	r3, r0, r2  ; 0x6 + 0x15
		ADD 	r1, #4		; adds 4 so r1 is now pointing to P1
		LDR 	r4, [r1]	; loads the value of P1 into r4
		ADD 	r3, r4		; adds the value of P1 with r3
endless B		endless
		ENDP
			
		ALIGN
label1 	DCD 	0x06
P1 		DCD 	0x04
	
			END
