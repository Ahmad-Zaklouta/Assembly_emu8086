org 100h

.model small 

.stack 100h

.data

header DB "- Grades Application -",0Dh,0Ah
       DB "*************************",0Dh,0Ah,0Dh,0Ah,'$'
 

COURSE1msg DB "ENTER FIRST COURSE HERE: ",'$'
COURSE2msg DB "ENTER SECOND COURSE HERE: ",'$'
COURSESmsg DB 0Dh,0Ah,"PLEASE CHOOSE FROM THE COURSES AVAILABLE:",'$'
num1       DB "1- ",'$'
num2       DB "2- ",'$'
COURSE_SEL DB "ENTER COURSE NUMBER TO DISPLAY THE MENU:",'$'
COURSE1    DB 20 DUP('$')
COURSE2    DB 20 DUP('$')
NEWLINE    DB 10,13,"$"

ENTER_GRADE DB 0Dh,0Ah,"PLEASE ENTER A GRADE (0..100) OR f FOR FINISH AND PRESS ENTER: ",'$'
      
menu       DB 0Dh,0Ah,0Dh,0Ah,"1- Enter student grades.",0Dh,0Ah
           DB "2- Display the number of grades entered.",0Dh,0Ah 
           DB "3- Display the average of grades.",0Dh,0Ah
           DB "4- Display the number of Excellent grades students.",0Dh,0Ah,
           DB "5- Display the number of very good grades students.",0Dh,0Ah,
           DB "6- Display the number of good grades students.",0Dh,0Ah,
           DB "7- Display the number of adequate grades students.",0Dh,0Ah,
           DB "8- Display the number of failed students.",0Dh,0Ah,
           DB "9- Summarize",0Dh,0Ah,
           DB "Please enter your choice: ",'$'

space      DB "   ",'$'
tab        DB "            ",'$'

Entered_Grade DB 0Dh,0Ah,0Dh,0Ah,"The grades you entered are: ",'$'

average_Grade DB 0Dh,0Ah,0Dh,0Ah,"The average grades is: ",'$'

Excellent_Grade DB 0Dh,0Ah,0Dh,0Ah,"The number of students with Excellent garde is: ",'$'
verygood_Grade  DB 0Dh,0Ah,0Dh,0Ah,"The number of students with very good garde is: ",'$'
good_Grade      DB 0Dh,0Ah,0Dh,0Ah,"The number of students with good garde is: ",'$'
adequate_Grade  DB 0Dh,0Ah,0Dh,0Ah,"The number of students with adequate garde is: ",'$'
failed_Grade    DB 0Dh,0Ah,0Dh,0Ah,"The number of students with failed garde is: ",'$'

Summarize1    DB 0Dh,0Ah,"Summary of Course 1:",0Dh,0Ah,'$'

Summarize2    DB 0Dh,0Ah,"Summary of Course 2:",0Dh,0Ah,'$'

summary       DB 0Dh,0Ah,"grade number     average     passed     failed",0Dh,0Ah,'$'

coursename    DB 0Dh,0Ah,"Course name is: ",'$'

course      DB ? 
counter     DB 0        
grades1     DB 20 DUP ('$')
grades2     DB 20 DUP ('$')
grade_num   DB 0
grade1_num  DB 0
grade2_num  DB 0
pass1       DB 0
fail1       DB 0
pass2       DB 0
fail2       DB 0
result      DB 10 DUP ('$') 
summery1    DB 4  DUP ('$')
summery2    DB 4  DUP ('$')
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
      
      ; Get Courses name  
      LEA SI,COURSE1
      LEA DI,COURSE2
      ; print message for the first course
      MOV AH,09H
      LEA DX,COURSE1msg
      INT 21H
      ; get the name of the first course
      MOV AH,0AH
      MOV DX,SI
      INT 21H
      ; print a new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      ; print message for the second course
      MOV AH,09H
      LEA DX,COURSE2msg
      INT 21H
      ; get the name of the second course
      MOV AH,0AH
      MOV DX,DI
      INT 21H
      ; print a new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
