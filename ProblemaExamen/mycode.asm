; ..:: MACROS ::..        
;Imprime el numero hexadecimal en pantalla en ASCII o decimal
ImprimeHEX MACRO num_hex   
    mov ax, num_hex     ;Pone el numero recibido en AX
    mov ah, 00H         ;Limpia AH                    
    
    cmp ax, 09H             ;Compara el numero con 09H
    ja mayor_a_nueve        ;Salta a Mayor_a_nueve
    ;NO es mayor a 9
    mov dl, al              ;Pasa el numero a DL
    add dl, 30h             ;Le suma 30H para hacer el ajuste
    
    mov ah, 02
    int 21H                 ;Usa la funcion 02 de INT21 para imprimir el caracter
    jmp fin_macro           ;Salta al fin de la MACRO
    
    mayor_a_nueve:
    cmp ax, 63H             ;Compara si el numero es > 100
    ja mayor_a_cien         ;Salta a mayor_a_cien
    ;Si  no es mayor a cien, CONTINUA
    mov bx, 0AH             ;Asigna a BX = 0AH
    div bl                  ;Divide AL / BL | Resultado: AL | Residuo: AH
    mov dx, ax              ;Mueve el numero a DX
    add dx, 3030H           ;Ajuste ASCCII
    mov ah, 02H             ;Imprimir digito en pantalla
    int 21H                 ;Imprime
    mov dl, dh              ;Asigna a DL = DH
    int 21H                 ;Imprime
    jmp fin_macro        ;Salta a fin_programa    
    
    
    mayor_a_cien:
    mov bx, 64H             ;Asigna a BX = 64H
    div bl                  ;Divide AL entre BL
    
    mov dx, ax              ;Pone el numero en DX
    add dl, 30H             ;Ajuste ASCII
    mov ah, 02H             ;Imprimir digito en pantalla
    int 21H                 ;Imprime digito             
    mov ah, 00H             ;Limpia AH
    mov al, dh              ;Pone en AL el residuo que habia quedado
    mov bl, 0AH             ;Pone en BL = 0AH
    div bl                  ;Divide AL / BL
    add AX, 3030H           ;Ajuste ASCII
    mov DX, AX              ;DX = AX
    mov ah, 02H             ;Imprimir digito
    int 21H                 ;Imprime
    mov dl, dh              ;Pasa el otro digito a DL
    int 21H                 ;Imprime
    
    
    
    fin_macro:
        
ENDM  

ImprimeComa MACRO
    mov dl, 2CH         ;Pone el valor Hexadecimal de la coma en DL
    mov ah, 02H
    int 21H             ;Usa la funcion 02 de INT21H para imprimir el caracter
ENDM


pila    segment para    stack   'stack'
    db 64 dup(0)
pila    ends
datos   segment para    'data'    
    ; ..:: MESSAGES ::..
    msg DB 10,13, 'Lenguajes de Bajo Nivel', 10,13,'    ',0ADh,'Bienvenidos', 21H,10,13,'$'
    array_datos DW 21 DUP(0)    ;Array donde se guardan losd datos de f(x) = x*x + x
datos   ends
codigo  segment para 'code'
    assume cs:codigo,ds:datos,ss:pila
    inicio proc far                  
        mov ax, datos           ;Asignacion del segmento de datos 
        mov ds,ax
        ; ...:: PARTE A :::...
        mov dx,offset msg       ;Asigna a DX la posicion inicial de msg
        mov ah,09               ;Usa la funcion 09H
        int 21H                 ;De la interrupcion de 21H
        
        ; ..:: PARTE B :::..
        lee_tecla:
        mov ah, 01h             ;Leemos una tecla del teclado
        int 21H                 ;Con la funcion 1 de Int21H
        
        cmp al, 0DH             ;Compara si se inserto la tecla 'Enter'
        jne lee_tecla           ;Si NO se inserto 'Enter' vuelve a leer desde el teclado

        mov si, 0               ;iniciamos en la posicion 0 del arreglo
        mov cx, 15h             ;el ciclo se ha de repetir 21 veces
        ciclo:                              
        ;Calculando la funcion f(x) = x*x +x
        mov bx, si              ;SI es el el valor de X y tambien lo usamos como indice para el array
        mov ax, bx              ;AX = Indice o valor de X
        mul bx                  ;Multiplica AX * BX (x * x)
        add ax, bx              ;Suma AX + BX (x * x + x)
        mov array_datos[si], ax ;Guarda el resultado en el arreglo
        mov ax, array_datos[si]
        inc si                  ;se incrementa SI en 1 para calcular el siguiente valor de x
        loop ciclo
        
        ;..::: PARTE C :::..
        mov si, 00H                 ;Pone el indice en 0
        mov cx, 15H                 ;El ciclo se va a repetir 21 veces                               
        ciclo_imprimir:      
        ImprimeHEX array_datos[si]  ;Llama al MACRO que imprime en pantalla un numero hexadecimal
        ImprimeComa                 ;Llama al MACRO que imprime la coma
        inc si
        loop ciclo_imprimir
        
        
        
        

        fin_programa:                        
        mov ah,4CH
        int 21H                 ;End Program
    inicio endp
codigo  ends
end inicio