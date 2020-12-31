;Write an assembly language instruction to store three numbers in the stack 
;memory after storing do the following:
;- If the number is even number change to odd number
;- If the number is odd number change to even number
;Finally store the result in any general purpose register


stack    segment para    stack   'stack'
    db 64 dup(0)
stack    ends
data   segment para    'data'    
    ; ..:: MESSAGES ::..
    msjNum db 10,13, 'Type the number: $'
data   ends
code  segment para 'code'
    assume cs:codigo,ds:datos,ss:pila
    start proc far                  
        mov ax,data            ;Asignacion del segmento de datos 
        mov ds,ax
        
        mov cx, 03H              ;CX = 03H
        
        ReadNumber:
        mov dx, offset msjNum    ;Asigna a DX la posicion inicial de cadena
        mov ah, 09               ;Usa la funcion 09H
        int 21H                  ;De la interrupcion de 21H
        
        mov ah,01H
        int 21H                  ;Read the number
        mov dl, al               ;Mov the number to dl
        push dx                  ;Store the number in the stack
        dec cx
        
        jnz ReadNumber            ;Jump to 'ReadNumber' if CX is not 0
        ;The Three numbers are in the Stack                           
        ;Check if it is even
        pop ax                  ;MOV the last number to AX
        sub ax, 30H             ;AX = AX - 30H
        mov bl, 02H             ;bx = 02H
        div bl                  ;Div al/bl | ah = residue ,  al = quotient
        cmp ah, 00H             ;Compare al = 00H ?
        je even1                ;AL == 00H? Then JumpTo even1
        odd1:
        mov dh, 02H             ;DH = EvenNumber (02H)
        jmp number2
        
        even1:
        mov dh, 01H             ;DH = OddNumber (05H)
        
        ;Number 2
        number2:
        pop ax                  ;Mov the second number to AX
        sub ax, 30H             ;AX = AX - 30H
        div bl                  ;Div al/bl | ah = residue ,  al = quotient
        cmp ah, 00H             ;Compare al = 00H?
        je even2                                     
        odd2:
        mov dl, 04H             ;DL = EvenNumber (04H)
        jmp number3
        
        even2:
        mov dl, 03H             ;DL = OddNumber (03H)
        
        
        ;Number 3
        Number3:
        pop ax                  ;Mov the second number to AX
        sub ax, 30H             ;AX = AX - 30H              
        div bl                  ;Div al/bl | ah = residue ,  al = quotient
        cmp ah, 00H             ;Compare al = 00H?
        je even3
        odd3:
        mov ch, 08H             ;CH = EvenNumber (08H)
        jmp end_compare         ;JumpTo 'end_compare'
        
        even3:
        mov ch, 07H             ;CH = OddNumber (05H)
        
        
        end_compare:
        mov bl, ch              ;Set the 1st number in BL
        mov cl, dl              ;Set the 2nd number in CL
        mov dl, dh              ;Set de 3nd number int DL
        
        mov ch, 00H             ;Clear DH
        mov dh, 00H             ;Clear DH
        

        end_program:                        
        mov ah,4CH
        int 21H                 ;End Program
    start endp
code  ends
end start