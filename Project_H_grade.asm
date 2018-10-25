org 100h

.model small 

.stack 100h

.data

info:    DB 0Dh,0Ah,"- Grade Calculator -",0Dh,0Ah
         DB "************************",0Dh,0Ah,0Dh,0Ah
         DB " Range          Grade",0Dh,0Ah
         DB "90 - 100          A",0Dh,0Ah 
         DB "80 - 89           B",0Dh,0Ah
         DB "70 - 79           C",0Dh,0Ah
         DB "60 - 69           D",0Dh,0Ah
         DB " 0 - 59           F",0Dh,0Ah,0Dh,0Ah
         DB "Please enter your grade (0 .. 100) and press enter: ",'$'

wrong_msg: DB 0Dh,0Ah,"Wrong grade. Please enter between 0 and 100",0Dh,0Ah,'$'

exit:      DB 0Dh,0Ah,"Press Enter to exit",0Dh,0Ah,'$'

Outstanding:   DB 0Dh,0Ah,"Your grade is A (Outstanding)",0Dh,0Ah,'$'
Excellent:     DB 0Dh,0Ah,"Your grade is B (Excellent)",0Dh,0Ah,'$'
VeryGood:      DB 0Dh,0Ah,"Your grade is C (Very Good)",0Dh,0Ah,'$'
Good:          DB 0Dh,0Ah,"Your grade is D (Good)",0Dh,0Ah,'$'
Fail:          DB 0Dh,0Ah,"Your grade is F (Fail)",0Dh,0Ah,'$'

CrLf     db 13,10,'$'  ; print newline
        
grade        DD 0

.code

begin:
      mov ax,@data
      mov ds,ax
  
start:
      ; Code to display the info  
      mov dx, offset info
      mov ah, 09h
      int 21h

      ; get the student grade
      mov bx, 0
      mov di,10
  inputloop:
      mov ah,1
      int 21h
      cmp al, 13  ; is it Enter?
      jne convertion
      jmp startcalc

    convertion:
      sub al, 48
      mov ah, 0
      mov cx, ax 
      mov ax, bx       
      mul di          
      add ax, cx       
      mov bx, ax
      jmp inputloop

  startcalc:
      mov grade, bx
      
      mov dx, offset CrLf
      mov ah, 09h
      int 21h
      
      ; if it is greater than 100, write a wrong message
      mov ax, grade
      cmp ax, 100
      ja worng

      ; grade A (90 - 100)
      mov ax, grade
      cmp ax, 90
      jae grade_A
      
      ; grade B (80 - 89)
      mov ax, grade
      cmp ax, 80
      jae grade_B

      ; grade C (70 - 79)
      mov ax, grade
      cmp ax, 70
      jae grade_C

      ; grade D (60 - 69)
      mov ax, grade
      cmp ax, 60
      jae grade_D

      ; grade F (0 - 59)
      jmp grade_F      

grade_A:
      ; Code to display the Outstanding message  
      mov dx, offset Outstanding
      mov ah, 09h
      int 21h
      jmp finish
      
grade_B:
      ; Code to display the Excellent message  
      mov dx, offset Excellent
      mov ah, 09h
      int 21h
      jmp finish
      
grade_C:
      ; Code to display the Very Good message  
      mov dx, offset VeryGood
      mov ah, 09h
      int 21h
      jmp finish
      
grade_D:
      ; Code to display the Good message  
      mov dx, offset Good
      mov ah, 09h
      int 21h
      jmp finish
      
grade_F:
      ; Code to display the Fail message  
      mov dx, offset Fail
      mov ah, 09h
      int 21h
      jmp finish
      
worng:
      ; Code to display the wrong message  
      mov dx, offset wrong_msg
      mov ah, 09h
      int 21h
      jmp start
      
finish:
      mov dx, offset exit
      mov ah, 09h
      int 21h
      mov ah,1
      int 21h
      mov ah,4Ch
      int 21h
