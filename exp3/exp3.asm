DATAS SEGMENT
    ;此处输入数据段代码  
    BUF DB 1AH, 22H, 07H, 05H, 03H, 28H, 0FH, 90H, 30H, 15H, 45H, 43H, 56H, 5DH, 2AH, 3FH, 1BH, 52H, 17H, 49H
    ;BUF DB 1AH, 22H
    MAX DB 0
    MIN DB 0  
    
    CRLF DB 0AH, 0DH, '$'  
    
    LIST_CHARS DB 'ALL_LIST:',0DH, 0AH,'$'
    
    MAX_CHARS DB 'MAX:','$'
    
    MIN_CHARS DB 'MIN:', '$'
     
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    
    ;此处输入代码段代码  
START:    
             
    MOV AX,DATAS
    MOV DS,AX  
    
    ; Print 'ALL_LIST'
    LEA DX, LIST_CHARS
    MOV AH, 09H
    INT 21H
    
    
    MOV CL, 14H
    DEC CL        ;shixian 已经进行了一次初始赋值，迭代次数-1
    MOV AH, [SI]
    MOV AL, [SI] 
    
    
    
    MOV DL, [SI]
    CALL SHOW
    
CMPMAX: 
    
    INC SI 
    
    MOV DL, [SI]
    CALL SHOW
    
    CMP AH, [SI]
    JA CMPMIN
    MOV AH, [SI]
    JMP GOON

CMPMIN:
    CMP [SI], AL
    JA GOON
    MOV AL, [SI]

GOON:
    DEC CL
    JNZ CMPMAX 
    
    MOV MAX, AH ;Write to MAX
    MOV MIN, AL ;Write to MIN
        
    LEA DX, MAX_CHARS
    MOV AH, 09H
    INT 21H 
    
    MOV DL, MAX 
    CALL SHOW 
             
    LEA DX, MIN_CHARS
    MOV AH, 09H
    INT 21H
    
    MOV DL, MIN
    CALL SHOW
    
    MOV AH, 4CH
    INT 21H  

PRINT_ASC PROC
    PUSH AX
    
    MOV AL, 0AH
    
    CMP AL, DL
    JA INUM

    ADD DL, 37H
    JMP TEND 
INUM: 
    ADD DL, 30H
    JMP TEND 
    
TEND:
    MOV AH, 2
    INT 21H

    POP AX
    RET
PRINT_ASC ENDP
    
SHOW PROC
    PUSH AX
    PUSH CX
    PUSH DX 
    
    MOV DH, DL    
    AND DL, 0F0H 
    MOV CL, 4
    SHR DL, CL
    CALL PRINT_ASC
 
    
    MOV DL, DH
    AND DL, 0FH
    ;ADD DL, 30H
    CALL PRINT_ASC
      
    
    LEA DX, CRLF
    MOV AH, 9
    INT 21H
    
    POP DX
    POP CX
    POP AX
    RET 
SHOW ENDP

	
        
CODES ENDS  
    END START



