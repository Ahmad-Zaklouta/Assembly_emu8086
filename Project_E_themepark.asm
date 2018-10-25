org 100h

.model small 

.stack 100h

.data

CrLf     db   13,10,'$'  ; print newline

menu:    DB 0Dh,0Ah,"1- Buy a single Day Ticket",0Dh,0Ah
         DB "2- Get a Special offer",0Dh,0Ah 
         DB "3- Know more about Six-flags Magic Mountain",0Dh,0Ah
         DB "4- Exit the application",0Dh,0Ah,
         DB "Please enter your choice: ",'$'

ticket:  DB 0Dh,0Ah,"Single Day Ticket = 53.99 U.S.D",0Dh,0Ah,'$'

ticket_bill:  DB 0Dh,0Ah,"the total bill is:",'$'
 
ticket_no:    DB 0Dh,0Ah,"How many tickets do you want to buy (two digit 00..99)? ",'$'

offer:   DB 0Dh,0Ah,"     Offer                            Price",0Dh,0Ah
         DB "1- Season Pass      Gold            82.99 U.S.D",0Dh,0Ah
         DB "2- Membership       Gold Plus        7.85 per month",0Dh,0Ah
         DB "3- Membership       Platinum         9.85 per month",0Dh,0Ah
         DB "4- Membership       Diamond         12.85 per month",0Dh,0Ah
         DB "5- Membership       Diamond Elite   18.85 per month",0Dh,0Ah,
         DB "Enter the number of the offer you want: ",'$'

membership_tickets:  DB 0Dh,0Ah,"For how long would you like the membership to last? ",'$'

info:    DB 0Dh,0Ah,"Welcome to Six Flags Magic Mountain",0Dh,0Ah
         DB "Our physical location is 26101 Magic Mountain Parkway, Valencia, CA 91355.",0Dh,0Ah 
         DB "We have so many choices for THRILL RIDES, FAMILY RIDES, and KIDS RIDES",0Dh,0Ah
         DB "The park is scheduled to be open every day, however, if there are no operating hours listed for a particular date, the park may be closed.",0Dh,0Ah
         DB "Our phone number is (661) 255-4100.",0Dh,0Ah,'$'

single        DB 54
Gold          DB 83
GoldPlus      DB 8
Platinum      DB 10
Diamond       DB 13 
DiamondElite  DB 19

RES              DB 10 DUP ('$')         
ticketsnumber    DB 0
offerchoice      DB 0
membershipperiod DB 0
result           DD 0
user_input       DB 0

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

      ; forth choice
      cmp al, '4'
      je  FORTH_CHOICE
      
      ; loop back to get_choice until the user choose
      jmp get_choice
      
;===== Handle buying a single tickets =====
FIRST_CHOICE:
      ; Code to display the ticket message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset ticket
      mov ah, 9
      int 21h
      
      ; Code to display the number of tickets message
      mov dx, offset ticket_no
      mov ah, 9
      int 21h
      
      ; Get the number of tickets
      ; read first digit 
      MOV AH, 1
      INT 21H
      SUB AL, 30H  ; convert first digit from ascii to number
      MOV AH, 0
      MOV BL, 10
      MUL BL
      MOV BL, AL
      ; read second digit 
      MOV AH, 1
      INT 21H     
      SUB AL, 30H ; convert second digit from ascii to number
      MOV AH, 0
      ADD AL, BL
      
      ; calculate the total bill
      mov bl, single
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT      

