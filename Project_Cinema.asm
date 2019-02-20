org 100h

.model small 

.stack 100h

.data


menu:    DB 0Dh,0Ah,"1- All the names of the movie theaters and their locations",0Dh,0Ah
         DB "2- Book a ticket",0Dh,0Ah 
         DB "3- Exit the application",0Dh,0Ah,
         DB "please choose: ", '$'

CrLf     db 13,10,'$'  ; print newline
         
totalbill: DB 0Dh,0Ah,"the total bill is: ",'$'

theaters_info:   
         DB 0Dh,0Ah,0Dh,0Ah,"Theater name    Location	                Telephone number  Working hours",0Dh,0Ah
         DB "Film Theater    North,27 garden street     033-2569856       3 pm – 12 am",0Dh,0Ah
         DB "Action Theater  South,exit9,23 rose road   032-4587125       1 pm – 10 pm",0Dh,0Ah,'$'


film_theater:
         DB 0Dh,0Ah,"1- film theater",0Dh,0Ah,
         DB "The ticket           Price",0Dh,0Ah
         DB "Under 6 years old    15 USD",0Dh,0Ah 
         DB "Adults               45 USD",0Dh,0Ah
         DB "Seiners              25 USD",0Dh,0Ah,'$'

action_theater:
         DB "2- action theater",0Dh,0Ah,
         DB "The ticket           Price",0Dh,0Ah
         DB "Under 6 years old    5 USD",0Dh,0Ah 
         DB "Adults               35 USD",0Dh,0Ah
         DB "Seiners              15 USD",0Dh,0Ah,'$'

theaters:      DB 0Dh,0Ah,"What theaters would you like to go to (1-film , 2-action)? ",'$'
ticket:        DB 0Dh,0Ah,"What ticket would you like to buy (1-child , 2-adult , 3-seiners)? ",'$'
ticket_number: DB 0Dh,0Ah,"How many ticket do you want to buy ",'$'

child_film    DD 15 ; child Price for film theater       
adult_film    DD 45 ; adult Price for film theater
seiners_film  DD 23 ; seiners Price for film theater

child_action    DD 5  ; child Price for action theater       
adult_action    DD 35 ; adult Price for action theater
seiners_action  DD 15 ; seiners Price for action theater

theater_type   DB 0
ticket_type    DB 0
ticket_num     DD 0
ticket_price   DD 0   
result         DD 0
              
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
      
      ; loop back to get_choice until the user choose
      jmp get_choice
      
;===== Get a theaters_info =====
FIRST_CHOICE:
      ; Code to display the theaters_info message
      mov dx, offset theaters_info
      mov ah, 9
      int 21h

      mov dx, offset CRLF
      MOV AH,9
      INT 21H  
      
      ; return to menu
      jmp start

