;******************** (C) Alan Fung **********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 8, 2025
; @note
;*********************************************************************************
	
		AREA main, CODE, READONLY
		EXPORT __main
		ENTRY

__main PROC
		LDR r0, =array
		MOV r1, #0
		ADD r2, r0, #40
loop	LDR r3, [r0]
		MLA r1, r3, r3, r1
		ADD r0, #4
		CMP r0, r2
		BNE loop
		
		LDR r4, =result
		STR r1, [r4]

endless B		endless
		ENDP
			
		ALIGN
array	DCD		1, -5, 2, 1, 1, 0, 10, 0, -2, -1
result	DCD		0
			END
