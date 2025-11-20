;******************** (C) Alan Fung ********************************************
; @file    main.s
; @author  Alan Fung
; @date    November 19, 2025
; @note
;*******************************************************************************

	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   
	INCLUDE timer.h
	INCLUDE leds.h
	INCLUDE	dac.h
	INCLUDE adc.h
	IMPORT	sintbl	
	IMPORT	sawtbl		
	
sample_freq	equ	20000		;20KHz sampling rate
sample_per	equ	1000000/sample_freq			
test_freq	equ	600
	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
		bl 		adc_init
		
		ldr		r0,=test_freq	
		bl		calc_phaseinc		;compute the phase increment value (phaseinc)
		ldr		r2,=phaseinc
		str		r0,[r2]				;store the phase increment value in memory
		
		bl		dac_init			;initialize dac
		bl		tim2_init			;initialize timer interrupt
		ldr		r0,=sample_per		;set output rate to 20KHz
		bl		tim2_freq



endless	b		endless		
		ENDP
			
			
TIM2_IRQHandler PROC
		EXPORT	TIM2_IRQHandler
		push	{lr}
		ldr		r0,=phase			;get a pointer to the current phase
		ldr		r1,=sintbl			;Get pointer to waveform table
		bl		get_tblval
		bl		dac_set
		ldr		r1,=phaseinc		;load phase increment
		ldr		r0,=phase			;reload last phase value
		bl		update_phase
		pop		{lr}
		ldr		r2,=(TIM2_BASE+TIM_SR)	;reset pending interrupt for TIM2		
		mov		r1,#~TIM_SR_UIF
		str		r1,[r2]
		dsb
		bx		lr
		ENDP
			
calc_phaseinc	PROC
					; To calculate the phaseinc, take the new frequency (w)/sampling freq.(w0) * 1024
					; to avoid precision issues - we will keep phase in 16ths then divide at the last minute
					; w arrives in r0; phase increment returned in r0
					; works from about 2Hz to sampling freq./2
					; Assumes a wave table size of 1024 and a phase iterator scaled up by 16

 
		ldr		r1, =sample_freq
		ldr		r2, =16
		ldr		r3, =1024
		mul		r0, r0, r2
		mul		r0, r0, r3
		udiv	r0, r0, r1

		bx		lr
		ENDP

update_phase	PROC
					;recieves a pointer to phase in r0 and a pointer to phaseinc in r1
					;adds phaseinc to phase
 
		ldr		r2, [r0]
		ldr		r1, [r1]
		add		r2, r1
		cmp		r2, #16384
		blt		skip
		sub		r2, #16384
skip	str		r2, [r0]

		bx		lr
		ENDP
		
get_tblval		PROC
					;recieves a pointer to phase in r0 and a pointer to a wave table in r1
					;Assume the wave table is 1024 entries; 16-bits each
					;Assume the phase value is in 16ths.
					;Return the sample in r0
				
 
		ldr		r0, [r0]
		ldr		r2, =16
		udiv	r0, r0, r2
		ldr		r2, =2
		mul		r0, r0, r2 
		add		r1, r0
		ldrh	r0, [r1]
		
		push	{r4, lr}
		mov		r4, r0
		mov		r5, r1
		bl		adc_read
		ldr		r1, =4096
		mul		r0, r0, r4
		udiv	r0, r0, r1
		pop		{r4, lr}
		
		bx		lr
		ENDP
			
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			
phase		dcd		0					;maintain in 16ths.
phaseinc	dcd		160	

	END
