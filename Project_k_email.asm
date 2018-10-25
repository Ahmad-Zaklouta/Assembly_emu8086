org 100h

.model small 

.stack 100h

.data

header DB "- Email Application -",0Dh,0Ah
       DB "*************************",'$' 
       
NEWLINE    DB 10,13,"$"
      
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- sign up.",0Dh,0Ah
           DB "2- sign in.",0Dh,0Ah 
           DB "3- Change password.",0Dh,0Ah
           DB "4- Display information.",0Dh,0Ah,
           DB "5- Exit.",0Dh,0Ah,
           DB "Please enter your choice: ",'$'

email_rule DB 0Dh,0Ah,0Dh,0Ah,"The Email name should be maximum 10 length characters (it can be only: A-Z/a-z/0-9) CASE SENSITIVE.",0Dh,0Ah
           DB "Email name should look like like: (----10charcaters---@ABC.com)",'$'
           
type_email DB 0Dh,0Ah,0Dh,0Ah,"Please type your email here: ",'$'

pass_rule  DB 0Dh,0Ah,0Dh,0Ah,"The password must be only 5 letters (a-z /A-Z) CASE SENSITIVE.",'$' 

type_pass  DB 0Dh,0Ah,"Please type your password here and press Enter: ",'$'

sign_in_type_pass DB 0Dh,0Ah,0Dh,0Ah,"Please type your current password here: ",'$'

new_pass   DB 0Dh,0Ah,"Please type your new password here and press Enter: ",'$'

succeed    DB 0Dh,0Ah,0Dh,0Ah,"sign-in is succeed.",0Dh,0Ah,'$'

new_pass_succeed    DB 0Dh,0Ah,0Dh,0Ah,"Change password successful",0Dh,0Ah,'$'

worng_pass DB 0Dh,0Ah,0Dh,0Ah,"Wrong Password",0Dh,0Ah,'$'

worng_email DB 0Dh,0Ah,0Dh,0Ah,"Wrong Email",0Dh,0Ah,'$'

your_email DB 0Dh,0Ah,"Your Email is: ",'$'

your_pass DB 0Dh,0Ah,"Your Password is: ",'$'

change_pass DB 0Dh,0Ah,"Your Password changed is: ",'$'

timeout    DB 0Dh,0Ah,"time is out, try in another time.",0Dh,0Ah,'$' 
exit       DB 0Dh,0Ah,"Press Enter to Exit",'$'

information DB 0Dh,0Ah,"Information about the Email:",0Dh,0Ah,'$'
           
email        DB 19 DUP ('$')
password     DB 6 DUP ('$')
email_length DB 0
pass_length  DB 0
attempt      DB 0
password_change DB 0


.code

begin:
      mov ax,@data
      mov ds,ax

      ; print message for the header
      MOV AH,09H
      LEA DX,header
      INT 21H
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H

;================================================ 

  start:
      
      ;code to choose one choice from the menu
      MOV AH,09H
      LEA DX,menu
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
      
      ; loop back to get_choice until the user choose
      jmp get_choice
;================================================ 

FIRST_CHOICE:
    mov email_length, 0
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg

