LENGTH EQU 6
MINUS EQU 2DH ; '-'
EQUAL EQU 3DH ;'='

DATAS SEGMENT
    ;DATA1 DB '3', '2', '4', '0', '4'
;    DATA2 DB '2', '9', '5', '1', '2'
    ;DATA1 DB '12789'
;    DATA2 DB '49923'
    DATA1 DB '213209'
    DATA2 DB '329978'

    ASC DB 6 DUP('0'), '$'
    ;40423
    
    HEX_BUF DB 6 DUP(0)
    
    HEX DB 3 DUP(0) 
    
    HEX1 DB 3 DUP(0)
    HEX2 DB 3 DUP(0)
    
    RES_ASC DB 5 DUP('0'), '$'

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
    LEA DI, HEX1
    CALL FIRST   ; Now HEX1 = (hex) DATA1
    
    MOV DL, MINUS
    MOV AH, 2
    INT 21H 
                 ; Print Minus '-'
    
    LEA SI, DATA2
    LEA DI, HEX2
    CALL FIRST   ; Now HEX2 = (hex) DATA2
    
    MOV DL, EQUAL
    MOV AH, 2
    INT 21H      ; Print Equal '='
    
    CALL SUBHEX  ; Now HEX = HEX1 - HEX2
    
    CALL HEXTBCD ; Now HEX_BUF = (bcd) HEX
    
    LEA DI, RES_ASC
    CALL BCDTASC ; Now RES_ASC = (ascii) HEX_BUF
    
    LEA SI, RES_ASC
    CALL SHOW



    
    ;CALL SHOW
;    
;    LEA SI, ASC
;    
;    CALL MAKEHEXBUF
;    
;    CALL GENHEX
;    
;    ; HEX -> HEX1
;    LEA SI, HEX
;    LEA DI, HEX1
;    MOV CX, 3
;    CLD
;    REP MOVSB
;    
;    LEA SI, DATA2
;    CALL SHOW
;    LEA SI, ASC
;    CALL MAKEHEXBUF
;    CALL GENHEX
;    
;    LEA SI, HEX
;    LEA DI, HEX2
;    MOV CX, 3
;    CLD
;    REP MOVSB 
    
    MOV AH, 4CH
    INT 21H

FIRST PROC 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    CALL SHOW
    LEA SI, ASC
    CALL ASCTBCD
    CALL BCDTHEX
    
    LEA SI, HEX
    MOV CX, 3
    CLD 
    REP MOVSB
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
FIRST ENDP    

SHOW PROC               ; [SI] -> ASC(REVERESED) 
                        ; AND THEN TO SHOW IT
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI        
    
    LEA DI, ASC
    
    
    MOV CL, LENGTH
    XOR BX, BX    
    

INNERLOOP:    
    MOV BL, CL
    DEC BX
    MOV AL, BYTE PTR[BX+SI]
    MOV BYTE PTR[DI], AL
    INC DI
    DEC CL
    JNZ INNERLOOP 
    
    
    ; Print the ASC
    LEA DX, ASC
    MOV AH, 09H
    INT 21H 
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET 
SHOW ENDP
                                                                                                             

ASCTBCD PROC      ; [SI](ASC) -> HEX_BUF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI  
     
    LEA DI, HEX_BUF      
    MOV CL, LENGTH   
    
INNER_ASCTBCD:    

    MOV AL, BYTE PTR[SI]
    SUB AL, 30H
    MOV BYTE PTR[DI], AL
    INC DI
    INC SI
    DEC CL
    JNZ INNER_ASCTBCD
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ASCTBCD ENDP


BCDTASC PROC    ; HEX_BUF -> [DI](RES_ASC)
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    LEA SI, HEX_BUF

    MOV CL, LENGTH
    
INNER_BCDTASC:
    MOV AL, BYTE PTR[SI]
    ADD AL, 30H
    MOV BYTE PTR[DI], AL
    INC SI
    INC DI
    DEC CL
    JNZ INNER_BCDTASC
    
    MOV BYTE PTR[DI], '$'
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
BCDTASC ENDP
    

BCDTHEX PROC    ; HEX_BUF -> HEX
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI
    
    LEA SI, HEX_BUF
    LEA DI, HEX
    MOV BX, 000AH
    XOR AX, AX
    MOV CL, LENGTH

INNER_BCDTHEX:    
    MUL BX
    ADD AL, BYTE PTR[SI]
    ADC DX, 0
    INC SI
    DEC CL
    JNZ INNER_BCDTHEX
    
    MOV WORD PTR[DI], AX
    MOV [DI+2], DL
    
    POP DI
    POP SI
    POP CX
    POP BX
    POP AX
    RET
BCDTHEX ENDP 


HEXTBCD PROC   ; HEX -> HEX_BUF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    LEA SI, HEX
    LEA DI, HEX_BUF
    
    XOR DX, DX
    MOV AX, WORD PTR[SI]
    MOV DL, [SI+2]
    
    MOV BX, 000AH
INNER_HEXTBCD:
    DIV BX
    MOV BYTE PTR[DI], DL
    MOV DX, 0
    INC DI
    CMP AX, 0
    JNZ INNER_HEXTBCD 
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
HEXTBCD ENDP



SUBHEX PROC    ; HEX1 - HEX2 -> HEX
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
     
    LEA SI, HEX1
    LEA DI, HEX2
    LEA BX, HEX 
    MOV CL, 3
    CLC
SUBTRACT_LOOP:
    
    MOV AL, BYTE PTR[SI]
    SBB AL, BYTE PTR[DI]
    MOV BYTE PTR[BX], AL
    INC BX
    INC SI
    INC DI
    DEC CL
    JNZ SUBTRACT_LOOP
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SUBHEX ENDP
  
    
CODES ENDS
      END START