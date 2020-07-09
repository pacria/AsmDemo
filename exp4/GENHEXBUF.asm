DATAS SEGMENT
    DATA1 DW '97', '44', '77', '47', '40' 
    
    ;DATA2 DW '34', '44', '87', '54', '21'
    LENGTH DB 05H
    ASC DW 5 DUP('00'), '$'
    ;4047774497 
    
    HEX_BUF DB 5 DUP(0)
    
    HEX DB 5 DUP(0)
    
    HEX1 DB  21H, 23H, 44H, 0F1H

     
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
    CALL MAKEHEXBUF    
    
    
    MOV AH, 4CH
    INT 21H
    
MAKEHEX PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    LEA SI, HEX_BUF
    LEA DI, HEX
    
    MOV CL, LENGTH
    MOV BX, 0064H
    XOR DX, DX
    
GENHEX:
    MOV BX, [SI]
    MUL DX
    ADD AX, BX
    ADC DX, 0
    

MAKEHEXBUF PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    PUSH DI  
    
 
    LEA DI, HEX_BUF
    
    XOR DX, DX
    XOR BX, BX
    MOV CL, LENGTH

GENHEXBUF:
    MOV CH, 02H
    XOR DX, DX    
    
ASCWTOHEXB:
    MOV AX, 000AH 

    MOV BL, [SI]
    SUB BL, 30H
    MUL DX
    MOV DX, AX    
    ADD DX, BX
    INC SI
    
    DEC CH
    JNZ ASCWTOHEXB
    
    MOV [DI], DX
    INC DI
    DEC CL
    JNZ GENHEXBUF
    
    POP DI

    POP DX
    POP CX
    POP BX
    POP AX
    RET
MAKEHEXBUF ENDP
    
    
    

;ASCTENHEX PROC
;    PUSH AX
;    PUSH BX
;    PUSH CX
;    PUSH DX
;    PUSH SI
;        
;
;    XOR BX, BX
;    XOR DX, DX 
;    
;    MOV AX, 000AH
;    MOV CL, 04H
;    LEA SI, ASC
;    
;DIGIT:  
;    
;    MOV BL, [SI]
;    
;    CMP BL, '0'
;    JB ERROR
;    
;    CMP BL, '9'
;    JA ERROR
;    
;    SUB BL, 30H
;    
;ERROR:
;    MUL DX
;    MOV DX, AX
;    MOV AX, 000AH
;    ADD DX, BX
;    
;    INC SI
;    DEC CL
;    JNZ DIGIT
;    
;    MOV WORD PTR HEX, DX
;        
;    POP SI
;    POP DX
;    POP CX
;    POP BX
;    POP AX
;    RET
;ASCTENHEX ENDP
;      
;    
;HEXASC PROC 
;    PUSH AX
;    PUSH BX
;    PUSH CX
;    PUSH DX
;    
;    MOV CX, 4         ; limit :5 nudges(hex)
;    LEA DI, ASC
;    
;    XOR DX, DX
;    MOV AX, HEX       ;0000H ~ FFFFH(UNSIGNED)
;    MOV BX, 0AH
;    
;AGAIN:
;    DIV BX 
;    ADD DL, 30H       ; REMINDER -> DL
;    MOV [DI], DL
;    INC DI
;    
;    AND AX, AX
;    JZ STO
;    MOV DL, 0
;    
;    LOOP AGAIN
;
;STO:
;    POP DX
;    POP CX
;    POP BX
;    POP AX 
;    RET
;HEXASC ENDP
       
CODES ENDS  
    END START


                                                                                                             
