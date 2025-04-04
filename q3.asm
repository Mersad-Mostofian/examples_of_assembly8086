.MODEL SMALL
.STACK 64
.DATA
    n DW 4
    array DW 1,2,5,7
    result DW ?
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    
    CALL Func 
    MOV AX, result
    CALL PRINT
    
    MOV AX,4CH
    INT 21H
MAIN ENDP

Func PROC
    MOV SI, 0
    MOV BP, 1
    MOV CX, n
    MOV BX, 0
_loop:
    MOV AX,array[SI]
    MUL BP
    ADD BX, AX
    ADD BP, 1
    ADD SI, 2
    DEC CX
    CMP CX,0
    JE done 
    JMP _loop
done:
    MOV [result], BX
    RET  
    
    
    
PRINT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    CMP AX, 0
    JNE convert
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP exit_print

convert:
    MOV CX, 0

convert_loop:
    CMP AX, 0
    JE print_digits

    MOV DX, 0
    MOV BX, 10
    DIV BX
    PUSH DX
    INC CX
    JMP convert_loop

print_digits:
    CMP CX, 0
    JE exit_print

    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    DEC CX
    JMP print_digits

exit_print:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT ENDP


END MAIN
