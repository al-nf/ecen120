;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    October 22, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		bl config
		mov r0, #0
		mov r4, #0
		ldr r2, =buff
		ldr r3, =eob
		
loop			
		bl	read_jstick ; jstick stored in r0
		cmp r0, r4
		mov r4, r0
		
		beq	loop
		bl decode_stick ; puts some char in r0
		
		cmp r0, #0
		beq	resetr4
		
		str r0, [r2]
		add r2, #1
		cmp r2, r3
		beq endless
		
		b	loop

resetr4	mov r4, #0
		b loop

endless b endless
		
		ENDP
			
			
config	PROC
		ldr r0, =(RCC_BASE + RCC_AHB2ENR)
		ldr r1, [r0]
		orr r1, #0x1
		str r1, [r0]
		
		ldr r0, =(GPIOA_BASE + GPIO_MODER)
		ldr r1, [r0]
		bic r1, #0xff ; 0b1100 1111 1111
		bic r1, #0xc00
		str r1, [r0]
		
		ldr r0, =(GPIOA_BASE + GPIO_PUPDR)
		ldr r1, [r0]
		bic r1, #0xff
		bic r1, #0xc00
		orr r1, #0xaa
		orr r1, #0x800
		str r1, [r0]
		
		bx	lr
		ENDP
			
read_jstick	PROC
		ldr r0, =(GPIOA_BASE + GPIO_IDR)
		ldr r0, [r0]
		and r0, #0x2f
		
		bx	lr
		ENDP
			
decode_stick	PROC
		cmp r0, #0x1
		bne nextc
		mov r0, #'c'
		bx lr
nextc	cmp r0, #0x2
		bne nextl
		mov r0, #'l'
		bx lr
nextl	cmp r0, #0x4
		bne nextr
		mov r0, #'r'
		bx lr
nextr	cmp r0, #0x8
		bne nextu
		mov r0, #'u'
		bx lr
nextu	cmp r0, #0x20
		bne nothing
		mov r0, #'d'
nothing	bx	lr
		ENDP
		
			ALIGN					
			AREA    myData, DATA, READWRITE
			ALIGN	

buff dcb	0, 0, 0, 0, 0
eob
	END
