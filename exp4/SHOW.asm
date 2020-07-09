DATAS SEGMENT
    DATA1 DW '97', '44', '77', '47', '40' 
    
    ;DATA2 DW '34', '44', '87', '54', '21'
    LENGTH DB 05H
    ASC DW 5 DUP('00'), '$'
    ;4047774497
    
    HEX1 DB  21H, 23H, 44H, 0F1H
    HEX2 DB  3FH, 12H, 53H, 0AH
    
    RES DB 4 DUP(0)

     
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
    MOV ES,AX 
    
    LEA SI, DATA1
    
    CALL SHOW 
    
    MOV AH, 4CH
    INT 21H
    

SHOW PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
        
    
    LEA DI, ASC
    
    
    MOV CL, LENGTH
    

    MOV DL, 02H ;Constant, 2 bytes every innerloop

OUTERLOOP:
    XOR AX, AX
    
    MOV DH, CL
    DEC DH    
    MOV AL, DH
    MUL DL
    MOV BX, AX
    MOV CH, 02H ;Inner loop times
    
INNERLOOP:
    MOV AL, SI[BX]
    MOV [DI], AL

    INC DI
    INC BX
    DEC CH
    JNZ INNERLOOP

    DEC CL
    JNZ OUTERLOOP
    
    ; Print the ASC
    LEA DX, ASC
    MOV AH, 09H
    INT 21H 
    
    POP DI

    POP DX
    POP CX
    POP BX
    POP AX
    RET 
SHOW ENDP
    
    
  
    

;
;    
;    LEA DX, ASC_BUF
;    MOV AH, 09H       ;Print
;    INT 21H
;    
   

       
CODES ENDS  
    END START


                                                                                                             
