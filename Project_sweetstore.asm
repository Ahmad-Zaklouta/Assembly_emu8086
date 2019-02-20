org 100h

.model small 

.stack 100h

.data


menu:    DB 0Dh,0Ah,"1- Make an order",0Dh,0Ah
         DB "2- Check for a  price",0Dh,0Ah 
         DB "3- Exit",0Dh,0Ah,
         DB "please choose: ", '$'

CrLf     DB 13,10,'$'  ; print newline
         
totalbill: DB 0Dh,0Ah,"the total bill is: ",'$'

sweet_info:   
         DB 0Dh,0Ah,0Dh,0Ah,"1- Cupcakes          30 SR",0Dh,0Ah
         DB "2- Cheese Cake       40 SR",0Dh,0Ah
         DB "3- Tiramisu Cake     20 SR",0Dh,0Ah,'$'
		 
enter_order DB 0Dh,0Ah,"enter the order number and 0 at end: ", '$'


sweet_order   DB 255 DUP ('$')
sweet_price   DD 0    
              
.code

begin:
      mov ax,@data
      mov ds,ax  
      
start: 
      mov dx, offset CRLF
      MOV AH,9
      INT 21H 
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
      
;===== Make an order =====
FIRST_CHOICE:
      ; Code to display the sweet_info message
      mov dx, offset sweet_info
      mov ah, 9
      int 21h

      mov dx, offset CrLf
      mov ah, 9
      int 21h
	  
      LEA SI, sweet_order
  get_order:
      LEA DX, enter_order
      MOV AH,9
      INT 21H
	  
      mov ah,1
      int 21h
      
      MOV [SI],al
      INC SI
	  cmp al, '0'  ; is it 0?
      je start
	  jmp get_order
      
;===== calc price =====
SECOND_CHOICE:

      LEA SI, sweet_order
    fetch_order:  
	  mov al, [SI]
	  inc SI
	  
	  cmp al, '0'
	  je finish
	  cmp al, '1'
	  je Cupcakes 
	  cmp al, '2'
      je  Cheese_Cake   
	  cmp al, '3'
	  je Tiramisu_Cake  

	Cupcakes:
	  add sweet_price, 30
	  jmp fetch_order
	Cheese_Cake:         
	  add sweet_price, 40 
	  jmp fetch_order
	Tiramisu_Cake:
	  add sweet_price, 20 
	  jmp fetch_order

    finish:
      ; Code to display the total bill message
      mov dx, offset CRLF
      MOV AH,9
      INT 21H
      mov dx, offset totalbill
      MOV AH,9
      INT 21H      
      
      mov ax, sweet_price
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