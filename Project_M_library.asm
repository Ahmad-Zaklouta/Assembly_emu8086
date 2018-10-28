org 100h

.model small 

.stack 100h

.data

header DB "- Library Application -",0Dh,0Ah
       DB "*************************",'$' 
       
NEWLINE    DB 10,13,"$"
      
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- Display Books in library.",0Dh,0Ah
           DB "2- Add book.",0Dh,0Ah 
           DB "3- Remove book.",0Dh,0Ah
           DB "4- Exit.",0Dh,0Ah,
           DB "Please enter your choice: ",'$'

book_name  DB 0Dh,0Ah,0Dh,0Ah,"Please write the book name (max 17 character) and press Enter: ",'$'

book_type  DB 0Dh,0Ah,"Please write the book type (max 10 character) and press Enter: ",'$'

book_num   DB 0Dh,0Ah,0Dh,0Ah,"Please write the book number you want to remove and press Enter: ",'$'

book_list  DB 0Dh,0Ah,0Dh,0Ah,"The Book List (Max 9 books)",0Dh,0Ah
           DB 0Dh,0Ah,"No.   Book Name           Book Type",'$'

space      DB "     ",'$'     
  
error_msg  DB 0Dh,0Ah,"The book number does not exist",0Dh,0Ah,'$'

full_msg   DB 0Dh,0Ah,"There is no place to add a new book, delete book first",0Dh,0Ah,'$'
           
book1_name DB "  The lost boy   ",'$'
book2_name DB "  Night          ",'$'
book3_name DB "  Shape of light ",'$'
book4_name DB "  Rebecca        ",'$'
book5_name DB "  The Brain      ",'$'
book6_name DB "  The lost boy   ",'$'
book7_name DB 17 dup('$')
book8_name DB 17 dup('$')
book9_name DB 17 dup('$')

book1_type DB "  Story",'$'
book2_type DB "  Story",'$'
book3_type DB "  Art",'$'
book4_type DB "  Art",'$'
book5_type DB "  Science",'$'
book6_type DB "  Science",'$'
book7_type DB 12 dup('$')
book8_type DB 12 dup('$')
book9_type DB 12 dup('$') 



available_book DB 1, 2, 3, 4, 5 ,6, 0, 0, 0
area       DD 0
operation  DB 0

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
      LEA DX, menu
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

      ; forth choice
      cmp al, '4'
      je  FORTH_CHOICE
      
      ; loop back to get_choice until the user choose
      jmp get_choice
;================================================ 

FIRST_CHOICE:
      ; print raduis msg
      MOV AH,09H
      LEA DX, book_list
      INT 21H

      lea si, available_book
      mov bl, 0
      
  print_book:
      inc bl  ; book counter
      
      mov al, [si]
      inc si
      cmp al, 0  ; go to next book
      je next_book
      cmp al, 1  ; go to book 1
      je book1
      cmp al, 2  ; go to book 2
      je book2
      cmp al, 3  ; go to book 3
      je book3
      cmp al, 4  ; go to book 4
      je book4
      cmp al, 5  ; go to book 5
      je book5
      cmp al, 6  ; go to book 6
      je book6
      cmp al, 7  ; go to book 7
      je book7
      cmp al, 8  ; go to book 8
      je book8
      cmp al, 9  ; go to book 9
      je book9
      
      
    book1:
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book1_name
      MOV AH,09H
      LEA DX, book1_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book1_type
      MOV AH,09H
      LEA DX, book1_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book   
      
    book2: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book2_name
      MOV AH,09H
      LEA DX, book2_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book2_type
      MOV AH,09H
      LEA DX, book2_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book3: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book3_name
      MOV AH,09H
      LEA DX, book3_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book3_type
      MOV AH,09H
      LEA DX, book3_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book4: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book4_name
      MOV AH,09H
      LEA DX, book4_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book4_type
      MOV AH,09H
      LEA DX, book4_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book5: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book5_name
      MOV AH,09H
      LEA DX, book5_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book5_type
      MOV AH,09H
      LEA DX, book5_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book6: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book6_name
      MOV AH,09H
      LEA DX, book6_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book6_type
      MOV AH,09H
      LEA DX, book6_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book7: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book7_name
      MOV AH,09H
      LEA DX, book7_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book7_type
      MOV AH,09H
      LEA DX, book7_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book8: 
      ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book8_name
      MOV AH,09H
      LEA DX, book8_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book8_type
      MOV AH,09H
      LEA DX, book8_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
    book9: 
       ; print new line
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H    
      ; print book number
      MOV AH,02H
      MOV Dl, bl
      add Dl, 48
      INT 21H
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book9_name
      MOV AH,09H
      LEA DX, book9_name
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H   
      ; print space
      MOV AH,09H
      LEA DX, space
      INT 21H 
      ; print book9_type
      MOV AH,09H
      LEA DX, book9_type
      add dx,02h          ; to get rid of the space on the beginning or the buffer size
      INT 21H     
      
      jmp next_book  
      
  next_book:
    cmp bl, 9
    jg start
    jmp print_book

