;Write an assembly language program in "Emulator" to 
;store/read an option in AX register. 
;If the option is "1" then store the numbers 5, 2, 9 in the stack. 
;If the option is "2" the store/read two different numbers in general purpose registers 
;and find smallest of the numbers and store the result in DX register. 
;Write the explanation for each line in the program.

		.model small		                ;This model uses by default
		.stack 64                           ;Stack Segment 64K
		.data                               ;Data segment
	msgOption db 'Option: $'                ;Message 'Option: '
	msgNumber1 db 10, 13, 'Type the number 1: $'               ;Message 'Type the number : '
	msgNumber2 db 10, 13, 'Type the number 2: $'               ;Message 'Type the number 2: '
		.code                               ;Start Code Segment
    start:                                  ;Start the program
		mov ax,@data                        ;Move the data address to AX
		mov ds,ax                           ;Move the data address to DataSegment 
		
		mov dx, offset msgOption            ;Assign the initial position of the variable 'msgNum' to DX
		mov ah, 09H                         ;Assign to AH the instruction 09H
		int 21H                             ;Executes function 09H of int21H
		
		mov ah, 01H                         ;Assign to AH the instruction 01H  (Read The Option)
		int 21H                             ;Executes function 01H of Int21H     
		mov ah, 00H                         ;Clear AH
		
		;Compare Option
		cmp ax, 0031H                       ;Compare the option
		je option1                          ;If AX = 0031H Jump to 'option1'                                            
	option2:
	    ;Read Number1
	    mov dx, offset msgNumber1           ;Assing the initial position of the variable 'msgNumber1' to DX
	    mov ah, 09H                         ;Assing to AH the instruction 09H
	    int 21H                             ;Executes function 09H of int 21H
	    mov ah, 01H                         ;Assign to AH the instruction 01H (Read)
	    int 21H                             ;Executes function 01H of Int 21H
	    mov bl, al                          ;Move the number to BX
	    sub bl, 30H                         ;Convert to Decimal
	    ;Read Number2
        mov dx, offset msgNumber2           ;Assing the initial position of the variable 'msgNumber2' to DX
	    mov ah, 09H                         ;Assing to AH the instruction 09H
	    int 21H                             ;Executes function 09H of in 21H 
	    mov ah, 01H                         ;Assign to AH the instruction 01H (Read)
	    int 21H                             ;Executes function 01H of Int 21H
	    mov cl, al                          ;Move the number to CX
	    sub cl, 30H                         ;Convert to Decimal
	    ;Compare
	    cmp bx, cx                          ;Compare BX with CX
	    ja cx_small                         ;If bx > cx Jump to 'cx_small'
	    mov dx, bx                          ;Move to DX the value in BX (The number smallest)
	    jmp end_program                     ;Jump to end_program                             
	    
	    cx_small:
	    mov dx, cx                          ;Move to DX the value in CX (The number smallest)
	    jmp end_program                     ;Jump to end_program
	    
	option1:
		push 0005H                          ;Store the number 5
		push 0002H                          ;Store the number 2
		push 0009H                          ;Store the number 9
		
	end_program:
		mov ah,4Ch                          ;Asign to ah the instruction 4CH
		int 21h                             ;Return the control to MS-DOS  
		end start                           ;End program