.MODEL SMALL
.STACK 256
.DATA
    n DW 10
    result DW ?
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AX,n
    CALL FIB
    MOV [result], AX
    CALL PRINT
    
    MOV AX,4CH
    INT 21H
MAIN ENDP 




FIB PROC 
    PUSH BP         
    MOV BP, SP      
    SUB SP, 2       

    CMP AX, 0
    JE end_zero
    CMP AX, 1
    JE end_one      

    MOV [BP-2], AX  

    DEC AX          
    CALL FIB
    PUSH AX         

    MOV AX, [BP-2]  
    SUB AX, 2       
    CALL FIB

    POP BX          
    ADD AX, BX      

    ADD SP, 2       
    POP BP         
    RET

end_zero:
    MOV AX, 0
    ADD SP, 2
    POP BP
    RET

end_one:
    MOV AX, 1
    ADD SP, 2
    POP BP
    RET
FIB ENDP



PRINT PROC
    CMP AX, 0
    JNE convert
    MOV DL, '0'        
    MOV AH, 02H
    INT 21H
    RET

convert:
    MOV CX, 0
    MOV DX, 0

label1:
    CMP AX, 0
    JE print1

    MOV BX, 10
    DIV BX             

    PUSH DX            
    INC CX             
    XOR DX, DX
    JMP label1

print1:
    CMP CX, 0
    JE exit

    POP DX             
    ADD DL, '0'        
    MOV AH, 02H
    INT 21H

    DEC CX
    JMP print1

exit:
    RET
PRINT ENDP

     END MAIN