;===== Handle buying an offer tickets =====      
SECOND_CHOICE:      

      ; Code to display the offers message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset offer
      mov ah, 9
      int 21h
      
      ; read the user choice (What offer?)
      mov ah, 7
      int 21h
      mov offerchoice, al

      ;printing new line
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      
      ; Code to display the number of tickets message
      mov dx, offset ticket_no
      mov ah, 9
      int 21h
      
      ; Get the number of tickets
      ; read first digit 
      MOV AH, 1
      INT 21H
      SUB AL, 30H  ; convert first digit from ascii to number
      MOV AH, 0
      MOV BL, 10
      MUL BL
      MOV BL, AL
      ; read second digit 
      MOV AH, 1
      INT 21H     
      SUB AL, 30H ; convert second digit from ascii to number
      MOV AH, 0
      ADD AL, BL
      mov ticketsnumber, al

      ; first offer ---- season pass      Gold
      cmp offerchoice, '1'
      je  FIRST_OFFER
      
      ; second offer ---- Membership      Gold Plus
      cmp offerchoice, '2'
      je  Membership
      
      ; third offer ---- Membership       Platinum
      cmp offerchoice, '3'
      je  Membership

      ; forth offer ---- Membership       Diamond
      cmp offerchoice, '4'
      je  Membership

      ; fifth offer ---- Membership       Diamond Elite
      cmp offerchoice, '5'
      je  Membership

  FIRST_OFFER: ; Handle the season pass offer
      ; calculate the total bill
      mov bl, gold
      mov al, ticketsnumber
      mov ticketsnumber, 0
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT
      
  Membership: ; Handle the Membership offers

      ; Code to display the offers message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset membership_tickets
      mov ah, 9
      int 21h

      ; Get the Membership period
      ; read first digit 
      MOV AH, 1
      INT 21H
      SUB AL, 30H  ; convert first digit from ascii to number
      MOV AH, 0
      MOV BL, 10
      MUL BL
      MOV BL, AL
      ; read second digit 
      MOV AH, 1
      INT 21H     
      SUB AL, 30H ; convert second digit from ascii to number
      MOV AH, 0
      ADD AL, BL
      mov membershipperiod, al

      ; Handle the membership offer choice
      ; second offer ---- Membership      Gold Plus
      cmp offerchoice, '2'
      je  SECOND_OFFER
      
      ; third offer ---- Membership       Platinum
      cmp offerchoice, '3'
      je  THIRD_OFFER

      ; forth offer ---- Membership       Diamond
      cmp offerchoice, '4'
      je  FORTH_OFFER

      ; fifth offer ---- Membership       Diamond Elite
      cmp offerchoice, '5'
      je  FIFTH_OFFER
       
    SECOND_OFFER: ; Handle the Gold Plus offer
      ; calculate the total bill (goldplus*membershipperiod*ticketsnumber)
      mov bl, GoldPlus
      mov al, ticketsnumber
      mov ticketsnumber, 0
      mul bl
      mov bl, membershipperiod
      mov membershipperiod, 0
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT

  THIRD_OFFER: ; Handle the Platinum offer
      ; calculate the total bill (Platinum*membershipperiod*ticketsnumber)
      mov bl, Platinum
      mov al, ticketsnumber
      mov ticketsnumber, 0
      mul bl
      mov bl, membershipperiod
      mov membershipperiod, 0
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT

  
  FORTH_OFFER: ; Handle the Diamond offer
      ; calculate the total bill (Diamond*membershipperiod*ticketsnumber)
      mov bl, Diamond
      mov al, ticketsnumber
      mov ticketsnumber, 0
      mul bl
      mov bl, membershipperiod
      mov membershipperiod, 0
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT


  FIFTH_OFFER: ; Handle the Diamond Elite offer
      ; calculate the total bill (DiamondElite*membershipperiod*ticketsnumber)
      mov bl, DiamondElite
      mov al, ticketsnumber
      mov ticketsnumber, 0
      mul bl
      mov bl, membershipperiod
      mov membershipperiod, 0
      mul bl
      mov result , ax
      
      ; print result message
      mov dx, offset ticket_bill
      MOV AH,9
      INT 21H
      
      jmp PRINT_RESULT


;===== Handle info about Six-flags Magic Mountain =====
THIRD_CHOICE:
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset info
      MOV AH,9
      INT 21H
      
      jmp start
      
;===== Print result as decimal on the screen =====
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
FORTH_CHOICE:
      mov ah,4Ch
      int 21h