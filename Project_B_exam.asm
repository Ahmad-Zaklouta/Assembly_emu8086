org 100h

.model small 

.stack 100h

.data

header DB "- Assembly Exam -",0Dh,0Ah
       DB "*************************",'$' 
       
NEWLINE    DB 10,13,"$"
      
yes_or_no  DB 0Dh,0Ah,0Dh,0Ah,"Enter y or n",0Dh,0Ah,'$'
q1         DB "Assembly is a low level programming language? ",'$'
q2         DB 0Dh,0Ah,"Array are not used in Assembly language? ",'$'
q3         DB 0Dh,0Ah,"Number can be signed or unsigned? ",'$' 
correct    DB 0Dh,0Ah,"Number of correct answers are: ",'$'
allright   DB 0Dh,0Ah,"All your answer are correct",0Dh,0Ah,'$'
noright    DB 0Dh,0Ah,"No right answer",'$'


.code

begin:
      mov ax,@data
      mov ds,ax

      ; print message for the header
      MOV AH,09H
      LEA DX,header
      INT 21H

;================================================ 

  start:
      
      mov bl, 0  ; for correct answer
      
      ;print yes_or_no msg
      MOV AH,09H
      LEA DX,yes_or_no
      INT 21H

      ;print q1 msg
      MOV AH,09H
      LEA DX,q1
      INT 21H
      ; read the user choice
      mov ah, 1
      int 21h
      cmp al, 'y'
      jne q1_worng
      inc bl  ; correct answer for q1
    q1_worng:

      ;print q2 msg
      MOV AH,09H
      LEA DX,q2
      INT 21H
      ; read the user choice
      mov ah, 1
      int 21h
      cmp al, 'n'
      jne q2_worng
      inc bl  ; correct answer for q2
    q2_worng:
   
      
      ;print q3 msg
      MOV AH,09H
      LEA DX,q3
      INT 21H
      ; read the user choice
      mov ah, 1
      int 21h
      cmp al, 'y'
      jne q3_worng
      inc bl  ; correct answer for q3
    q3_worng:

      
      ;print correct msg
      MOV AH,09H
      LEA DX,correct
      INT 21H
      ;print number of correct answers 
      mov cl, bl
      add bl, 48  ; number to ascii conversion
      MOV ah,02H
      mov dl,bl
      INT 21H    
 
      cmp cl ,3 
      je all_correct  ; all answer were correct
      cmp cl, 0
      jne finish
      ;print no right msg
      MOV AH,09H
      LEA DX,noright  ; no answer was right
      INT 21H 
      jmp finish
      
    all_correct:
      ;print all correct msg
      MOV AH,09H
      LEA DX,allright
      INT 21H    

finish:
      mov ah,4Ch
      int 21h