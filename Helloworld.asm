

DATA SEGMENT
    
    A DB 'hello, world'
    
DATA ENDS

CODE SEGMENT 
    ASSUME DS:DATA, CS:CODE
    

START:
    
    MOV AX, DATA
    MOV DS, AX     ;Init DATA(Basic Work)
    
    LEA BX, A
    MOV CX, 12
LP:
    MOV AH, 2      ;Single char output AH <- 02H, DL -> Screen
    MOV AL, [BX]
    XCHG AL, DL
    INC BX
    INT 21H  
    LOOP LP        ;Loop CX times
    
    MOV AH, 4CH    ;Finished
    INT 21H

CODE ENDS
    END START

