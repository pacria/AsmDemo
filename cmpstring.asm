DATA SEGMENT
    STR1 DB 'HELLO WORLD!'
    STR2 DB 'HELLO WORLD!'
    COUNT DW 12
    FLAG DB 0
DATA ENDS

CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA, ES:DATA
    
START:
    MOV AX, DATA
    MOV DS, AX  
    MOV ES, AX
    
    LEA BX, FLAG
    LEA SI, STR1
    LEA DI, STR2
    
    MOV CX, COUNT
    
    CLD         ;Increament DF=0
    REPE CMPSB  ;Loop condition: Cx != 0 And ZF = 1
    JZ NEXT1
    
    MOV BYTE PTR[BX], 00H           ; FLAG = 0
    JMP STOP   
    
NEXT1: 
    MOV BYTE PTR[BX], 0FFH          ; FLAG = 1

STOP:
    MOV AH, 4CH
    INT 21H 
CODE ENDS
    END STOP
    END NEXT1
    END START
    
    