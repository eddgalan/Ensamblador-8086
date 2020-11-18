ImprimeCadena MACRO cadena
    mov dx,offset cadena    ;Asigna a DX la posicion inicial de cadena
    mov ah,09               ;Usa la funcion 09H
    int 21H                 ;De la interrupcion de 21H
ENDM           
LimpiaPantalla MACRO
    mov ah,0FH              ;Usa la funcion 0FH
    int 10H                 ;De la interrupcion 21H
    mov AH,0                ;Usa la funcion 0H
    int 10H                 ;De la interrupcion 21H
ENDM 

pila    segment para    stack   'stack'
    db 64 dup(0)
pila    ends
datos   segment para    'data'    
    ; ..:: MENSAJES ::..
    msjNum1 db 'Inserte el numero 1: $'
    msjNum2 db 10,13,'Inserte el numero 2: $'
    msjResultado db 10,13,'El MCD es: $'
    
    ; ..:: VARIABLES ::..
    contador db  ?               ;Se usa para contar cuantos numeros han entrado. Puede ser numero
    num1 dw ?                    ;Guarda el Numero1 que se va a operar.
    num2 dw ?                    ;Guarda el Numero2 que se va a operar.
    
    
datos   ends
codigo  segment para 'code'
    assume cs:codigo,ds:datos,ss:pila
    inicio proc far
        mov ax,datos            ;Asignacion del segmento de datos 
        mov ds,ax            
        ;Pide el numero 1   
        ImprimeCadena msjNum1    
        call EntradaNum         ;Llama al proceso de entrada. Al final del procedimiento de entrada el valor insertado se queda en AX
        mov num1, ax            ;Asigna a num1 el primer numero insertado
        
        ;Pide el numero 2
        ImprimeCadena msjNum2
        call EntradaNum         ;Llama al proceso de entrada. Al final del procedimiento de entrada el valor insertado se queda en AX
        mov num2, ax            ;Asigna a num1 el primer numero insertado
    
        ; Ya tenemos los numeros
        mov ax, num1            ; AX = num1
        mov bx, num2            ; BX = num2
        
        cmp ax, bx              ; Compara AX con BX
        jb bxMayor
        
        ;Si AX es mayor asigna a cx bx
        mov cx, bx              ;Asigna a CX el valor de BX (Num2)
        mov dx, 00H             ;Limpia DX
        jmp comienza_ciclo
        
        bxMayor:
        mov cx, ax              ;Asigna a CX el valor de AX (Num1)
        mov dx, 00H             ;Limpia DX
        
        comienza_ciclo:         ;Inicia un ciclo para obtener los divisores de los numeros
        mov ax, num1            ;Asigna a AX = Num1
        div cl                  ;Divide AL entre CL | Resultado: AL | Residuo: AH
        
        cmp ah, 00H             ;Compara si hay un residuo
        jz sin_residuo          ;Si no hay residuo salta a sin_residuo
        jmp decremento          ;Salta a decremento
        
        
        sin_residuo:
        ; Si no hay residuo quiere decir que el numero es divisor
        mov ax, num2            ;Asignamos a AX = num2 para ver si es divisor
        div cl                  ;Divide AL / CL
        cmp ah, 00H             ;Compara si hay un residuo
        jz sin_residuo_n2       ;Salta a sin_residuo_n2
        jmp decremento
        
        
        sin_residuo_n2:
        push cx                 ;Guarda el numero en la pila
        inc dx                  ;Incrementa DX (Contador de divisores)
        
        
        decremento:
        dec cx
	    jnz comienza_ciclo
        
        mov cx, dx              ;Asigna a DX el numero de Divisores
        
        ;Saca el MCD de la Pila y lo pone en DX
        repite:
        pop dx                  ;Saca el Divisor
        dec cx                  ;Decrementa CX
        jnz repite              ;Salta a repite si no es cero
        
        cmp dx, 09H             ;Compara el MCD con 09H
        ja mayor_a_nueve        ;Salta a Mayor_a_nueve
        ;No es mayor a 9
        mov bl, dl              ;Pasa el el MCD a BL
        ImprimeCadena msjResultado
        mov dl, bl              ;Regresa el MCD a DL
        add dl, 30H             ;Incrementa 30H a DL
        mov ah, 02H             ;
        int 21H                 ;Imprime el MCD
        jmp fin_programa
        
        
        mayor_a_nueve:          ;
        cmp dx, 63H             ;Compara si el MCD es > 100
        ja mayor_a_cien         ;Salta a mayor_a_cien
        
        ;Si  no es mayor a cien, CONTINUA
        
        mov ax, dx              ;Pasa el MCD a AX
        mov bx, 0AH             ;Asigna a AX = 0AH
        div bl                  ;Divide AL / BL | Resultado: AL | Residuo: AH
        push ax                 ;Guarda el resultado en la PILA
        
        ImprimeCadena msjResultado
        pop dx                  ;Saca el resultado de la pila
        add dx, 3030H           ;Ajuste ASCCII
        mov ah, 02H             ;Imprimir digito en pantalla
        int 21H                 ;Imprime
        mov dl, dh              ;Asigna a DL = DH
        int 21H                 ;Imprime
        jmp fin_programa        ;Salta a fin_programa
        
        mayor_a_cien:
        mov ax, dx              ;Pasa el MCD a AX
        mov bx, 64H             ;Asigna a BX = 64H
        div bl                  ;Divide AL entre BL
        push ax                 ;Guarda el cociente y residuo en la Pila
        ImprimeCadena msjResultado
        pop dx                  ;Pone el cociente y residuo en DX
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
        
                        
                        
        fin_programa:                        
        mov ah,4CH
        int 21H                 ;Devuelve el control al DOS (FIN DEL PROGRAMA)
    inicio endp
    
    
    ; ..:: PROCEDIMIENTO EntradaNum ::..
    EntradaNum proc near ;Inicia proceso de entrada de numeros    
        cmp contador,0   ;Compara el contador con 0 
        je PideNumero1   ;Si es 0 salta a PideNumero1
        
        PideNumero1:
        
        ContinuaConLaEntrada:
        mov dx,0000                 ;Asigna a DX 0
        
        Entrada:
        mov ah,1
        int 21h                     ;Entra un digito
        cmp al,0DH                  ;Compara que no se precione la tecla [ENTER]
        jz FinEntrada               ;Si se preciona [ENTER] Va al fin de la entrada
        
        ;Si no inserto [ENTER]
        add dl,1                    ;Le suma 1 a DL indicando que entro un digito
        mov ah,0                    ;Limpia la parte alta de AX para agregar el dato a la pila
        PUSH ax                     ;Mueve el dato insertado a la pila
        jmp Entrada                 ;Regresa a la entrada para insertar mas digitos
        
        FinEntrada:
        cmp dl,1                ;Si entro un numero de un solo digito
        jz EntroUnSoloDigito    ;Salta a EntroUnSoloDigito
        cmp dl,2   
        jz EntraronDosDigitos   ;Salta a EntraronDosDigitos
        cmp dl,3
        jz EntraronTresDigitos  ;Salta a EntraronTresDigitos
        
        ; ..:: EntroUnSoloDigito :..
        EntroUnSoloDigito:
        pop cx                  ;Saca el unico numero insertado a CX
        sub cx,30H              ;and cx,0f0fh ;Hace el ajuste y ya tenemos un numero de un digito. Se puede hacer el ajuste restando 3030H
        mov al,cl
        mov ah,00               ;El numero ya esta en AH
        jmp FinEntradaNumeros  
        
        ; ..:: EntraronDosDigitos ::..
        EntraronDosDigitos:
        pop cx                  ;Saca el digito menos significativo
        pop dx                  ;Saca el digito mas significativo
        
        mov al,dl
        sub al,30H              ;Le resta 30 a AL y tenemos el numero en decimal
        mov bl,0AH              ;Asigna a bl = 0AH
        mul bl                  ;Multiplica AL * BL Para convertir el numero en Hexadecimal
        
        sub cl,30H              ;Le resta 30 a CL para tener el numero en decimal
        add al,cl               ;Sumamos los numeros para ya tener el numero en Hexadecimal
        
        jmp FinEntradaNumeros   ;Va al fin de la entrada de numeros
        
        ; ..:: EntraronDosDigitos ::..
        EntraronTresDigitos:
        pop dx                  ;Saca el digito de las unidades
        pop cx                  ;Saca el digito de las decenas
        pop ax                  ;Saca el digito de las centenas
        
        sub al,30H              ;Le resta 30 a AL y tenemos el numero en decimal
        mov bl,64H              ;Asigna a BL 64H
        mul bl                  ;Multiplica AL * BL Para convertir las centenas en hexadecimal
        
        push ax                 ;Guarda el numero en la pila   
        
        sub cl,30H              ;Le resta 30 a CL
        mov ax, cx              ;Mueve el numero a AX
        mov bl, 0AH             ;Asigna a BX 0AH
        mul bl                  ;Multiplica AL * BL Para convertir las decenas en hexadecimal
        
        sub dl, 30H             ;Resta a DL 30H para convertirlo a Hexadecimal
        
        add al, dl              ;Suma las 'Decenas' con las unidades
        
        pop bx                  ;Saca las 'Centenas' y las pone en BX
        add al, bl              ;Suma las 'Centenas' 
        
        ;Ya tenemos el numero insertado en Hexadecimal
           
        FinEntradaNumeros:
        ;inc contador ;Le suma 1 al contador que indica cuantos numeros se han insertado
     ret
codigo  ends
    end inicio