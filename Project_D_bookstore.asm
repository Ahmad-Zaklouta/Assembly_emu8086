org 100h

.model small 

.stack 100h

.data


menu:    DB 0Dh,0Ah,"1- Get a membership",0Dh,0Ah
         DB "2- Our Prices and Special offer",0Dh,0Ah 
         DB "3- Exit the application",0Dh,0Ah,'$'

CrLf     db 13,10,'$'  ; print newline
         
totalbill: DB 0Dh,0Ah,"the total bill is: ",'$'

membership_offer:   
         DB 0Dh,0Ah,"     membership                         Price",0Dh,0Ah
         DB "1- Weekly membership      Adults     26 U.S.D",0Dh,0Ah
         DB "2- Weekly membership       Child     15 U.S.D",0Dh,0Ah
         DB "Enter the number of the membership you want: ",'$'

membership_number: DB 0Dh,0Ah,"How many membership do you want to buy (00-99)? ",'$'
membership_time:   DB 0Dh,0Ah,"For how long would you like the membership to last (00-99)? ",'$'

bookinfo:
         DB 0Dh,0Ah,"we are the library book truck",0Dh,0Ah
         DB "We have textbook, novels, biography, and short stories books",0Dh,0Ah 
         DB "We open every day from 10:00 to 04:00.",0Dh,0Ah
         DB "Our phone number is (966) 44885566.",0Dh,0Ah,'$'
         
adult    DD 26
child    DD 15
adult20  DD 21     ; adult Price with 20% discount 20.8 ~= 21
child20  DD 12     ; child Price with 20% discount
adult40  DD 16     ; adult Price with 40% discount 15.6 ~= 16
child40  DD 9      ; child Price with 40% discount

membershiptime   DD 0
membership_type  DB 0
membership_num   DD 0
result           DD 0
RES              DB 10 DUP ('$')         
.code

begin:
      mov ax,@data
      mov ds,ax
  
start:
; Code to display the menu  
      mov dx, offset menu
      mov ah, 09h
      int 21h
      
;code to choose one choice from the menu
get_choice:
      ; read the user choice
      mov ah, 7
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
      
      ; loop back to get_choice until the user choose
      jmp get_choice
      
;===== Get a membership =====
FIRST_CHOICE:
      ; Code to display the membership offer message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset membership_offer
      mov ah, 9
      int 21h

      ; read the user choice (What membership?)
      mov ah, 7
      int 21h
      mov membership_type, al
      
      ; Code to display the period of membership message
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset membership_time
      mov ah, 9
      int 21h

      ; Get the number of the period of membership
      ; read first number 
      MOV AH, 1
      INT 21H
      SUB AL, 30H  ; convert ascii to number
      MOV AH, 0
      MOV BL, 10
      MUL BL
      MOV BL, AL
      ; read second number 
      MOV AH, 1
      INT 21H     
      SUB AL, 30H ; convert ascii to number
      MOV AH, 0
      ADD AL, BL
      mov membershiptime, ax

      ; Print a new line
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      
      ; Code to display the number of membership message
      mov dx, offset membership_number
      mov ah, 9
      int 21h

      ; Get the number of the number of membership
      ; read first number 
      MOV AH, 1
      INT 21H
      SUB AL, 30H  ; convert ascii to number
      MOV AH, 0
      MOV BL, 10
      MUL BL
      MOV BL, AL
      ; read second number 
      MOV AH, 1
      INT 21H     
      SUB AL, 30H ; convert ascii to number
      MOV AH, 0
      ADD AL, BL
      mov membership_num, ax

      ; adult membership
      cmp membership_type, '1'
      je  ADULT_membership
      
      ; child membership
      cmp membership_type, '2'
      je  CHILD_membership  

  ADULT_membership:
      ; calculate adult membership with 20% discount
      mov ax, membershiptime
      cmp al, 4
      mov cx, adult20
      je calculate

      ; calculate adult membership with 40% discount
      mov ax, membershiptime
      cmp al, 5
      jae adultcheckfor9
      jmp adult_normal
      
    adultcheckfor9:  
      mov ax, membershiptime
      mov cx, adult40
      cmp al, 9
      jle calculate

      ; calculate child membership with normal price
    adult_normal:
      mov ax, membershiptime
      mov cx, adult 
      jmp calculate
      
  CHILD_membership:
      ; calculate child membership with 20% discount
      mov ax, membershiptime
      cmp al, 4
      mov cx, child20
      je calculate

      ; calculate adult membership with 40% discount
      mov ax, membershiptime
      cmp al, 5
      jae childcheckfor9
      jmp child_normal
      
    childcheckfor9:  
      mov ax, membershiptime
      mov cx, child40
      cmp al, 9
      jle calculate
      
      ; calculate child membership with normal price
    child_normal:
      mov ax, membershiptime
      mov cx, child
    
  calculate:  ; membership_num * membership price * membershiptime
      mov ax, membership_num
      mul cx  ; membership_num * membership price
      mov cx, membershiptime
      mul cx  ; (membership_num * membership price) * membershiptime
      mov result, ax
      
      ; Code to display the total bill message
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset totalbill
      MOV AH,9
      INT 21H      
      
      jmp PRINT_RESULT          

      
;===== Our Prices and Special offer =====      
SECOND_CHOICE: 
      ; Code to display the information message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset bookinfo
      mov ah, 9
      int 21h
      jmp start
      
;===== Print the result =====
PRINT_RESULT:      
      mov ax, result
      mov result, 0
      ; convert decimal to hex to print result
      LEA SI, res
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
 
      LEA DX,RES
      MOV AH,9
      INT 21H
      ;printing new line
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
   
      jmp start
 
;===== Handle exit ===== 
THIRD_CHOICE:
      mov ah,4Ch
      int 21h