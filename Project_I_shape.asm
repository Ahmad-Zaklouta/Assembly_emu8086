org 100h

.model small 

.stack 100h

.data

header DB "- Calculator Application -",0Dh,0Ah
       DB "*************************",'$' 
       
NEWLINE    DB 10,13,"$"
      
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- Circle.",0Dh,0Ah
           DB "2- Square.",0Dh,0Ah 
           DB "3- Rectangle.",0Dh,0Ah
           DB "4- Triangle.",0Dh,0Ah,
           DB "5- Exit.",0Dh,0Ah,
           DB "Please enter your choice: ",'$'

Radius_msg DB 0Dh,0Ah,0Dh,0Ah,"AREA OF CIRCLE",0Dh,0Ah
           DB 0Dh,0Ah,"Please enter the Radius (1-9): ",'$'
           
Side_msg   DB 0Dh,0Ah,0Dh,0Ah,"AREA OF SQUARE",0Dh,0Ah
           DB 0Dh,0Ah,"Please enter the Side (1-9): ",'$'
           
Height_msg DB 0Dh,0Ah,0Dh,0Ah,"Please enter the Height (1-9): ",'$'

Width_msg  DB 0Dh,0Ah,0Dh,0Ah,"AREA OF RECTANGLE",0Dh,0Ah
           DB 0Dh,0Ah,0Dh,0Ah,"Please enter the Width (1-9): ",'$'
           
Base_msg   DB 0Dh,0Ah,0Dh,0Ah,"AREA OF TRIANGLE",0Dh,0Ah
           DB 0Dh,0Ah,"Please enter the Base (1-9): ",'$'

area_msg   DB 0Dh,0Ah,0Dh,0Ah,"The area is: ",'$'
op_msg     DB 0Dh,0Ah,0Dh,0Ah,"The number of operation you did is: ",'$'
exit       DB 0Dh,0Ah,0Dh,0Ah,"Press Enter for Exit:",'$'

result     DB 10 DUP ('$')
area       DD 0
operation  DB 0

.code

begin:
      mov ax,@data
      mov ds,ax

      ; print message for the header
      MOV AH,09H
      LEA DX,header
      INT 21H
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H

;================================================ 

  start:
      
      ;code to choose one choice from the menu
      MOV AH,09H
      LEA DX,menu
      INT 21H

get_choice:
      ; read the user choice
      mov ah, 1
      int 21h

      ; first choice
      cmp al, '1'
      je  FIRST_CHOICE
      
      ; second choice
      cmp al, '2'
      je  SECOND_CHOICE
      
      ; third choice
      cmp al, '3'
      je  THIRD_CHOICE

      ; forth choice
      cmp al, '4'
      je  FORTH_CHOICE

      ; fifth choice
      cmp al, '5'
      je  FIFTH_CHOICE
      
      ; loop back to get_choice until the user choose
      jmp get_choice
;================================================ 

FIRST_CHOICE:
      ; print raduis msg
      MOV AH,09H
      LEA DX,Radius_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      
      ; Circle    (C) Radius         Area = 3.14159(Radius)(Radius)
      mov ah, 0
      mul ax      ; (Radius)(Radius)
      mov bx, 3
      mul bx      ; pi
      mov area, ax
      
      ; print area msg
      MOV AH,09H
      LEA DX,area_msg
      INT 21H 
      
      inc operation
      
      jmp PRINT_RESULT      
;================================================ 
      
SECOND_CHOICE:
      ; print side msg
      MOV AH,09H
      LEA DX, side_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      ; Square    (S) Side           Area = (Side)(Side)
      mov ah, 0
      mul ax      ; (Radius)(Radius)
      mov area, ax
      
      ; print area msg
      MOV AH,09H
      LEA DX,area_msg
      INT 21H 
      
      inc operation
      
      jmp PRINT_RESULT     
;================================================ 
      
THIRD_CHOICE:
      ; print width msg
      MOV AH,09H
      LEA DX,width_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      mov bl, al  ; save the width
      
      ; print height msg
      MOV AH,09H
      LEA DX,height_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      ; Rectangle (R) Height, Width  Area = (Width)(Height)
      mov ah, 0
      mov bh, 0
      mul bx     ; (Width)(Height)
      mov area, ax
      
      ; print area msg
      MOV AH,09H
      LEA DX,area_msg
      INT 21H 
      
      inc operation
      
      jmp PRINT_RESULT  
;================================================     
 
FORTH_CHOICE:
      ; print Base msg
      MOV AH,09H
      LEA DX,Base_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      mov bl, al  ; save the base
      
      ; print height msg
      MOV AH,09H
      LEA DX,height_msg
      INT 21H
      
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
      ; Triangle  (T) Base, Height   Area = 0.5 (Base)(Height)
      mov ah, 0
      mov bh, 0
      mul bx       ; (Base)(Height) 
      mov bl, 2
      div bl       ; (Base)(Height)/2
      mov ah, 0
      mov area, ax
      
      ; print area msg
      MOV AH,09H
      LEA DX,area_msg
      INT 21H 
      
      inc operation
      
      jmp PRINT_RESULT 
;================================================ 

FIFTH_CHOICE:
      ; print operation msg
      MOV AH,09H
      LEA DX,op_msg
      INT 21H
      mov ah, 0
      mov al, operation

      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP1: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP1
      ADD AL,30H
      MOV [SI],AL
    LOOP2: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP2
 
      LEA DX,result
      MOV AH,9
      INT 21H

      LEA DX,exit
      MOV AH,9
      INT 21H
      mov ah,1
      int 21h
      mov ah,4Ch
      int 21h 
;================================================

PRINT_RESULT:      
      ; convert decimal to hex to print result
      mov ax, area
      mov area, 0
      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP11: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP11
      ADD AL,30H
      MOV [SI],AL
    LOOP22: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP22
 
      LEA DX,result
      MOV AH,9
      INT 21H

      jmp start