.MODEL SMALL 
.STACK 64
.DATA

    empty DB "   $"
    x_sign DB " X $"
    o_sign DB " O $"
    line   DB 0DH, 0AH, "---|---|---$"
    wall   DB "|$"  
    move_msg DB 0DH, 0AH, "move:$"
    err_msg DB 0DH, 0AH, "Error: You must enter index from 1 to 3!$" 
    err_print DB 0DH, 0AH, "Error: invalid character!$"
    err_fill DB 0DH, 0AH, "Error: You must enter empty position!$" 
    winner_msg DB 0DH, 0AH, "win!$"
    draw_msg DB 0DH, 0AH, " Draw!$"
    newline DB 0DH, 0AH, "$"
    matrix DB 9 DUP('E')
    Is_end_game DB 0
    Is_draw DB 0
    row DB ?
    col DB ?
    turn DB ?

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX    
    ;turn = 0 means X's turn and turn = 1 means O's turn 
    MOV turn, 0
    CALL PRINT_BOARD
_loop:
    MOV DX, OFFSET move_msg
    CALL PRINT_STRING
    CALL READ
    
    MOV AL, [row]
    DEC AL
    MOV CL, 3
    MUL CL
    ADD AL, col
    DEC AL
    CMP turn, 0
    JE turn_zero
    CMP turn, 1
    JE turn_one
continue:
    CALL PRINT_BOARD
    MOV DX, OFFSET newline      
    CALL PRINT_STRING
    XOR turn, 1
    CALL CHECK_END_GAME
    CMP Is_draw, 1
    JE exit_draw
    CMP Is_end_game, 1
    JE exit_win
    JMP _loop 

exit_draw:
    CMP Is_end_game, 1
    JE exit_win
    MOV DX, OFFSET draw_msg      
    CALL PRINT_STRING
    JMP exit
exit_win:
    CMP turn,0
    JE print_win_O
    JMP print_win_X
print_win_O:
    MOV DX, OFFSET o_sign      
    CALL PRINT_STRING
    MOV DX, OFFSET winner_msg      
    CALL PRINT_STRING
    JMP exit
print_win_X:
    MOV DX, OFFSET x_sign      
    CALL PRINT_STRING
    MOV DX, OFFSET winner_msg      
    CALL PRINT_STRING
    JMP exit
exit:      
    MOV AX, 4CH
    INT 21H

turn_zero:     
    MOV SI, AX
    MOV [matrix + SI], 'X'
    JMP continue 

turn_one:               
    MOV SI, AX
    MOV [matrix + SI], 'O'
    JMP continue
    
MAIN ENDP 


READ PROC
    MOV BL, 0
    MOV CL, 0
read1:
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    CMP AL, 1
    JL not_valid1
    CMP AL, 3
    JG not_valid1
    MOV [row], AL ;read row 

read2:
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    CMP AL, 1
    JL not_valid1
    CMP AL, 3
    JG not_valid1          
    MOV [col], AL ;read col  
    
check_valid:
    XOR SI, SI
    MOV AL, [row]
    DEC AL
    MOV CL, 3
    MUL CL
    ADD AL, col
    DEC AL
    MOV SI, AX
    MOV DL, [matrix + SI]
    CMP DL, 'X'
    JE x_fill
    CMP DL, 'O'
    JE o_fill
    MOV DX, OFFSET newline      
    CALL PRINT_STRING
    RET
    
x_fill:
MOV DX, OFFSET err_fill      
CALL PRINT_STRING
MOV DX, OFFSET newline      
CALL PRINT_STRING
MOV DX, OFFSET move_msg      
CALL PRINT_STRING
JMP read1

o_fill:
MOV DX, OFFSET err_fill      
CALL PRINT_STRING
MOV DX, OFFSET newline      
CALL PRINT_STRING
MOV DX, OFFSET move_msg      
CALL PRINT_STRING
JMP read1 

not_valid1:
    MOV DX, OFFSET err_msg
    CALL PRINT_STRING
    JMP read1   

not_valid2:
    MOV DX, OFFSET err_msg
    CALL PRINT_STRING
    JMP read2   

READ ENDP

PRINT_BOARD PROC
    MOV SI, 0
    XOR CL, CL            
    XOR BL, BL            
print_row:
    CMP BL, 3             
    JE print_reset_row

