org 100h

.model small 

.stack 100h

.data


menu:    DB 0Dh,0Ah,"- Apple Application -",0Dh,0Ah
         DB "************************",0Dh,0Ah
         DB "1- Make an order",0Dh,0Ah
         DB "2- Display the Bill",0Dh,0Ah 
         DB "3- Check for a Price",0Dh,0Ah,
         DB "4- Exit",0Dh,0Ah,'$'

CrLf     db 13,10,'$'  ; print newline

applemenu:    
         DB 0Dh,0Ah,"No.  Device       Price",0Dh,0Ah
         DB "1-   Mac        2000 S.R.",0Dh,0Ah 
         DB "2-   iphone     4000 S.R.",0Dh,0Ah
         DB "3-   ipad       1700 S.R.",0Dh,0Ah
         DB "4-   Watch      1500 S.R.",0Dh,0Ah,
         DB "Enter the order number (max 10 orders), 0 to go back to the menu: ",'$'
         
bill:    DB 0Dh,0Ah,"the total bill is: ",'$'
 
price:   DB 0Dh,0Ah,"You got a price because your bill is above 1500 S.R.",0Dh,0Ah,'$'
no_price:DB 0Dh,0Ah,"You didn't win a price",0Dh,0Ah,'$'


Mac   	     DD 2000
iphone       DD 4000 
ipad	       DD 1700 
Watch	       DD 1500 

res          DB 10 DUP ('$')
order        DB 10 DUP ('$')
result       DD 0

ticket_type  DB 0
order_num    DB 0

         
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

      ; third choice
      cmp al, '4'
      je  FORTH_CHOICE
      
      ; loop back to get_choice until the user choose
      jmp get_choice
      
;===== Make an order =====
FIRST_CHOICE:
      ; Code to display the info message
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      mov dx, offset applemenu
      mov ah, 9
      int 21h
      
      LEA SI, order
      mov bl, 0      
  get_order:      
      ; read the user choice (What device?)
      mov ah, 1
      int 21h
      
      ; if enter ZERO go back to menu
      cmp al, '0'
      je finish_order
      ; store the user input in order array
      mov [SI], al
      INC SI
      INC bl
      jmp get_order

  finish_order:
      INC bl
      mov order_num, bl
      mov dx, offset CRLF
      mov ah, 9
      int 21h
      jmp start
      
SECOND_CHOICE: 
      ; Code to display the ticket message
      mov dx, offset bill
      mov ah, 9
      int 21h
      
      LEA SI, order
      mov bl, 0
      mov cx, 0
      ; read from the order
  read_order:
      mov al, [SI]
      INC SI
      INC bl
      cmp bl, order_num
      je PRINT_RESULT
      
      ; calculate Mac order and add it to result
      cmp al, '1'  ; Mac
      mov cx, mac
      je calculate

      ; calculate Iphone order and add it to result
      cmp al, '2'  ; Iphone
      mov cx, Iphone
      je calculate

      ; calculate Ipad order and add it to result
      cmp al, '3'  ; Ipad
      mov cx, Ipad
      je calculate

      ; calculate Watch order and add it to result
      cmp al, '4'  ; Watch
      mov cx, Watch
      je calculate

calculate:
      add cx, result
      mov result, cx
      jmp read_order  
      
THIRD_CHOICE:
      mov ax, result
      mov result, 0
      cmp ax, 1500
      jg win_Price
      
      mov dx, offset no_price
      MOV AH,9
      INT 21H
      jmp start
      
win_Price:
      mov dx, offset price
      MOV AH,9
      INT 21H
      jmp start

;===== Print the result =====
PRINT_RESULT:      
      mov ax, result
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