;====================== 
; === Get The email ===
;======================    
    ;code to print enter email msg
    MOV AH, 09H
    LEA DX, email_rule
    INT 21H
    MOV AH, 09H
    LEA DX, type_email
    INT 21H      
      
    LEA SI, email 
    mov bl, 0
    mov cl, 0
  get_email: 
     
    ; read user input
    mov ah, 01h         
    int 21h               

    cmp al, 64      ; is it @ key
    je at_symbol    ; yes
    
    cmp cl, 1      
    je rest_of_Email    

    ; check for uppercase letter A-Z
    cmp al,'A'
    jb done_upp
    cmp al,'Z'
    ja done_upp
    jmp valid_in
  done_upp:      
  
    ; check for lowercase letter a-z
    cmp al,'a'
    jb done_low
    cmp al,'z'
    ja done_low
    jmp valid_in
  done_low:    
  
    ; check for number 0-9
    cmp al,'0'
    jb done_num
    cmp al,'9'
    ja done_num
    jmp valid_in
  done_num:
  
    jmp wrong_msg  ; Not (A-Z, a-z, 0-9)
    

  at_symbol:
    mov email_length, bl  ; store the email length
    cmp email_length, 10  ; is the email longer than 10 character
    jg wrong_msg
    mov bl, 0
    mov cl, 1
    jmp valid_in
    
  rest_of_Email:   ; (ABC.com)
    cmp bl, 1  ; is it the character (A)
    je check_A_symbol

    cmp bl, 2  ; is it the character (B)
    je check_B_symbol

    cmp bl, 3  ; is it the character (Big C)
    je check_BC_symbol

    cmp bl, 4  ; is it the character (.)
    je check_dot_symbol

    cmp bl, 5  ; is it the character (small c)
    je check_sc_symbol

    cmp bl, 6  ; is it the  character (o)
    je check_O_symbol

    cmp bl, 7  ; is it the  character (m)
    je check_M_symbol    

    jmp wrong_msg  ; Not (ABC.com)
    
    ; check for A symbol
  check_A_symbol:
    cmp al, 65      ; is it A key
    je valid_in     ; yes
    jmp wrong_msg   ; no

    ; check for B symbol
  check_B_symbol:
    cmp al, 66      ; is it B key
    je valid_in     ; yes
    jmp wrong_msg   ; no

    ; check for big C symbol
  check_BC_symbol:
    cmp al, 67      ; is it big C key
    je valid_in     ; yes
    jmp wrong_msg   ; no

    ; check for . (dot)symbol
  check_dot_symbol:
    cmp al, 46      ; is it . key
    je valid_in     ; yes
    jmp wrong_msg   ; no

    ; check for small c symbol
  check_sc_symbol:
    cmp al, 99      ; is it small c key
    je valid_in     ; yes
    jmp wrong_msg   ; no
    
    ; check for o symbol
  check_o_symbol:
    cmp al, 111      ; is it o key
    je valid_in      ; yes
    jmp wrong_msg    ; no

    ; check for m symbol
  check_m_symbol:
    cmp al, 109                ; is it m key
    je go_to_get_password      ; yes
    jmp wrong_msg              ; no 
  
  valid_in:
    ; store the input
    mov [SI], al
    inc SI
    ; count the number of letter 
    inc bl
    jmp get_email  
  
  wrong_msg:
    ; Wrong Email msg
    MOV AH,09H
    LEA DX, worng_email
    INT 21H
 
    inc attempt  ; Count the failed attempt in email
    jmp FIRST_CHOICE ; go to FIRST_CHOICE again
    
  go_to_get_password:
    mov [SI], al  ; store the last letter (m)
    
;========================= 
; === Get The Password ===
;=========================
  get_password:
    mov pass_length, 0
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg
    
    ;code to print enter password msg
    MOV AH,09H
    LEA DX, pass_rule
    INT 21H
    MOV AH,09H
    LEA DX, type_pass
    INT 21H      
      
    LEA SI, password

  get_pass:
    ; read user input
    mov ah, 01h         
    int 21h     

    cmp al, 13  ; is it Enter?
    je continue
    
    ; check for uppercase letter A-Z
    cmp al,'A'
    jb pass_done_upp
    cmp al,'Z'
    ja pass_done_upp
    jmp pass_valid_in
  pass_done_upp:      
  
    ; check for lowercase letter a-z
    cmp al,'a'
    jb pass_done_low
    cmp al,'z'
    ja pass_done_low
    jmp pass_valid_in
  pass_done_low: 
  
    jmp pass_wrong_msg   ; Not (A-Z, a-z)
    
  pass_valid_in:
    ; store the input
    mov [SI], al
    inc SI
    ; count the number of letter 
    inc pass_length
    jmp get_pass  

  continue:   ; The use finishd typing the password
    ; Check if password have the right length
    cmp pass_length, 5  ; is it 5 letter?
    je start
    jmp pass_wrong_msg
    
  pass_wrong_msg:
    ; Wrong pass msg
    MOV AH,09H
    LEA DX, worng_pass
    INT 21H
 
    inc attempt  ; Count the failed attempt in password 
    jmp get_password ; go to get_password again  
;================================================ 
      
SECOND_CHOICE:
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg

    ; get the email
    MOV AH, 09H
    LEA DX, type_email
    INT 21H      
      
    LEA SI, email 
    mov bl, 0   ; initilaize the counter
    mov cl, email_length
    add cl, 8   ; email length + @ABC.com (8 character)
  get_email_sign_in:  
    ; read user input
    mov ah, 01h         
    int 21h
    
    cmp al, [SI]  ; compare the user input with the email
    jne wrong_email_sign_in
    inc SI 
    inc bl
    cmp bl, cl
    je sign_in_get_password  ; getting the email is finished. go to get the pasword
    jmp get_email_sign_in

  wrong_email_sign_in:
    ; Wrong email msg
    MOV AH,09H
    LEA DX, worng_email
    INT 21H
    inc attempt  ; Count the failed attempt in sign in 
    jmp SECOND_CHOICE ; go to SECOND_CHOICE again  
    
  sign_in_get_password:
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg
    
    MOV AH,09H
    LEA DX, sign_in_type_pass
    INT 21H

    LEA SI, password 
    mov bl, 0   ; initilaize the counter
    
  ; get the password  
  get_pass_sign_in:  
    ; read user input
    mov ah, 01h         
    int 21h
    
    cmp al, [SI]  ; compare the user input with the password
    jne wrong_pass_sign_in
    inc SI  
    inc bl
    cmp bl, 5
    je successful
    jmp get_pass_sign_in   

  wrong_pass_sign_in:
    ; Wrong pass msg
    MOV AH,09H
    LEA DX, worng_pass
    INT 21H   

    inc attempt  ; Count the failed attempt in sign in 
    jmp sign_in_get_password ; go to sign_in_get_password again

  successful:
    ; successful sign in msg  
    MOV AH,09H
    LEA DX, succeed
    INT 21H  

    jmp start
