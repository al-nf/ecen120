        area main, CODE, READONLY
        export __main
        entry

__main proc
        ldr     r0, =strarray ; Pointer to array of string pointers
        ldr     r1, =7    ; Number of items in array
        bl      mysort      ; Call sorting routine
endless b       endless
        endp

; selection sort
mysort proc
        push    {lr, r4, r5, r6, r7}
        mov     r4, r0 ; pointer to array
        mov     r5, r1 ; number of items
        mov     r6, #0 ; counter
        sub     r7, r5, #1 ; we only need to iterate to the second-to-last element

loop1   cmp     r6, r7
        beq     exit1
        mov     r0, r4 ; pointer to array
        mov     r1, r6 ; counter
        bl      compare_and_swap
        add     r6, #1
        b       loop1

exit1   pop     {lr, r4, r5, r6, r7}
        bx      lr
        endp

compare_and_swap proc
        lsl     r1, #2
        add     r0, r1 ; first element
        push    {r4, r5, r6, r7}
        mov     r4, r0 ; store address of first element for later
        mov     r5, r0 ; assume r0 is the location of the smallest element
        ldr     r6, =eoa
        ldr     r3, [r0] ; ptr to min str
loop2   add     r0, #4
        cmp     r0, r6
        beq     exit2
        
        ldr     r2, [r0] ; ptr to current str

        push    {r0, r1, lr}
        mov     r0, r2 ; r0 = cur
        mov     r1, r3 ; r1 = min
        bl      strcmp
        mov     r7, r0
        pop     {r0, r1, lr}


        cmp     r7, #0
        bge     nothing
        ldr     r3, [r0]
        mov     r5, r0 ; store address of the smallest element
nothing b       loop2
exit2   ldr     r2, [r4] ; temporarily store first element for swapping
        str     r3, [r4]
        str     r2, [r5]
        pop     {r4, r5, r6, r7}
        bx      lr
        endp

strcmp  proc
        push    {r4, r5, r6}
strcmp_loop
        ldrb    r4, [r0], #1
        ldrb    r5, [r1], #1
        
        ; Convert r4 to lower if upper
        cmp     r4, #65
        blt     skip_r4
        cmp     r4, #90
        bgt     skip_r4
        add     r4, r4, #32
skip_r4
        ; Convert r5 to lower if upper
        cmp     r5, #65
        blt     skip_r5
        cmp     r5, #90
        bgt     skip_r5
        add     r5, r5, #32  
skip_r5
        cmp     r4, r5       
        bne     strcmp_ne    
        cmp     r4, #0      
        bne     strcmp_loop
        mov     r0, #0    
        pop     {r4, r5, r6}
        bx      lr
strcmp_ne
        sub     r0, r4, r5 
        pop     {r4, r5, r6}
        bx      lr
        endp

        align
        area mydata, data, readonly

strarray    dcd str1, str2, str3, str4, str5, str6, str7
eoa
str1		dcb	"First string",0
str2		dcb	"Second string",0
str3		dcb	"So, do I really need a third string",0
str4		dcb	"Tetraphobia is the fear of the number 4",0
str5		dcb	"A is for apple",0
str6		dcb	"Z is called \'zed\' in Canada",0
str7		dcb	"M is for middle",0
		end