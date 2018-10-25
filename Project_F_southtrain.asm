org 100h

.model small 

.stack 100h

.data

CrLf     db 13,10,'$'  ; print newline

menu:    DB 0Dh,0Ah,"1- How to buy a train ticket",0Dh,0Ah
         DB "2- Get a ticket",0Dh,0Ah 
         DB "3- Exit the application",0Dh,0Ah,'$'

info:    DB 0Dh,0Ah,"Welcome to the South Westren Railway",0Dh,0Ah
         DB "There are four way to buy a ticket:",0Dh,0Ah 
         DB "1- Online. 2- Phone.  3- Self-service ticket machines. 4- At the station.",0Dh,0Ah
         DB "You can choose between single ticket, seasonal ticket, and yearly ticket.",0Dh,0Ah
         DB "Please Call or visit our Customer Service Centre for help. It's open 06:00 to 22:00",0Dh,0Ah,'$'
         
bill:    DB 0Dh,0Ah,"the total bill is: ",'$'
 
tickets: DB 0Dh,0Ah,"How many tickets do you want to buy (two digit 00-99)? ",'$'

tickets_available:   
         DB 0Dh,0Ah,"Tickets available                    Price",0Dh,0Ah
         DB "1- Season Tickets      Adults     1364 pound",0Dh,0Ah
         DB "2- Season Tickets       Child     682 pound",0Dh,0Ah
         DB "Enter the number of the choice you want: ",'$'


adult        DD 1364
child        DD 682
adult30      DD 955    ; adult with 30% discount
child30      DD 477    ; child with 30% discount
adult60      DD 546    ; adult with 60% discount
child60      DD 273    ; child with 60% discount

result       DD 0
ticket_type  DB 0
ticket_num   DD 0
RES          DB 10 DUP ('$')         
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
      
;===== How to buy a train ticket =====
FIRST_CHOICE:
      ; Code to display the info message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset info
      mov ah, 9
      int 21h
      
      jmp start
      
SECOND_CHOICE: 
      ; Code to display the ticket message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset tickets_available
      mov ah, 9
      int 21h
      
      ; read the user choice (What ticket?)
      mov ah, 7
      int 21h
      mov ticket_type, al
      
      ; Code to display the number of ticket message
      mov dx, offset tickets
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
      mov ticket_num, ax

      ; print result message
      mov dx, offset bill
      MOV AH,9
      INT 21H
      
      ; first choice
      cmp ticket_type, '1'
      je  ADULT_CHOICE
      
      ; second choice
      cmp ticket_type, '2'
      je  CHILD_CHOICE
 
  ADULT_CHOICE:
      ; calculate the total bill for adult choice
      ; is it 3 tickets
      cmp ticket_num, 3
      je adult_discount30
      ; is it 4 tickets
      cmp ticket_num, 4
      je  adult_discount60
      ; it is not 3 nor 4
      jmp adult_nodiscount
      
      ; calculate the total bill for adult choice with 30% discount
    adult_discount30:
      mov ax, adult30
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
      
      ; calculate the total bill for adult choice with 60% discount
    adult_discount60:
      mov ax, adult60
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
      
      ; calculate the total bill for adult choice with normal discount
    adult_nodiscount:
      mov ax, adult
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
           

  CHILD_CHOICE:
      ; calculate the total bill for child choice
      ; is it 3 tickets
      cmp ticket_num, 3
      je child_discount30
      ; is it 4 tickets
      cmp ticket_num, 4
      je  child_discount60
      ; it is not 3 nor 4
      jmp child_nodiscount
      
      ; calculate the total bill for child choice with 30% discount
    child_discount30:
      mov ax, child30
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
      
      ; calculate the total bill for child choice with 60% discount
    child_discount60:
      mov ax, child60
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
      
      ; calculate the total bill for child choice with normal price
    child_nodiscount:
      mov ax, child
      mov bx, ticket_num
      mul bx
      mov result , ax
      jmp PRINT_RESULT
      
      
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