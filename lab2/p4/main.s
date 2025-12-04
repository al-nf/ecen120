;******************** (C) Alan Fung, Gavin Morris ********************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    October 8, 2025
; @note
;*********************************************************************************
	
		AREA main, CODE, READONLY
		EXPORT __main
		ENTRY

__main PROC
		LDR r0, =num1
		LDR r1, [r0]
		LDR r0, =num2
		LDR r2, [r0]
		LDR r0, =num3
		LDR r3, [r0]
		
		CMP r1, r2
		BLT b1
		B b2
		
b1		CMP r1, r3
		BLT endless
		MOV r1, r3
		B endless
		
b2		CMP r2, r3
		BLT b3
		MOV r1, r3
		B endless
		
b3		MOV r1, r2

endless B		endless
		ENDP
			
		ALIGN
num3	DCD	0x03247
num2	DCD 0x05431
num1	DCD 0x02222	
	
			END
