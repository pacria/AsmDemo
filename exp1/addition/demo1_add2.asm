DATAS SEGMENT
    SQTAB DB 00H, 01H, 04H, 09H, 10H, 19H, 24H, 31H, 40H, 51H, 64H
    ASC DB 2 DUP('0'), '$'
    ASC_BUF DB 2 DUP('0'), '$'
    HEX DB DUP(0)
    
    MUL_SIGN DB '*'
    
    EQU_SIGN DB '='
    
     
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    

    
    
START:   

    MOV AX,DATAS
    MOV DS,AX
    
    ;此处输入代码段代码
    XOR AX, AX
    
    MOV AH, 1
    INT 21H
    ; Read from screen -> AL   
    
    PUSH AX
    
    MOV DL, MUL_SIGN
    MOV AH, 02H
    INT 21H
    
    POP AX
    PUSH AX
    
    MOV DL, AL
    MOV AH, 2
    INT 21H
    
    MOV DL, EQU_SIGN
    MOV AH, 2
    INT 21H 
    
    POP AX
    
    
    CMP AL, '9'
    JA ERROR
    CMP AL, '0'
    JB ERROR
    
    SUB AL, 30H 
    LEA DI, SQTAB
    AND AX, 007FH
    MOV BX, AX
    
    MOV AL, [DI]BX
    ;MOV AL, [DI]
    MOV HEX, AL
    
    CALL HEXASC 
    
    CALL TRANASCBUF              
               
    LEA DX, ASC_BUF
    MOV AH, 9
    INT 21H    
ERROR:    
    MOV AH,4CH
    INT 21H 
    
    
HEXASC PROC 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 2         ; limit :5 nudges(hex)
    LEA DI, ASC
    
    XOR DX, DX
    MOV AL, HEX       ;0000H ~ FFFFH(UNSIGNED)
    MOV BX, 0AH
    
AGAIN:
    DIV BX 
    ADD DL, 30H       ; REMINDER -> DL
    MOV [DI], DL
    INC DI
    
    AND AX, AX
    JZ STO
    MOV DL, 0
    
    LOOP AGAIN

STO:
    POP DX
    POP CX
    POP BX
    POP AX 
    RET
HEXASC ENDP


TRANASCBUF PROC 
    PUSH SI
    PUSH DI
    PUSH AX
    PUSH CX 
    
    LEA SI, ASC
    LEA DI, ASC_BUF 
    XOR CX, CX
    MOV CL, 02H 
    ADD SI, 01H
    
    REL:
    MOV AX, [SI]
    MOV [DI], AX
    INC DI
    DEC SI
    DEC CL
    JNZ REL
   
    MOV [DI], '$'
    POP CX
    POP AX
    POP DI
    POP SI
    RET
TRANASCBUF ENDP
    
CODES ENDS
    END START

