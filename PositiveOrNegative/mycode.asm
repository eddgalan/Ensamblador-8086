;Write an assembly program in "Emulator" to store/read a number 
;in BX register and find the number in BX register is +ve number or -ve number. 
;If it is +ve number store in CX register 
;else store in DX register
;Write explanation for each line in the program

		.model small		                ;This model uses by default
		.stack 64                           ;Stack Segment 64K
		.data                               ;Data segment
	msjNum db 'Type the number: $'          ;Message 'Type the number: '
		.code                               ;Start Code Segment
    start:                                  ;Start the program
		mov ax,@data                        ;Move the data address to AX
		mov ds,ax                           ;Move the data address to DataSegment 
		
		mov dx, offset msjNum               ;Assign the initial position of the variable 'msgNum' to DX
		mov ah, 09H                         ;Assign to AH the instruction 09H
		int 21H                             ;Executes function 09H of int21H
		
		mov ah, 01H                         ;Assign to AH the instruction 01H  (Read The Number)
		int 21H                             ;Executes function 01H of Int21H
		
		cmp al, 2DH                         ;Compare the data read with '2D'
		je number_neg                       ;If is equal to 2D Jump to 'number_neg'
		sub al, 30H                         ;Convert to decimal the number
		mov cl, al                          ;Move the number to CX        
		jmp end_program                     ;Jump to end_program
	number_neg:
	    int 21H                             ;Executes function 01H  (Read The Number)
	    sub al, 30H                         ;Convert to decimal
	    mov dx, 00H                         ;Clear DX
	    mov dl, al                          ;Move the number to DX
		
	end_program:
		mov ah,4Ch                          ;Asign to ah the instruction 4CH
		int 21h                             ;Return the control to MS-DOS  
		end start                           ;End program