org 100h

.model small 

.stack 100h

.data

intro  DB "- String-OpApplication -",0Dh,0Ah
       DB "*************************",0Dh,0Ah,'$'

NEWLINE    DB 10,13,"$"  
   
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- Enter the string.",0Dh,0Ah
           DB "2- Display the string.",0Dh,0Ah 
           DB "3- Display the length of string.",0Dh,0Ah
           DB "4- Display the number of uppercase letters.",0Dh,0Ah,
           DB "5- Display the number of lowercase letters.",0Dh,0Ah,
           DB "6- Display the number of numbers characters.",0Dh,0Ah,
           DB "7- Display the number of special characters.",0Dh,0Ah,
           DB "8- Reverse of the string.",0Dh,0Ah,
           DB "9- Summarize",0Dh,0Ah,
           DB "Please choose an option: ",'$'

enter_str  DB 0Dh,0Ah,0Dh,0Ah,"Please type a string and press Enter: ", '$'
disp_str   DB 0Dh,0Ah,0Dh,0Ah,"The string is: ", '$'
len_str    DB 0Dh,0Ah,0Dh,0Ah,"The length of string is: ", '$'
upp_no_str DB 0Dh,0Ah,0Dh,0Ah,"The number of uppercase letters is: ", '$'
low_no_str DB 0Dh,0Ah,0Dh,0Ah,"The number of lowercase letters is: ", '$'
num_no_str DB 0Dh,0Ah,0Dh,0Ah,"The number of numbers characters is: ", '$'
chr_no_str DB 0Dh,0Ah,0Dh,0Ah,"The number of special characters is: ", '$'
rev_no_str DB 0Dh,0Ah,0Dh,0Ah,"Reverse of the string is: ", '$'
palind_not DB 0Dh,0Ah,"THE STRING IS NOT A PALINDROME",0Dh,0Ah, '$'
palindrome DB 0Dh,0Ah,"THE  STRING IS A PALINDROME",0Dh,0Ah, '$'
summ_str   DB 0Dh,0Ah,0Dh,0Ah,"Summary:",0Dh,0Ah, '$'
           
string_in     DB 255 DUP ('$')
string_rev    DB 255 DUP ('$')         
string_length DB 0
string_upp    DB 0
string_low    DB 0
string_num    DB 0
string_char   DB 0
palind_or_not DB 0
result        DB 10 DUP ('$') 

.code

begin:
      mov ax,@data
      mov ds,ax

      ; print message for the header
      MOV AH,09H
      LEA DX,intro
      INT 21H
;================================================ 

start:
 
      ;code to choose one choice from the menu
      MOV AH,09H
      LEA DX,menu
      INT 21H
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
 
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

      ; fifth choice
      cmp al, '5'
      je  FIFTH_CHOICE

      ; six choice
      cmp al, '6'
      je  SIXTH_CHOICE

      ; seventh choice
      cmp al, '7'
      je  SEVENTH_CHOICE

      ; eighth choice
      cmp al, '8'
      je  EIGHTH_CHOICE

      ; ninth choice
      cmp al, '9'
      je  NINTH_CHOICE 
      
      ; loop back to get_choice until the user choose
      jmp get_choice
;================================================ 

FIRST_CHOICE:
      ; print a new line
      MOV AH,09H
      LEA DX,enter_str
      INT 21H 
      
      mov string_length, 0
      mov string_upp, 0
      mov string_low, 0
      mov string_num, 0
      mov string_char, 0
      mov palind_or_not, 0
      
      LEA SI, string_in 
  get_string:
    mov ah, 01h           ; read character from standard input, with echo
    int 21h               ; call the interrupt handler 0x21
    
    cmp al,13             ; is it enter key
    je continue
    cmp al,32             ; is it space key
    je get_string    
    mov [SI], al
    inc SI
    
    ; count the number of letter 
    inc string_length
    
    ; check for uppercase letter
    cmp al,'A'
    jb done_upp
    cmp al,'Z'
    ja done_upp
    inc string_upp
    jmp get_string
  done_upp:      
  
    ; check for lowercase letter
    cmp al,'a'
    jb done_low
    cmp al,'z'
    ja done_low
    inc string_low
    jmp get_string
  done_low:    
  
    ; check for number
    cmp al,'0'
    jb done_num
    cmp al,'9'
    ja done_num
    inc string_num
    jmp get_string
  done_num:
    
    ; Not uppercase nor lowercase nor number (special character)
    inc string_char
    jmp get_string 
    
  continue:

    jmp start
