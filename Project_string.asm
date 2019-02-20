org 100h

.model small 

.stack 100h

.data

NEWLINE    DB 10,13,"$"

   
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- Please enter Your string.",0Dh,0Ah
           DB "2- Menu",0Dh,0Ah 
           DB "3- Exit",0Dh,0Ah
           DB "Please choose an option: ",'$'
		   
menu1      DB 0Dh,0Ah,0Dh,0Ah,"1- print string in reverse order.",0Dh,0Ah
           DB "2- print how many vowels letter in the string",0Dh,0Ah
           DB "Please choose an option: ",'$'
               


enter_str  DB 0Dh,0Ah,"Please type a string and press Enter(10 characters): ", '$'		   
rev_no_str DB 0Dh,0Ah,"Reverse of the string is: ", '$'
vowel_num  DB 0Dh,0Ah,"Number of vowels in the string is: ", '$'

string_in   DB 11 DUP ('$')
string_rev  DB 11 DUP ('$')
vowels      DB 0

.code

begin:
      mov ax,@data
      mov ds,ax

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
      ; loop back to get_choice until the user choose
      jmp get_choice
;================================================ 

FIRST_CHOICE:
      MOV AH,09H
      LEA DX,enter_str
      INT 21H 
      
      LEA SI, string_in 
  get_string:
      mov ah, 01h           
      int 21h               
    
      cmp al,13      ; is it enter key
      je continue    
      mov [SI], al
      inc SI
	  jmp get_string
	
  continue:
    jmp start
;================================================ 
      
SECOND_CHOICE:
      MOV AH,09H
      LEA DX,menu1
      INT 21H 
	  
      ; read the user choice
      mov ah, 7
      int 21h
      
      cmp al, '1'
      je  REVERSE_CHOICE
      cmp al, '2'
      je  VOWELS_CHOICE	  

    REVERSE_CHOICE:
      LEA SI, string_in
      LEA DI, string_rev      
      MOV DL, 10
      MOV DH,0
      ADD SI, DX
      DEC SI
      MOV CL, 10
      MOV CH, 0
      
    REVERSE:
      MOV AL,[SI]
      MOV [DI],AL
      INC DI
      DEC SI
      LOOP REVERSE
	  
      MOV AH,09H
      LEA DX, rev_no_str
      INT 21H
       
      MOV AH,09H
      LEA DX, string_rev
      INT 21H      
      jmp start

    VOWELS_CHOICE:
	  LEA SI, string_in
	  MOV CL, 10
      MOV CH, 0
	check_vowels:
	  MOV AL, [SI]
	  cmp AL,'$'
      je FINAL  
	  cmp al,'A'
	  je count   
	  cmp al,'E'
	  je count   
	  cmp al,'I'
	  je count   
	  cmp al,'O'
	  je count   
	  cmp al,'U'
	  je count
	  cmp al,'a'
	  je count   
	  cmp al,'e'
	  je count   
	  cmp al,'i'
	  je count   
	  cmp al,'o'
	  je count   
	  cmp al,'u'
	  je count   
	  inc si
	  jmp check_vowels
	  
	count: 
	  inc bl
	  inc si
	  jmp check_vowels
      
    final:
	  mov vowels, bl
	  
      MOV AH,09H
      LEA DX,vowel_num
      INT 21H 
	  
      mov ah, 0
	  mov al, vowels
	  
	  call OUTDEC
	
	  jmp start
	  
	    
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