DATAS SEGMENT
    
    HEX1 DB  21H, 23H, 44H, 0F1H
    HEX2 DB  3FH, 12H, 53H, 0AH
    
    RES DB 4 DUP(0)

     
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    
    ;�˴��������δ���  
START:    
             
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX 
    
    
    LEA SI, HEX1
    LEA DI, HEX2
    LEA BX, RES 
    MOV CL, 04H
    CLC
MAIN:
    
    MOV AL, [SI]
    SBB AL, [DI]
    MOV [BX], AL
    INC BX
    INC SI
    INC DI
    DEC CL
    JNZ MAIN
  
    

;
;    
;    LEA DX, ASC_BUF
;    MOV AH, 09H       ;Print
;    INT 21H
;    
    MOV AH, 4CH
    INT 21H

       
CODES ENDS  
    END START


                                                                                                             