;================================================ 
      
SECOND_CHOICE:

      MOV AH,09H
      LEA DX,disp_str
      INT 21H 
      
      MOV AH,09H
      LEA DX,string_in
      INT 21H 

    jmp start
;================================================ 
      
THIRD_CHOICE:

      MOV AH,09H
      LEA DX, len_str
      INT 21H 
      
      MOV AH, 0
      MOV AL, string_length
     
    jmp PRINT_RESULT       
;================================================     
 
FORTH_CHOICE:

      MOV AH,09H
      LEA DX, upp_no_str
      INT 21H 
      
      MOV AH, 0
      MOV AL, string_upp
     
    jmp PRINT_RESULT  
;================================================ 

FIFTH_CHOICE:

      MOV AH,09H
      LEA DX, low_no_str
      INT 21H 
      
      MOV AH, 0
      MOV AL, string_low
     
    jmp PRINT_RESULT  
;================================================
 
SIXTH_CHOICE:

      MOV AH,09H
      LEA DX, num_no_str
      INT 21H 
      
      MOV AH, 0
      MOV AL, string_num
     
    jmp PRINT_RESULT  
;================================================ 

SEVENTH_CHOICE:

      MOV AH,09H
      LEA DX, chr_no_str
      INT 21H 
      
      MOV AH, 0
      MOV AL, string_char
     
    jmp PRINT_RESULT  
;================================================ 

EIGHTH_CHOICE:

      LEA SI, string_in
      LEA DI, string_rev      
      MOV DL, string_length
      MOV DH,0
      ADD SI, DX
      DEC SI
      MOV CL, string_length
      MOV CH, 0
      
  REVERSE:
      MOV AL,[SI]
      MOV [DI],AL
      INC DI
      DEC SI
      LOOP REVERSE

      LEA SI, string_in
      LEA DI, string_rev   
      MOV CL, string_length
      MOV CH,0
      
  CHECK:
      MOV AL,[SI]
      CMP [DI],AL
      JNE not_palindrome
      INC DI
      INC SI
      LOOP CHECK
      
      MOV palind_or_not, 1      
      MOV AH,09H
      LEA DX, palindrome
      INT 21H        
      MOV AH,09H
      LEA DX, string_in
      INT 21H 
      jmp start
      
  not_palindrome:
      MOV AH,09H
      LEA DX, palind_not
      INT 21H        
      MOV AH,09H
      LEA DX, string_rev
      INT 21H 
      
      jmp start
;================================================ 

NINTH_CHOICE:
      MOV AH,09H
      LEA DX, summ_str
      INT 21H 
      
      ; Print the string
      MOV AH,09H
      LEA DX,disp_str
      INT 21H      
      MOV AH,09H
      LEA DX,string_in
      INT 21H    
      
      ; Print the length of the string
      MOV AH,09H
      LEA DX, len_str
      INT 21H      
      MOV AH, 0
      MOV AL, string_length
      ; convert decimal to hex to print result
      LEA SI, result
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
      ; Print result
      LEA DX,result
      MOV AH,9
      INT 21H      
      
      ; Print if palindrome or not
      cmp palind_or_not, 1
      jne no_palindrome
      LEA DX, palindrome
      INT 21H        
      MOV AH,09H
    no_palindrome:
      ;printing new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      LEA DX, palind_not
      INT 21H        
      MOV AH,09H
      
      jmp finish
;================================================

PRINT_RESULT:
      ; convert decimal to hex to print result
      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP11: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP11
      ADD AL,30H
      MOV [SI],AL
    LOOP22: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP22
    
      ; Print result
      LEA DX,result
      MOV AH,9
      INT 21H
      
      ;printing new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      
      jmp start
      
finish:
      mov ah,1
      int 21h
      mov ah,4Ch
      int 21h
