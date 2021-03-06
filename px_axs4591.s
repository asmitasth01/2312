/******************************************************************************
* @Asmita Shrestha
* @ID: 1001244591
* Exam question
* This program implements a simple calculator that supports four different operations
* on floating point numbers.
******************************************************************************/

.global main
.func main


main: 
    BL  _scanf              @ branch to scanf procedure with return
    VMOV S0, R0             @ move return value R0 to FPU register S0
    BL _getchar		    @ branch to scanf procedure with return
    MOV R5, R0              @ move R0 to R5
    MOV R2, R5              @ move R5 to R2
    MOV R0, #0		    @ initialize the value R0 as 0
    BL _compare		    @ calls compare fun
    B main		    @ branch back to main

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_scanfINT:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_strINT  @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    MOV R4, LR
    CMP R2, #'a'            @ compare against the constant char '@'
    BLEQ _ABS               @ branch to equal handler
    CMP R2, #'s'            @ compare against the constant char '@'
    BLEQ _SQUARE_ROOT       @ branch to equal handler
    CMP R2, #'p'            @ compare against the constant char '@'
    BEQ _beforePOW          @ branch to equal handler
    CMP R2, #'i'            @ compare against the constant char '@'
    BLEQ _INVERSE           @ branch to equal handler
    MOV PC, R4
   
_ABS:
    VABS.F32 S1, S0         @ compute S2 = S0 * S1
    VCVT.F64.F32 D4, S1     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    B main		    @ branch to main funtion

_SQUARE_ROOT:
   
    VSQRT.F32 S1, S0        @ compute S2 = S0 * S1
    VCVT.F64.F32 D4, S1     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    B main	 	    @ branch to main funtion
     
_INVERSE:
    MOV R6, #1	  	    @ initialize value of R6 as 1
    VMOV S1, R6		    @ move value of R6 to S1
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
    VDIV.F32 S2, S1, S0     @ compute S2 = S1/S0
    VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    B main		    @ branch to main
    
_beforePOW:
    VMOV.F32 S1, S0	    @ convert S0 to single precision and store in S1
    VMOV.F32 S2, S1	    @ convert S1 to single precision and store in S2
    BL  _scanfINT           @ branch to scanf procedure with return
    MOV R10, R0             @ move return value R0 to FPU register S1
    MOV R0, #1              @ initialze index variable

_startPOW:
    CMP R0, R10		    @ compare R0 and R10
    BEQ _POWER_DONE	    @ branch to Power_done function
    VMUL.F32 S2, S1, S2     @ compute S2 = S1 * S2
    ADD R0, R0, #1          @ increment index
    B _startPOW             @ branch to next loop iteration
	 
_POWER_DONE:

    VCVT.F64.F32 D3, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D3         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    B main		    @ branch to main

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return
    
.data
format_str: 	.asciz	    "%f"
read_char:      .ascii      " "
result_str:	.asciz	   "%f \n"
format_strINT:		.asciz		"%d"