;================================================ 

  start:
      ; print courses name message
      MOV AH,09H
      LEA DX,COURSESmsg
      INT 21H
      ; print a new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      ; print the name of the first course
      MOV AH,09H
      LEA DX,num1
      INT 21H
      MOV AH,09H
      LEA DX,COURSE1+2
      INT 21H
      ; print a new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      ; print the name of the second course 
      MOV AH,09H
      LEA DX,num2                    
      INT 21H
      MOV AH,09H
      LEA DX,COURSE2+2
      INT 21H
      ; print a new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      ; print COURSE_SEL message
      MOV AH,09H
      LEA DX,COURSE_SEL
      INT 21H
      ; read the user choice
      mov ah, 7
      int 21h
      mov course, al
      
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
      LEA DX,NEWLINE
      INT 21H 
      
      cmp course, '1'  ; first course selected
      jne secondcourse
      LEA SI, grades1
      mov grade1_num, 0
      mov pass1, 0
      mov fail1, 0
      jmp firstcourse
    secondcourse:     ; second course selected
      LEA SI, grades2
      mov grade2_num, 0
      mov pass2, 0
      mov fail2, 0
    firstcourse:
    
  get_grade:
      LEA DX,ENTER_GRADE
      MOV AH,9
      INT 21H
      ; get the student grade
      mov bx, 0
      mov di,10
  inputloop:
      mov ah,1
      int 21h
      cmp al, 'f'  ; is it f?
      je continue
      cmp al, 13  ; is it Enter?
      jne convertion
      jmp another_grade

    convertion:
      sub al, 48
      mov ah, 0
      mov cl, al 
      mov al, bl       
      mul di          
      add al, cl       
      mov bl, al
      jmp inputloop
  another_grade:
      MOV [SI],bl
      INC SI
            
      cmp course, '1'  ; first course selected
      jne grade_num2   
      INC grade1_num
      jmp grade_num1
    grade_num2:        ; second course selected
      INC grade2_num
    grade_num1:

      jmp get_grade
  continue:
      ;printing new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      
      jmp start
;================================================ 
      
SECOND_CHOICE:
      ; print entered grade message
      MOV AH,09H
      LEA DX, entered_grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne SECOND_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp SECOND_CHOICE1
    SECOND_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    SECOND_CHOICE1:

     mov counter, 0
print_next: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
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
      
      ; Print grade
      LEA DX,result
      MOV AH,9
      INT 21H
      
      ;printing space
      MOV AH,09H
      LEA DX,space
      INT 21H
      
      mov al,grade_num  
      cmp counter, al
      jne print_next
      
      ;printing new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      
      jmp start
;================================================ 
      
THIRD_CHOICE:
      ; print average grade message
      MOV AH,09H
      LEA DX, average_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne THIRD_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp THIRD_CHOICE1
    THIRD_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    THIRD_CHOICE1:
    
     mov counter, 0
     mov bx, 0
calculate_average: 
      ; add all the grades
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      add bx, ax
      mov al,grade_num  
      cmp counter, al
      jne calculate_average
      ; divide the sum over the number of grade
      mov ax, bx
      mov bl, grade_num
      div bl
      mov ah, 0
    
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
      
      ; Print average
      LEA DX,result
      MOV AH,9
      INT 21H
      
      ;printing new line
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H
      
      jmp start        
;================================================     
 
FORTH_CHOICE:
      ; print Excellent grade message
      MOV AH,09H
      LEA DX, Excellent_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne FORTH_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp FORTH_CHOICE1
    FORTH_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    FORTH_CHOICE1:
    
     mov counter, 0
     mov bx, 0
  check_grade_Excellent: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; grade Excellent (90 - 100)
      cmp al, 90
      jl grade_Excellent_next
      cmp al, 100
      ja grade_Excellent_next
      inc bx
    grade_Excellent_next:
      mov al,grade_num  
      cmp counter, al
      jne check_grade_Excellent

    
      mov ax, bx
      jmp PRINT_RESULT
;================================================ 

FIFTH_CHOICE:
      ; print very good grade message
      MOV AH,09H
      LEA DX, Verygood_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne FIFTH_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp FIFTH_CHOICE1
    FIFTH_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    FIFTH_CHOICE1:
    
     mov counter, 0
     mov bx, 0
  check_grade_verygood: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; grade very good (80 - 89)
      cmp al, 80
      jl grade_verygood_next
      cmp al, 89
      ja grade_verygood_next
      inc bx
    grade_verygood_next:
      mov al,grade_num  
      cmp counter, al
      jne check_grade_verygood
      
      mov ax, bx
      jmp PRINT_RESULT
;================================================
 
SIXTH_CHOICE:
      ; print good grade message
      MOV AH,09H
      LEA DX, good_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne SIXTH_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp SIXTH_CHOICE1
    SIXTH_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    SIXTH_CHOICE1:
    
     mov counter, 0
     mov bx, 0
  check_grade_good: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; grade  good (70 - 79)
      cmp al, 70
      jl grade_good_next
      cmp al, 79
      ja grade_good_next
      inc bx
    grade_good_next:
      mov al,grade_num  
      cmp counter, al
      jne check_grade_good

      mov ax, bx
      jmp PRINT_RESULT
;================================================ 

SEVENTH_CHOICE:
      ; print adequate grade message
      MOV AH,09H
      LEA DX, adequate_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne SEVENTH_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp SEVENTH_CHOICE1
    SEVENTH_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    SEVENTH_CHOICE1:
    
     mov counter, 0
     mov bx, 0
  check_grade_adequate: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; grade  good (60 - 69)
      cmp al, 60
      jl grade_adequate_next
      cmp al, 69
      ja grade_adequate_next
      inc bx
    grade_adequate_next:
      mov al,grade_num  
      cmp counter, al
      jne check_grade_adequate
      
      mov ax, bx
      jmp PRINT_RESULT
;================================================ 