;================================================ 
      
THIRD_CHOICE:
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg
    
    MOV AH,09H
    LEA DX, sign_in_type_pass
    INT 21H

    LEA SI, password 
    mov bl, 0   ; initilaize the counter
  ; get the password  
  get_pass_change:  
    ; read user input
    mov ah, 01h         
    int 21h
    
    cmp al, [SI]  ; compare the user input with the password
    jne wrong_pass_change
    inc SI  
    inc bl
    cmp bl, 5
    je get_new_password
    jmp get_pass_change   

  wrong_pass_change:
    ; Wrong pass msg
    MOV AH,09H
    LEA DX, worng_pass
    INT 21H   

    inc attempt  ; Count the failed attempt in sign in 
    jmp THIRD_CHOICE ; go to THIRD_CHOICE again

 
  get_new_password:
    mov pass_length, 0
    cmp attempt, 5       ; is it more than 5 failed attempt
    jg timeout_msg
    
    ;code to print enter password msg
    MOV AH,09H
    LEA DX, pass_rule
    INT 21H
    MOV AH,09H
    LEA DX, new_pass
    INT 21H      
      
    LEA SI, password

  get_new_pass:
    ; read user input
    mov ah, 01h         
    int 21h     

    cmp al, 13  ; is it Enter?
    je new_pass_continue
    
    ; check for uppercase letter A-Z
    cmp al,'A'
    jb new_pass_done_upp
    cmp al,'Z'
    ja new_pass_done_upp
    jmp new_pass_valid_in
  new_pass_done_upp:      
  
    ; check for lowercase letter a-z
    cmp al,'a'
    jb new_pass_done_low
    cmp al,'z'
    ja new_pass_done_low
    jmp new_pass_valid_in
  new_pass_done_low: 
  
    jmp new_pass_wrong_msg   ; Not (A-Z, a-z)
    
  new_pass_valid_in:
    ; store the input
    mov [SI], al
    inc SI
    ; count the number of letter 
    inc pass_length
    jmp get_new_pass  

  new_pass_continue:   ; The use finishd typing the password
    ; Check if password have the right length
    cmp pass_length, 5  ; is it 5 letter?
    je successful_change:
    jmp new_pass_wrong_msg
    
  new_pass_wrong_msg:
    ; Wrong pass msg
    MOV AH,09H
    LEA DX, worng_pass
    INT 21H
 
    inc attempt  ; Count the failed attempt in password 
    jmp get_new_password ; go to get_password again   
  
  successful_change:
    inc password_change
    MOV AH,09H
    LEA DX, new_pass_succeed
    INT 21H  

    jmp start    
;================================================     
 
FORTH_CHOICE:
    ; print information msg
    MOV AH,09H
    LEA DX, information
    INT 21H
    ; print your_email msg
    MOV AH,09H
    LEA DX, your_email
    INT 21H
    ; print email
    MOV AH,09H
    LEA DX, email
    INT 21H
    ; print your_pass msg
    MOV AH,09H
    LEA DX, your_pass
    INT 21H
    ; print password
    MOV AH,09H
    LEA DX, password
    INT 21H
    ; print change_pass msg 
    MOV AH,09H
    LEA DX, change_pass
    INT 21H 
    
    mov al, password_change
    add al, 48
    MOV AH,02H
    mov Dl, al
    INT 21H   
    
    jmp finish
;================================================ 

FIFTH_CHOICE:
    jmp finish
;================================================

timeout_msg:
      MOV AH,09H
      LEA DX, timeout
      INT 21H  
      MOV AH,09H
      LEA DX, exit
      INT 21H       
finish:
      MOV AH,09H
      LEA DX, exit
      INT 21H  
      mov ah,1
      int 21h
      mov ah,4Ch
      int 21h