;===== book a ticket =====
SECOND_CHOICE:
      ; Code to display the theater type message
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset film_theater
      mov ah, 9
      int 21h 
         
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      
      mov dx, offset action_theater
      mov ah, 9
      int 21h
      mov dx, offset theaters
      mov ah, 9
      int 21h
      
      ; Get the theaters type 
      MOV AH, 1
      INT 21H
      mov theater_type, al

      ; Code to display the ticket_type message
      mov dx, offset ticket
      mov ah, 9
      int 21h    
	  
      ; Get the ticket type 
      MOV AH, 1
      INT 21H
      mov ticket_type, al
	  
      ; Code to display the ticket_number message
      mov dx, offset ticket_number
      mov ah, 9
      int 21h
	  
      ; Get the ticket number      
      call INDEC
      mov ticket_num, ax

      ; check the theaters type
      cmp theater_type, '1'
      je  film_cinema
      cmp theater_type, '2'
      je action_cinema
      jmp SECOND_CHOICE
       
  ; code for the film theaters
  film_cinema:
      ; child ticket
      cmp ticket_type, '1'
      jne ADULT_ticket_film
	  mov ax, child_film
      mov ticket_price, ax
	  jmp calculate
	  
      ; adult ticket
    ADULT_ticket_film:
      cmp ticket_type, '2'
      jne SEINERS_ticket_film
	  mov ax, adult_film
      mov ticket_price, ax
      jmp calculate
      
      ; seiners ticket
    SEINERS_ticket_film:
      cmp ticket_type, '3'
      jne SECOND_CHOICE
	  mov ax, seiners_film
      mov ticket_price, ax
	  jmp calculate


  ; code for the action theaters
  action_cinema:
      ; child ticket
      cmp ticket_type, '1'
      jne ADULT_ticket_action
	  mov ax, child_action
      mov ticket_price, ax
      jmp calculate	  
      
      ; adult ticket
    ADULT_ticket_action:
      cmp ticket_type, '2'
      jne SEINERS_ticket_action
	  mov ax, adult_action
      mov ticket_price, ax
      jmp calculate
      
      ; seiners ticket
    SEINERS_ticket_action:
      cmp ticket_type, '3'
      jne SECOND_CHOICE
	  mov ax, seiners_action
      mov ticket_price, ax
	  jmp calculate

	  
      ; calculate price
    calculate:  ; ticket_num * ticket_price
      mov cx, ticket_num
	  mov ax, ticket_price
      mul cx  ; ticket_num * ticket_price
      mov result, ax
      
      ; Code to display the total bill message
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset totalbill
      MOV AH,9
      INT 21H      
      
      mov ax, result
      call OUTDEC
      
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
               
      jmp start
      
;===== Handle exit ===== 
THIRD_CHOICE:
      mov ah,4Ch
      int 21h
      


;================================================  

  OUTDEC  PROC
      PUSH  AX
      PUSH  BX
      PUSH  CX
      PUSH  DX
      
      OR    AX,AX
      JGE   @END_IF1
      PUSH  AX
      
      MOV   DL,'-'
      MOV   AH,2
      INT   21H
      
      POP   AX
      NEG   AX
      
    @END_IF1:
      XOR  CX,CX
      MOV  BX,10D
      
    @REPEAT1:
      XOR  DX,DX
      DIV  BX
      PUSH DX
      INC  CX
      OR   AX,AX
      JNE  @REPEAT1
      MOV  AH,2
      
    @PRINT_LOOP:
      POP  DX
      OR  DL,30H
      INT  21H
      LOOP  @PRINT_LOOP
      
      POP  DX
      POP  CX
      POP  BX
      POP  AX
      RET
  OUTDEC  ENDP



;-----------------------------------------

  INDEC  PROC
    
      ;;;;;;;;;;;;;;;;;;; READ DECIMAL NUMBER;;;;;;;;;;;;
      PUSH  BX
      PUSH  CX
      PUSH  DX
      
    @BEGIN:
      MOV  AH,2
      MOV  DL,'?'
      INT  21H
      XOR  BX,BX
      XOR  CX,CX
      MOV  AH,1
      INT  21H
      CMP  AL,'-'
      JE  @MINUS
      CMP  AL,'+'
      JE  @PLUS 
      JMP @REPEAT2
      
    @MINUS:
      MOV  CX,1
      
    @PLUS:
      INT  21H
      
    @REPEAT2:
      CMP  AL,'0'
      JNGE  @NOT_DIGIT
      CMP  AL,'9'
      JNLE  @NOT_DIGIT
      AND  AX,000FH
      PUSH  AX
      MOV  AX,10
      MUL  BX
      POP  BX
      ADD  BX,AX
      MOV  AH,1
      INT  21H 
      CMP  AL,0DH
      JNE  @REPEAT2
      MOV  AX,BX
      OR  CX,CX
      JE  @EXIT
      NEG  AX
      
    @EXIT:
      POP  DX
      POP  CX
      POP  BX
      RET
      
    @NOT_DIGIT:
      cmp  al, 'f'  ; is it f?
      je   @EXIT:
      MOV  AH,2
      MOV  DL,0DH
      INT  21H
      MOV  DL,0AH
      INT  21H
      JMP  @BEGIN
      
  INDEC  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;END READ;;;;;;;;;