;================================================ 
      
SECOND_CHOICE:
  
      lea si, available_book
      mov bl, 0
       
  add_book:
      ; check for empty place
      mov al, [si]
      inc si
      inc bl  ; book counter
      cmp bl, 9
      jg full_place  ; there is no place to add a new book
      cmp al, 0  ; there is empty place
      je found_place
      jmp add_book
      
  found_place:
      dec si
      mov [si], bl  ; save the book num in the list
      mov al, bl  ; al now have the number of the empty place to add the book
      cmp al, 1  ; add book at place 1
      je add_book1
      cmp al, 2  ; add book at place 2
      je add_book2
      cmp al, 3  ; add book at place 3
      je add_book3
      cmp al, 4  ; add book at place 4
      je add_book4
      cmp al, 5  ; add book at place 5
      je add_book5
      cmp al, 6  ; add book at place 6
      je add_book6
      cmp al, 7  ; add book at place 7
      je add_book7
      cmp al, 8  ; add book at place 8
      je add_book8
      cmp al, 9  ; add book at place 9
      je add_book9 

    ; add book in place 1
    add_book1:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book1_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book1_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
    
    ; add book in place 2    
    add_book2:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book2_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book2_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad

    ; add book in place 3 
    add_book3:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book3_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book3_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
      
    ; add book in place 4 
    add_book4:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book4_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book4_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
      
    ; add book in place 5 
    add_book5:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book5_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book5_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
      
    ; add book in place 6 
    add_book6:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book6_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book6_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
      
    ; add book in place 7 
    add_book7:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book7_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book7_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
      
    ; add book in place 8 
    add_book8:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book8_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book8_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad

    ; add book in place 9 
    add_book9:
      ; print book_name msg
      MOV AH,09H
      LEA DX, book_name
      INT 21H
      ; Get the book name
      mov ah,0ah
      lea dx, book9_name
      int 21h 
      mov si, dx   ; save the address for space padding
      
      ; print NEWLINE
      MOV AH,09H
      LEA DX, NEWLINE
      INT 21H
      
      ; print book_type msg
      MOV AH,09H
      LEA DX, book_type
      INT 21H       
      ; Get the book type
      mov ah,0ah
      lea dx, book9_type
      int 21h 
      mov di, dx   ; save the address for end string
      jmp space_pad
  
  ; when there is no space for new book  
  full_place:
      ; print full_msg
      mov ah,0ah
      lea dx, full_msg
      int 21h
      jmp start
      
  ; fill the rest of the name with space for printing
  space_pad:
    mov ax, 0
    mov cx, 0
    mov al, [si+1]  ; get the length of the string
    add al, 2       ; for the buffer size  
    mov cl, 17
    sub cl, al      ; initilaize the counter
    add ax, si      
    mov si, ax      ; go to character after the last character
    space_loop:
      mov [si], 32  ; add space to the name
      inc si
    loop space_loop
    
    ; add $ to the end of the book type string
    mov ax, 0
    mov cx, 0
    mov al, [di+1]  ; get the length of the string
    add al, 2       ; for the buffer size  
    add ax, di      
    mov di, ax      ; go to character after the last character
    mov [di], '$'   ; add $ to the end        
    
    jmp start 
;================================================ 
      
THIRD_CHOICE:
      ; print book_num msg
      mov ah,09h
      lea dx, book_num
      int 21h
      ; read the user choice
      mov ah, 1
      int 21h
      sub al, 48
       
      lea si, available_book
      mov bl, 0
      
      ; check for book
    check_book:
      cmp al, [si]
      je found_book
      inc si
      inc bl  ; book counter
      cmp bl, 9
      jg wrong  ; there is no place to add a new book
      jmp check_book      
    
  found_book:
      mov [si], 0
      
      jmp start
  
  wrong:
      ; print error_msg
      mov ah,0ah
      lea dx, error_msg
      int 21h    
      
      jmp start
;================================================     
 
FORTH_CHOICE:

      mov ah,4Ch
      int 21h 