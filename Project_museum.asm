org 100h

.model small 

.stack 100h

.data


menu:    DB 0Dh,0Ah,"1- Small amount of information about the museum :",0Dh,0Ah
         DB "2- Book a ticket",0Dh,0Ah 
         DB "3- Exit the application",0Dh,0Ah,
         DB "please choose: ", '$'

CrLf     db 13,10,'$'  ; print newline
         
totalbill: DB 0Dh,0Ah,"the total bill is: ",'$'

museum_info:   
         DB 0Dh,0Ah,0Dh,0Ah,"The National Museum of Riyadh is most famous one in the KSA",0Dh,0Ah
		 DB "located in the middle part of King Abdul-Aziz Historical Center, which was",0Dh,0Ah
		 DB "established to be a cultural and civilization center highlighting the prominent",0Dh,0Ah
		 DB "history of Arabian Peninsula and its historical message of disseminating Islam",0Dh,0Ah
		 DB "Address: Riyadh - Al-Muraba - King Abdul Aziz Historical Center",0Dh,0Ah
		 DB "Working hours: 12:00 - 8:00",0Dh,0Ah
         DB "Website: www.nationalmuseum.org",0Dh,0Ah,'$'


museum_prices:
         DB 0Dh,0Ah,"1- The museum prices are:",0Dh,0Ah
         DB "The ticket                  Price",0Dh,0Ah
         DB "Under 6 years old           25 SR",0Dh,0Ah 
		 DB "Between 7 and 18 years old  45 SR",0Dh,0Ah
         DB "Adults                      75 SR",0Dh,0Ah
         DB "Seiners                     35 SR",0Dh,0Ah,'$'

Special_offers:
         DB "2- Special offers:",0Dh,0Ah
         DB "The ticket              Price",0Dh,0Ah
         DB "School trip             15 SR per student",0Dh,0Ah 
         DB "Tourist group           45 SR per adult",0Dh,0Ah
         DB "Family above 7 persons  25 SR per person",0Dh,0Ah,'$'

museum_choice: DB 0Dh,0Ah,"What offer would you like to buy (1-normal museum prices  , 2-Special offers)? ",'$'
ticket:        DB 0Dh,0Ah,"What ticket would you like to buy (1-child(<6) , 2-child(7-18), 3-adult , 4-seiners)? ",'$'
offer:         DB 0Dh,0Ah,"what offer do you want to buy (1-School trip, 2-Tourist group, 3-Family >7 ) ",'$'
ticket_number: DB 0Dh,0Ah,"How many ticket do you want to buy ",'$'
wrong_msg:     DB 0Dh,0Ah,"Family tickets must be above 7",'$'

child_6        DD 25 ; child Price Under 6 years old
child_7_18     DD 45 ; child Price Between 7 and 18 years old      
adult          DD 75 ; adult Price 
seiners        DD 35 ; seiners Price 

student_Price  DD 15  ; Price for School trip       
Tourist_Price  DD 45  ; Price for Tourist group
Family_Price   DD 25  ; Price for Family above 7 persons

museum_type    DB 0
ticket_type    DB 0
offer_type     DB 0
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
      
;===== Get a museum info =====
FIRST_CHOICE:
      ; Code to display the theaters_info message
      mov dx, offset museum_info
      mov ah, 9
      int 21h

      mov dx, offset CRLF
      MOV AH,9
      INT 21H  
      
      ; return to menu
      jmp start

;===== book a ticket =====
SECOND_CHOICE:
      ; Code to display the museum prices
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset museum_prices
      mov ah, 9
      int 21h 
         
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      
      mov dx, offset Special_offers
      mov ah, 9
      int 21h

      mov dx, offset museum_choice
      mov ah, 9
      int 21h
      
      ; Get the museum offer type 
      MOV AH, 1
      INT 21H
      mov museum_type, al

      ; check the museum type
      cmp museum_type, '1'
      jne  Special_offers_ticket	  
	  
      ; Code to display the ticket_type message
      mov dx, offset ticket
      mov ah, 9
      int 21h

      ; Get the ticket type 
      MOV AH, 1
      INT 21H
      mov ticket_type, al
	  
	  jmp Get_ticket_num
	  
    Special_offers_ticket:
      ; Code to display the ticket_type message
      mov dx, offset offer
      mov ah, 9
      int 21h
	  
      ; Get the offer type 
      MOV AH, 1
      INT 21H
      mov offer_type, al
	  
	Get_ticket_num:  
      ; Code to display the ticket_number message
      mov dx, offset ticket_number
      mov ah, 9
      int 21h
	  
      ; Get the ticket number      
      call INDEC
      mov ticket_num, ax


      ; check the museum type
      cmp museum_type, '1'
      je  normal_prices
      cmp museum_type, '2'
      je Special_offers_prices
      jmp SECOND_CHOICE
       
  ; code for the normal_prices
  normal_prices:
      ; child 6 ticket
      cmp ticket_type, '1'
      jne child_7_18_ticket
	  mov ax, child_6
      mov ticket_price, ax
	  jmp calculate
	  
      ; child 7_18 ticket
    child_7_18_ticket:
      cmp ticket_type, '2'
      jne ADULT_ticket
	  mov ax, child_7_18
      mov ticket_price, ax
      jmp calculate
 
      ; adult ticket
    ADULT_ticket:
      cmp ticket_type, '3'
      jne SEINERS_ticket
	  mov ax, adult
      mov ticket_price, ax
	  jmp calculate
	  
      ; seiners ticket
    SEINERS_ticket:
      cmp ticket_type, '4'
      jne SECOND_CHOICE
	  mov ax, seiners
      mov ticket_price, ax
	  jmp calculate


  ; code for the Special_offers_prices
  Special_offers_prices:
      ; student ticket
      cmp offer_type, '1'
      jne Tourist_ticket_type
	  mov ax, student_Price
      mov ticket_price, ax
      jmp calculate	  
      
      ; Tourist ticket
    Tourist_ticket_type:
      cmp offer_type, '2'
      jne Family_ticket_type
	  mov ax, Tourist_Price
      mov ticket_price, ax
      jmp calculate
      
      ; Family  ticket
    Family_ticket_type:
	  cmp ticket_num, 7
	  jle wrong
      cmp offer_type, '3'
      jne SECOND_CHOICE
	  mov ax, Family_Price
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
       
	  mov result, 0
	   
      jmp start
    
    wrong:
      mov dx, offset wrong_msg
      MOV AH,9
      INT 21H
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