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
	LDR r0, =num1
	LDR r1, [num1]
	MUL r1, r1, r1
	
	LDR r0, =num2
	LDR r2, [r0]
	MUL r2, r2, r2
	
	ADD r3, r1, r2
	LDR r0, =result
	STR r3, [r0]
		
endless B		endless
		ENDP
			
		ALIGN
num1 	DCD 	0x02
num2 	DCD 	0x03
result 	DCD 	0x01
	
			END
