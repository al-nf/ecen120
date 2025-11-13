        area main, CODE, READONLY
        export __main
        entry

__main proc
        ldr     r0, =array ; Pointer to array of string pointers
        ldr     r1, =10    ; Number of items in array
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
        push    {r4, r5, r6}
        mov     r4, r0 ; store address of first element for later
        mov     r5, r0 ; assume r0 is the location of the smallest element
        ldr     r6, =eoa
        ldr     r3, [r0] ; min value
loop2   add     r0, #4
        cmp     r0, r6
        beq     exit2
        
        ldr     r2, [r0]
        cmp     r2, r3
        bge     nothing
        ldr     r3, [r0]
        mov     r5, r0 ; store address of the smallest element
nothing b       loop2
exit2   ldr     r2, [r4] ; temporarily store first element for swapping
        str     r3, [r4]
        str     r2, [r5]
        pop     {r4, r5, r6}
        bx      lr
        endp

        align
        area mydata, data, readonly

array   dcd 9, 2, 5, 1, 8, 6, 7, 0, 3, 4
eoa
        end