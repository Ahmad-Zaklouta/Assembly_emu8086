org 100h

.model small 

.stack 100h

.data

    
menu:    DB 0Dh,0Ah,"1- Small amount of information about the zoo :",0Dh,0Ah
         DB "2- Book a ticket",0Dh,0Ah 
         DB "3- Exit the application",0Dh,0Ah,
         DB "please choose: ", '$'

newline:  db 13,10,'$'  ; print newline
         
totalbill: DB 0Dh,0Ah,"the total bill is: ",'$'

zoo_info:
         DB 0Dh,0Ah,0Dh,0Ah,"Riyadh National Zoo, in the heart of Malaz in Riyadh,",0Dh,0Ah
		 DB "is an easily accessible travel location for those visiting the city of Riyadh.",0Dh,0Ah
		 DB "At the beautifully spread out landscape and marvelously set terrains, this",0Dh,0Ah
		 DB "zoological park has an area of 55 acres and consist of more than 1500 animals",0Dh,0Ah
		 DB "in 40 species that let one's good amount of time to be spent in ananimal world.",0Dh,0Ah
		 DB "Working hours: 12:00 - 8:00",0Dh,0Ah
         DB "Website: http://www.zoo.com.sa/",0Dh,0Ah,'$'


zoo_prices:
         DB 0Dh,0Ah,"1- The zoo prices are:",0Dh,0Ah
         DB "The ticket                  Price",0Dh,0Ah
         DB "Under 6 years old           8  USD",0Dh,0Ah 
		 DB "Between 7 and 18 years old  10 USD",0Dh,0Ah
         DB "Adults                      15 USD",0Dh,0Ah
         DB "Seiners                     5  USD",0Dh,0Ah,'$'

zoo_Special_offers:
         DB "2- Special offers:",0Dh,0Ah
         DB "The ticket              Price",0Dh,0Ah
         DB "School trip             5 USD per student",0Dh,0Ah 
		 DB "Family above 8 persons  12 USD per person",0Dh,0Ah
         DB "Tourist group           12 USD per person",0Dh,0Ah,'$'

zoo_choice:    DB 0Dh,0Ah,"What zoo offer would you like to buy (1-normal zoo prices  , 2-zoo Special offers)? ",'$'
ticket:        DB 0Dh,0Ah,"What zoo ticket would you like to buy (1-child(<6) , 2-child(7-18), 3-adult , 4-seiners)? ",'$'
offer:         DB 0Dh,0Ah,"what zoo offer do you want to buy (1-School trip, 2-Family above 8, 3-Tourist group) ",'$'
ticket_number: DB 0Dh,0Ah,"How many zoo ticket do you want to buy ",'$'
wrong_msg:     DB 0Dh,0Ah,"Family tickets must be above 8",'$'

zoo_child_6        DD 8 ; child Price Under 6 years old
zoo_child_7_18     DD 10 ; child Price Between 7 and 18 years old      
zoo_adult          DD 15 ; adult Price 
zoo_seiners        DD 5 ; seiners Price 

zoo_student_Price  DD 5  ; Price for School trip       
zoo_Tourist_Price  DD 12  ; Price for Tourist group
zoo_Family_Price   DD 12  ; Price for Family above 8 persons

zoo_type       DB 0
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
      
;===== Get a zoo info =====
FIRST_CHOICE:
      ; Code to display the theaters_info message
      mov dx, offset zoo_info
      mov ah, 9
      int 21h

      mov dx, offset newline
      MOV AH,9
      INT 21H  
      
      ; return to menu
      jmp start

;===== book a ticket =====
SECOND_CHOICE:
      ; Code to display the zoo prices
      mov dx, offset newline
      MOV AH,9
      INT 21H
      mov dx, offset zoo_prices
      mov ah, 9
      int 21h 
         
      mov dx, offset newline
      MOV AH,9
      INT 21H
      
      mov dx, offset zoo_Special_offers
      mov ah, 9
      int 21h

      mov dx, offset zoo_choice
      mov ah, 9
      int 21h
      
      ; Get the zoo offer type 
      MOV AH, 1
      INT 21H
      mov zoo_type, al

      ; check the zoo type
      cmp zoo_type, '1'
      jne  zoo_Special_offers_ticket	  
	  
      ; Code to display the ticket_type message
      mov dx, offset ticket
      mov ah, 9
      int 21h

      ; Get the ticket type 
      MOV AH, 1
      INT 21H
      mov ticket_type, al
	  
	  jmp Get_ticket_num
	  
    zoo_Special_offers_ticket:
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


      ; check the zoo type
      cmp zoo_type, '1'
      je  zoo_normal_prices
      cmp zoo_type, '2'
      je zoo_Special_offers_prices
      jmp SECOND_CHOICE
       
  ; code for the zoo_normal_prices
  zoo_normal_prices:
      ; zoo_child 6 ticket
      cmp ticket_type, '1'
      jne zoo_child_7_18_ticket
	  mov ax, zoo_child_6
      mov ticket_price, ax
	  jmp calculate
	  
      ; zoo_child 7_18 ticket
    zoo_child_7_18_ticket:
      cmp ticket_type, '2'
      jne zoo_ADULT_ticket
	  mov ax, zoo_child_7_18
      mov ticket_price, ax
      jmp calculate
 
      ; zoo_adult ticket
    zoo_ADULT_ticket:
      cmp ticket_type, '3'
      jne zoo_SEINERS_ticket
	  mov ax, zoo_adult
      mov ticket_price, ax
	  jmp calculate
	  
      ; zoo_seiners ticket
    zoo_SEINERS_ticket:
      cmp ticket_type, '4'
      jne SECOND_CHOICE
	  mov ax, zoo_seiners
      mov ticket_price, ax
	  jmp calculate


  ; code for the zoo_Special_offers_prices
  zoo_Special_offers_prices:
      ; student ticket
      cmp offer_type, '1'
      jne zoo_Tourist_ticket_type
	  mov ax, zoo_student_Price
      mov ticket_price, ax
      jmp calculate	  
      
      ; Family  ticket
    zoo_Family_ticket_type:
	  cmp ticket_num, 8
	  jle wrong
      cmp offer_type, '2'
      jne SECOND_CHOICE
	  mov ax, zoo_Family_Price
      mov ticket_price, ax
	  jmp calculate

      ; Tourist ticket
    zoo_Tourist_ticket_type:
      cmp offer_type, '3'
      jne zoo_Family_ticket_type
	  mov ax, zoo_Tourist_Price
      mov ticket_price, ax
      jmp calculate
	  
      ; calculate price
    calculate:  ; zoo_ticket_num * zoo_ticket_price
      mov cx, ticket_num
	  mov ax, ticket_price
      mul cx  ; ticket_num * ticket_price
      mov result, ax
      
      ; Code to display the total bill message
      mov dx, offset newline
      MOV AH,9
      INT 21H
      mov dx, offset totalbill
      MOV AH,9
      INT 21H      
      
      mov ax, result
      call OUTDEC
      
      mov dx, offset newline
      MOV AH,9
      INT 21H
      
	  mov result,0        
      jmp start
    
    wrong:
      mov dx, offset wrong_msg
      MOV AH,9
      INT 21H
      mov dx, offset newline
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