EIGHTH_CHOICE:
      ; print failed grade message
      MOV AH,09H
      LEA DX, failed_Grade
      INT 21H
      
      cmp course, '1'  ; first course selected
      jne EIGHTH_CHOICE2   
      LEA DI, grades1
      mov al,grade1_num 
      mov grade_num,al 
      jmp EIGHTH_CHOICE1
    EIGHTH_CHOICE2:        ; second course selected
      LEA DI, grades2
      mov al,grade2_num 
      mov grade_num,al 
    EIGHTH_CHOICE1:
    
     mov counter, 0
     mov bx, 0
  check_grade_failed: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; grade  failed (<60)
      cmp al, 60
      jae grade_failed_next
      inc bx  
      
    grade_failed_next:
      mov al,grade_num  
      cmp counter, al
      jne check_grade_failed
      
      mov ax, bx
      jmp PRINT_RESULT
;================================================ 

NINTH_CHOICE:
      ;printing summary for course 1
      MOV AH,09H
      LEA DX, Summarize1 
      INT 21H
      ; print the name of the first course
      MOV AH,09H
      LEA DX,coursename
      INT 21H 
      MOV AH,09H
      LEA DX,COURSE1+2
      INT 21H    
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H       
      MOV AH,09H
      LEA DX,summary
      INT 21H     
      ;printing space
      MOV AH,09H
      LEA DX,space
      INT 21H

     LEA DI, grades1
      mov counter, 0
      mov bx, 0

calculate_average1: 
      ; add all the grades
      mov al, [DI]
      mov ah, 0
      
      ; count failed grade
      cmp al, 60
      jae check_failed
      inc fail1
      check_failed:
      
      inc DI
      inc counter
      add bx, ax
      mov al,grade1_num  
      cmp counter, al
      jne calculate_average1
      ; divide the sum over the number of grade
      mov ax, bx
      mov bl, grade1_num
      div bl
      mov ah, 0
      
      LEA DI, summery1
      mov [DI+1], al        ; save the average
      mov al, grade1_num
      mov [DI], al          ; save number of grade
      
      sub al, fail1
      mov [DI+2], al        ; save number of passed student
      mov al, fail1
      mov [DI+3], al     ; save number of failed student

      mov counter, 0
print_next1: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; convert decimal to hex to print result
      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP19: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP19
      ADD AL,30H
      MOV [SI],AL
    LOOP29: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP29
      
      ; Print grade
      LEA DX,result
      MOV AH,9
      INT 21H
      
      ;printing tab
      MOV AH,09H
      LEA DX,tab
      INT 21H
      
      cmp counter, 4
      jne print_next1

;==================================
      ;printing summary for course 2
      MOV AH,09H
      LEA DX, Summarize2 
      INT 21H
      ; print the name of the first course
      MOV AH,09H
      LEA DX,coursename
      INT 21H 
      MOV AH,09H
      LEA DX,COURSE2+2
      INT 21H    
      MOV AH,09H
      LEA DX,NEWLINE
      INT 21H       
      MOV AH,09H
      LEA DX,summary
      INT 21H     
      ;printing space
      MOV AH,09H
      LEA DX,space
      INT 21H

     LEA DI, grades2
      mov counter, 0
      mov bx, 0

calculate_average2: 
      ; add all the grades
      mov al, [DI]
      mov ah, 0
      
      ; count failed grade
      cmp al, 60
      jae check_failed2
      inc fail2
      check_failed2:
      
      inc DI
      inc counter
      add bx, ax
      mov al,grade2_num  
      cmp counter, al
      jne calculate_average2
      ; divide the sum over the number of grade
      mov ax, bx
      mov bl, grade2_num
      div bl
      mov ah, 0
      
      LEA DI, summery2
      mov [DI+1], al        ; save the average
      mov al, grade2_num
      mov [DI], al          ; save number of grade
      
      sub al, fail2
      mov [DI+2], al        ; save number of passed student
      mov al, fail2
      mov [DI+3], al     ; save number of failed student

      mov counter, 0
print_next2: 
      mov al, [DI]
      mov ah, 0
      inc DI
      inc counter
      ; convert decimal to hex to print result
      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP119: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP119
      ADD AL,30H
      MOV [SI],AL
    LOOP229: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP229
      
      ; Print grade
      LEA DX,result
      MOV AH,9
      INT 21H
      
      ;printing tab
      MOV AH,09H
      LEA DX,tab
      INT 21H
      
      cmp counter, 4
      jne print_next2
      
      jmp finish
;================================================  

PRINT_RESULT:
      ; convert decimal to hex to print result
      LEA SI, result
      MOV CX,0
      MOV BX,10
  LOOP111: 
      MOV DX,0
      DIV BX
      ADD DL,30H
      PUSH DX
      INC CX
      CMP AX,9
      JG LOOP111
      ADD AL,30H
      MOV [SI],AL
    LOOP222: 
      POP AX
      INC SI
      MOV [SI],AL
      LOOP LOOP222
    
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
