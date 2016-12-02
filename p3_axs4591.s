/************************************************************************
* @Asmita Shrestha
* @ID: 1001244591
* @Project3 
************************************************************************/

.global main
.func main

main:
    BL _seedrand            @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable

_writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ _writedone          @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _getrand             @ get a random number
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B  _writeloop           @ branch to next loop iteration
    
_writedone:
    MOV R0, #0              @ initialze index variable
   
_readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ _readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   _readloop            @ branch to next loop iteration
_readdone:
    B _exit                 @ exit if done
_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time 
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 

_getMin:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ minDone		    @ branch to procedure minDone when minimum is found
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R8              @ compare R1 with R8
    MOVLT R8, R1	    @ move R1 to R8 if it is smaller than R8
    ADD R0, R0, #1          @ increment index
    B  _getMin              @ branch to next loop iteration

minDone:
    MOV R0, #0		    @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ R2 now has the element address
    LDR R9, [R2]	    @ store the first element in R9
    ADD R0, R0, #1	    @ increment index
    B  _getMax	            @ branch to procedure _getMax to find maximum
   
    
_getMax:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ maxDone		    @ branch to procedure maxDone when maximum is found
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R9              @ compare R1 with R9
    MOVGT R9, R1	    @ move the value of R1 to R9 if R1 is greater than R9
    ADD R0, R0, #1          @ increment index
    B   _getMax             @ branch to next loop iteration
    
maxDone:
    MOV R0, #0		    @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array
    LSL R2, R0, #2	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ R2 now has the element address
    LDR R10, [R2]	    @ store the first element in R10
    ADD R0, R0, #1	    @ increase the index
    BL _printf	            @ branch to procedure _getSum to find sum
_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    MOV R1, R0
    MOV R2, #1000
    BL _mod_unsigned
    POP {PC}                @ return 

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
   
_mod_unsigned:
    cmp R2, R1          @ check to see if R1 >= R2
    MOVHS R0, R1        @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2        @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0        @ swap R1 and R2 if R2 > R1
    MOV R0, #0          @ initialize return value
    B _modloopcheck     @ check to see if
    _modloop:
        ADD R0, R0, #1  @ increment R0
        SUB R1, R1, R2  @ subtract R2 from R1
    _modloopcheck:
        CMP R1, R2      @ check for loop termination
        BHS _modloop    @ continue loop if R1 >= R2
    MOV R0, R1          @ move remainder to R0
    MOV PC, LR          @ return   

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
.data
.balign 4
a:              .skip       400
printf_str:     .asciz      "a[%d] = %d\n"
debug_str:
.asciz "R%-2d   0x%08X  %011d \n"
results: 	.ascii    "Minimum = %d\nMaximum = %d\nSum = %d\n"
exit_str:       .ascii      "Terminating program.\n"
