/******************************************************************************
* @Asmita Shrestha
* @ID: 1001244591
* Exam question
******************************************************************************/

.global main
.func main


main:
	  BL  _scanf              @ branch to scanf procedure with return
	  VMOV S0, R0             @ move return value R0 to FPU register S0
	  BL _getchar			  @ branch to scanf procedure with return
	  MOV R5, R0              @move R0 to R5
	 // BL  _scanf              @ branch to scanf procedure with return
	 // VMOV S1, R0             @ move return value R0 to FPU register S1
      MOV R2, R5              @move R5 to R2
	  //VCVT.F64.F32 D1, S0     @ covert the result to double precision for printing

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
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
    BLEQ _ABS           	@ branch to equal handler
    CMP R2, #'s'            @ compare against the constant char '@'
    BLEQ _SQUARE_ROOT            	@ branch to equal handler
    CMP R2, #'p'            @ compare against the constant char '@'
    BLEQ _POW           	@ branch to equal handler
    CMP R2, #'i'            @ compare against the constant char '@'
    BLEQ _INVERSE            	@ branch to equal handler
    MOV PC, R4
   
_ABS:
    VABS.F32 S1, S0     @ compute S2 = S0 * S1
    
    VCVT.F64.F32 D4, S1     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
     BL  _printf_result      @ print the result
	
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return
    
.data
format_str 	.asciz	    "%f"
prompt_str	.asciz	

