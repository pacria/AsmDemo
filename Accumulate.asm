DATAS SEGMENT
    ARR DW 71, 32, 13, 14, 35, 26, 117, 28, 99
    LEN DW $-ARR
    SUM DW ?    
    LIST DW 3, 6, 7, 2, 1, 76  
    COUNT DW $-LIST
    RESULT DW ?
    TABLE DW 3 DUP(0)
DATAS ENDS

CODES SEGMENT 
    
    
    MAIN PROC FAR  
        ASSUME DS:DATAS, CS:CODES
        MOV AX, DATAS
        MOV DS, AX 
        
        MOV TABLE, OFFSET ARR
        MOV TABLE+2, OFFSET LEN
        MOV TABLE+4, OFFSET SUM
        LEA BX, TABLE
        
        CALL AC 
        
        MOV TABLE, OFFSET LIST
        MOV TABLE+2, OFFSET COUNT
        MOV TABLE+4, OFFSET RESULT 
        LEA BX, TABLE
        
        CALL AC
        
        MOV AX, 4C00H
        INT 21H
        
        MAIN ENDP
    
    AC PROC NEAR
        PUSH AX
        PUSH CX
        PUSH SI
        PUSH DI
        
        XOR AX, AX
        MOV DI, [BX+2]
        MOV CX, [DI]
        SHR CX, 1
        MOV DI, [BX+4]
        MOV SI, [BX]
        
        NEXT: ADD AX, ARR[SI]
        ADD SI, 2
        
        LOOP NEXT
        MOV [DI], AX
        
        POP DI
        POP SI
        POP CX
        POP AX
        RET
        AC ENDP
    
   
    
    
    
CODES ENDS
    END MAIN
    
    