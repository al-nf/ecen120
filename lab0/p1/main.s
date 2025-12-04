;******************** (C) Alan Fung, Gavin Morris ********************************
; @file    main.s
; @author  Alan Fung, Gavin Morris
; @date    September 24, 2025
; @note
;*******************************************************************************

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main PROC

			LDR r0, =0x13
			LDR r1, =0x07
			ADD r2, r0, r1
			EOR r3, r0, r1
endless 	B	endless
				ENDP
					
				END