print_cell:
    MOV AL, [matrix + SI] 
    INC SI                

    CMP AL, 'E'           
    JE  print_empty

    CMP AL, 'X'           
    JE  print_X

    CMP AL, 'O'           
    JE  print_O

    JMP continue_print

print_empty:
    MOV DX, OFFSET empty
    CALL PRINT_STRING
    JMP continue_print

print_X:
    MOV DX, OFFSET x_sign
    CALL PRINT_STRING
    JMP continue_print

print_O:
    MOV DX, OFFSET o_sign
    CALL PRINT_STRING
    JMP continue_print

continue_print:      
    INC CL                
    CMP CL, 3             
    JE print_reset_row
    MOV DX, OFFSET wall   
    CALL PRINT_STRING
    JMP print_cell

print_reset_row:
    MOV DX, OFFSET newline
    CALL PRINT_STRING     

    INC BL                
    XOR CL, CL            
    CMP BL, 3             
    JE return
    MOV DX, OFFSET line 
    CALL PRINT_STRING
    MOV DX, OFFSET newline      
    CALL PRINT_STRING
    JMP print_row

return:
    MOV DX, OFFSET newline
    CALL PRINT_STRING
    RET
PRINT_BOARD ENDP

PRINT_STRING PROC
    MOV AH, 09H            
    INT 21H
    RET
PRINT_STRING ENDP

CHECK_END_GAME PROC
    MOV SI, 0
    CALL CHECK_ROW
    MOV SI, 3
    CALL CHECK_ROW
    MOV SI, 6
    CALL CHECK_ROW
    
    MOV SI, 0
    CALL CHECK_COL
    MOV SI, 1
    CALL CHECK_COL
    MOV SI, 2
    CALL CHECK_COL
    
    MOV SI, 0
    CALL CHECK_BACK_SLASH
    MOV SI, 2
    CALL CHECK_SLASH
    
    CALL CHECK_DRAW
    
    RET
CHECK_END_GAME ENDP

CHECK_ROW PROC
    MOV AL, [matrix+SI]
    CMP AL, 'E'
    JE _check_next_row
    MOV BL, AL
    MOV AL, [matrix+SI+1]
    CMP AL, BL
    JNE _check_next_row
    MOV AL, [matrix + SI+2]
    CMP AL, BL          
    JNE _check_next_row
    
    JMP end_game_row
    
    
_check_next_row:
    RET
    
end_game_row:
    MOV Is_end_game, 1
    RET
    
CHECK_ROW ENDP 

CHECK_COL PROC
    MOV AL, [matrix+SI]
    CMP AL, 'E'
    JE _check_next_col
    MOV BL, AL
    MOV AL, [matrix+SI+3]
    CMP AL, BL
    JNE _check_next_col
    MOV AL, [matrix + SI+6]
    CMP AL, BL          
    JNE _check_next_col
    
    JMP end_game_col
    
_check_next_col:
    RET
end_game_col:
    MOV Is_end_game, 1
    RET
CHECK_COL ENDP


CHECK_BACK_SLASH PROC
    MOV AL, [matrix+SI]
    CMP AL, 'E'
    JE faild_back_slash
    MOV BL, AL
    MOV AL, [matrix+SI+4]
    CMP AL, BL
    JNE faild_back_slash
    MOV AL, [matrix + SI+8]
    CMP AL, BL          
    JNE faild_back_slash
    
    JMP end_game_back_slash
    
faild_back_slash:
    RET
end_game_back_slash:
    MOV Is_end_game, 1
    RET
CHECK_BACK_SLASH ENDP

CHECK_SLASH PROC
    MOV AL, [matrix+SI]
    CMP AL, 'E'
    JE faild_slash
    MOV BL, AL
    MOV AL, [matrix+SI+2]
    CMP AL, BL
    JNE faild_slash
    MOV AL, [matrix + SI+4]
    CMP AL, BL          
    JNE faild_slash
    
    JMP end_game_slash
    
faild_slash:
    RET
end_game_slash:
    MOV Is_end_game, 1
    RET
CHECK_SLASH ENDP


CHECK_DRAW PROC
    MOV SI, 0
    MOV CX, 0 
_loop_draw:
    MOV AL, [matrix+SI]
    CMP AL, 'E'
    JE not_draw
    INC CX
    INC SI
    CMP CX,9
    JE draw
    JMP _loop_draw
not_draw:
    RET  
draw:
    MOV Is_end_game, 1
    MOV Is_draw, 1
    RET
CHECK_DRAW ENDP
    

END MAIN