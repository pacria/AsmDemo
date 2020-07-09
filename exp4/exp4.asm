DATAS SEGMENT
    ;DATA1 DB '1032', '2022', '3035', '4458', '$'
;    DATA2 DB '2078', '4512', '3455', '3421', '$' 
    DATA1 DB '2334', '5454', '3432', '8760', '$'
    DATA2 DB '2112', '3442', '4213', '5410', '$'
    
    HEX DW 0116H
    
    ASC DB 4 DUP('0') 
    
    DB 8 DUP(0)
    
    ASC_BUF DB 4 DUP('0')
    
    HEX_BUF DW 1111H, '$' 
    
    SUM DW 5 DUP(0) 
    
    HEX1 DW 4 DUP(0)
    
    HEX2 DW 4 DUP(0)
    
    DB 8 DUP(0)
    
    RESULT_ASC DB 16 DUP('0'), '$'
    
    MINUS DB '-', '$'
    
    EQUAL DB '=', 0AH, 0DH, '$'

     
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
    
    ; Print xxxx xxxx xxxx xxxx - xxxx xxxx xxxx xxxx = (CRLF)
    LEA DX, DATA1
    MOV AH, 09H
    INT 21H
    
    MOV DL, MINUS
    MOV AH, 02H
    INT 21H
    
    LEA DX, DATA2
    MOV AH, 09H
    INT 21H
    
    MOV DL, EQUAL
    MOV AH, 02H
    INT 21H 
    ; End Print
      
    
    XOR CX, CX 
    
    MOV DL, 4    
    LEA SI, DATA1
    LEA BX, HEX1
    
COPYDATAI:
    LEA DI, ASC    
    MOV CX, 04H
    CLD
    REP MOVSB   
    
    CALL ASCTENHEX
    
    MOV AX, HEX
    MOV [BX], AX

    ADD BX, 2
    DEC DL 
    JNZ COPYDATAI
    
    XOR CX, CX
    
    MOV DL, 4
    LEA SI, DATA2
    LEA BX, HEX2
    
COPYDATAII:
    LEA DI, ASC    
    MOV CX, 04H
    CLD
    REP MOVSB   
    
    CALL ASCTENHEX
    
    MOV AX, HEX
    MOV [BX], AX

    ADD BX, 2
    DEC DL 
    JNZ COPYDATAII
    
; Now DATA1 and DATA2 has already translate from ASCII into HEX stored in HEX1, HEX2
    MOV SI, OFFSET HEX1
    MOV DI, OFFSET HEX2
    MOV BX, OFFSET SUM
    
    XOR CX, CX
    MOV CL, 04H 
    CLC
    
GOON:                    ; The Main Process to calculate!
    
    MOV AX, WORD PTR[SI]
    ;ADC AX, WORD PTR[DI] ; Word + Word
    
    SBB AX, WORD PTR[DI]
    
    
    
    PUSHF
    
    ADD SI, 2
    ADD DI, 2
    
    MOV [BX], AX
    ADD BX, 2
    
    POPF 
    
    DEC CL    
    JNZ GOON
    
    ADC BYTE PTR[BX], 0

    
    XOR CX, CX
    XOR BX, BX 
    
    MOV DL, 04H
    MOV BL, 00H    
    LEA SI, SUM
    
COPYHEXI:
    LEA DI, HEX    
    MOV CX, 01H
    CLD
    REP MOVSW  
    
    CALL HEXASC
    
    CALL TRANASCBUF
    
    PUSH SI
    PUSH DI
    PUSH CX
    
    LEA SI, ASC_BUF
    LEA DI, RESULT_ASC
    INC SI  ; Not sure
    ADD DI, BX            ;BX = 0 or 4 or 8 or 12
    MOV CX, 04H
    CLD
    REP MOVSB 
    
    POP CX
    POP DI
    POP SI


    ADD BX, 4
    DEC DL 
    JNZ COPYHEXI 
    
    LEA DX, RESULT_ASC
    MOV AH, 09H
    INT 21H
    
    
    
    
    ;LEA DX, DATA2
;    MOV AH, 09H       ;Print
;    INT 21H 
;    
;    
;    LEA SI, DATA2
;    LEA DI, ASC
;    MOV CX, 4
;    CLD
;    REP MOVSB
;    
;    CALL ASCTENHEX
;    
;    CALL HEXASC
;    
;    CALL TRANASCBUF
;
;    
;    LEA DX, ASC_BUF
;    MOV AH, 09H       ;Print
;    INT 21H
;    
    MOV AH, 4CH
    INT 21H
    
TRANASCBUF PROC 
    PUSH SI
    PUSH DI
    PUSH AX
    PUSH CX 
    
    LEA SI, ASC
    LEA DI, ASC_BUF 
    XOR CX, CX
    MOV CL, 05H 
    ADD SI, 04H
    
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

ASCTENHEX PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
        

    XOR BX, BX
    XOR DX, DX 
    
    MOV AX, 000AH
    MOV CL, 04H
    LEA SI, ASC
    
DIGIT:  
    
    MOV BL, [SI]
    
    CMP BL, '0'
    JB ERROR
    
    CMP BL, '9'
    JA ERROR
    
    SUB BL, 30H
    
ERROR:
    MUL DX
    MOV DX, AX
    MOV AX, 000AH
    ADD DX, BX
    
    INC SI
    DEC CL
    JNZ DIGIT
    
    MOV WORD PTR HEX, DX
        
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ASCTENHEX ENDP
      
    
HEXASC PROC 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 4         ; limit :5 nudges(hex)
    LEA DI, ASC
    
    XOR DX, DX
    MOV AX, HEX       ;0000H ~ FFFFH(UNSIGNED)
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
       
CODES ENDS  
    END START


                                                                                                             
