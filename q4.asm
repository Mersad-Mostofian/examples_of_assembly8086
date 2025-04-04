.MODEL SMALL
.STACK 64
.DATA
    Is_negative DW ?
    err_msg DB 0DH, 0AH,"Error: Reader read nan value!$"
    newline DB 0DH, 0AH,"$"
    num DB 10 DUP(?)
    arr_index DB 0
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX    
    
    CALL READ_NUM      
    MOV DX, OFFSET newline
    CALL PRINT_STRING
    CALL PRINT 
    MOV AX,4CH
    INT 21H
MAIN ENDP 




READ_NUM PROC
    MOV Is_negative, 0
read:
    MOV AH,1
    INT 21H
    
    CMP AL, 0AH
    JE endl_detect
    CMP AL, 0DH
    JE endl_detect
    
    CMP AL, '-'
    JE negative_sign_detect
    
    
    SUB AL, '0'
    CMP AL, 9
    JA not_a_number 
    
    MOV BL, arr_index
    MOV [num+BX], AL
    INC arr_index
    JMP read 
    
endl_detect:
    RET
not_a_number:
    MOV DX, OFFSET err_msg
    CALL PRINT_STRING
    RET    
negative_sign_detect:
    MOV Is_negative, 1
    JMP read
    
READ_NUM ENDP



PRINT PROC
    MOV BL, arr_index
    MOV CX, Is_negative   
    DEC BL             
    
    CMP CX, 0
    JE positive
_loop:
    CMP BL, 0          
    JL done            

    MOV DL, [num + BX]  
    ADD DL, '0'         
    MOV AH, 2           
    INT 21H             

    DEC BL              
    JMP _loop 

done:
    RET 
    
positive:
    MOV DL,'-'
    MOV AH, 2           
    INT 21H
    JMP _loop
PRINT ENDP

PRINT_STRING PROC
    MOV AH, 09H            
    INT 21H
    RET
PRINT_STRING ENDP

END MAIN