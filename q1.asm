.MODEL SMALL
.STACK 64
.DATA     

RESULT_lcm DW 0H
RESULT_gcd DW 0H
NUM_IN1 DW 6
NUM_IN2 DW 12  
Enter DB 0DH, 0AH,"$"   
msg3 DB 0DH, 0AH,"GCD : $" 
msg4 DB 0DH, 0AH, "LCM : $"

.CODE

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    CALL _GCD   
    MOV RESULT_gcd, AX
            
    ;print msg3
    MOV DX, OFFSET msg3
    MOV AH,9
    INT 21H    
    
    ;print result_gcd
    MOV AX, RESULT_gcd
    CALL PRINT
    
    MOV DX, OFFSET Enter
    MOV AH, 9
    INT 21H
            
    CALL LCM   
    MOV RESULT_lcm, AX
            
    ;print msg4
    MOV DX, OFFSET msg4
    MOV AH,9
    INT 21H    
    
    ;print result_lcm
    MOV AX, RESULT_lcm
    CALL PRINT 
    
    
    ;Exit
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP



_GCD PROC
    MOV AX, NUM_IN1
    MOV BX, NUM_IN2
GCD:
    CMP BX, 0
    JE done_gcd
    
    XOR DX, DX
    DIV BX
    MOV AX,BX
    MOV BX,DX
    JMP GCD 
    
done_gcd:
   RET
_GCD ENDP 


LCM PROC     
    MOV AX, NUM_IN1
    MOV DX, 0
    MUL NUM_IN2
    MOV BX, RESULT_gcd
    DIV BX
    RET    
LCM ENDP    

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