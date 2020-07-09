DATAS SEGMENT
    ;此处输入数据段代码  
    MODE DB 02H
     A DW L0, L1, L2, L3, L4, L5, L6, L7
     
     S0 DB '0 $'
     S1 DB '1 $'
     S2 DB '2 $'
     S3 DB '3 $'
     S4 DB '4 $'
     S5 DB '5 $'
     S6 DB '6 $'
     S7 DB '7 $'
     
     OVER_MARK DB 0DH, 0AH, 'OVER$'
     
     ;1 -> '31H'
     ;2 -> '32H'
     ;3 -> '33H'
     ;4 -> '34H'
     ;5 -> '35H'
     ;6 -> '36H'
     ;7 -> '37H'
     
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码  
GETNUM:    

    MOV AL, MODE
    
    CMP AL, 0
    JB GETNUM 
    
    CMP AL, 8
    JA GETNUM
    
    AND AX, 000FH
    SHL AX, 1
    MOV BX, AX
    JMP A[BX]
    
    L0: LEA DX, S0
    JMP CEND
    
    L1: LEA DX, S1
    JMP CEND
    
    L2: LEA DX, S2
    JMP CEND
    
    L3: LEA DX, S3
    JMP CEND
    
    L4: LEA DX, S4
    JMP CEND
    
    L5: LEA DX, S5
    JMP CEND
    
    L6: LEA DX, S6
    JMP CEND
    
    L7: LEA DX, S7
    JMP CEND

CEND:
    MOV AH, 9
    INT 21H
    
    MOV DX,OFFSET OVER_MARK  
    
    MOV AH, 9
    INT 21H
    
    MOV AH, 4CH
    INT 21H
CODES ENDS


