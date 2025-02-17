include video.asm

verTeclaPresionada macro
    local FIN

    mov ah,01
    int 16h
    jz FIN
    
    getKey

    FIN:
endm

getKey macro
    mov ah,00
    int 16h
endm

ObtenerTexto macro buffer
    local CONTINUE, FIN
        PUSH SI
        PUSH AX

        xor si,si
        CONTINUE:
            cmp si,7
            je FIN

            call getChar
            cmp al,32
            je FIN
            
            mov buffer[si],al
            inc si
            jmp CONTINUE

        FIN:
            mov al,'$'
            mov buffer[si],al

        POP AX
        POP SI
endm

ObtenerPwd macro buffer
    local CONTINUE, FIN, INVALIDO
        PUSH SI
        PUSH AX

        xor si,si
        mov ch,01h
        CONTINUE:
            getPwd
            cmp si,4
            jge FIN

            cmp al,48
            jl INVALIDO
            cmp al,57
            jg INVALIDO

            mov buffer[si],al
            mostAsts
            inc si
            jmp CONTINUE

        INVALIDO:
            lea dx, contraNumerica
            call print
            mov ch,00h
        FIN:
            mov al,'$'
            mov buffer[si],al

        POP AX
        POP SI
endm

mostAsts macro
    mov ah,06h
    mov dl,'*'
    int 21h
endm

getPwd macro
    mov ah,08h
    int 21h
endm

printChar macro char
    push dx
    mov ah,02h
    mov dl,char
    int 21h
    pop dx
endm

cleanArr macro arr
    local CONTINUE, FIN
    PUSH SI
    PUSH AX
    push bx
    push cx

    xor si,si
    tamanoArr arr
    mov bx,cx
    CONTINUE:
        cmp si,bx
        je FIN
        mov al,'$'
        mov arr[si],al
        inc si
        jmp CONTINUE

    FIN:
        mov al,'$'
        mov arr[si],al

    pop cx
    pop bx
    POP AX
    POP SI
endm

cleanArrWord macro arr
    local CONTINUE, FIN
    PUSH SI
    PUSH AX
    push cx

    xor si,si
    CONTINUE:
        cmp si,50
        je FIN
        mov ax,00h
        mov arr[si],ax
        inc si
        inc si
        jmp CONTINUE

    FIN:
        mov ax,00h
        mov arr[si],ax

    pop cx
    POP AX
    POP SI
endm

ConvertirStringByte macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
    push si
    push cx 
    push bx
    push dx
    push ax

	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx

	mov dl,0ah
	cmp ax,0
	jl NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,32
		mov buffer[si],ah
		inc si
	FIN:
        mov buffer[si],32
        pop ax
        pop dx
        pop bx
        pop cx
        pop si
endm

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
    push si
    push cx 
    push bx
    push dx
    push ax

	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx

	mov bx,0ah
	cmp ax,0
	jl NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor dx,dx
	Dividir2:
		div bx
		inc cx
		push dx
		cmp ax,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop dx
		add dx,30h
		mov buffer[si],dx
		inc si
		loop FinCr3
		mov dx,24h
		mov buffer[si],dx
		inc si
	FIN:
        pop ax
        pop dx
        pop bx
        pop cx
        pop si
endm

ConvertirAscii macro numero
	LOCAL INICIO,FIN, NEGATIVO, NEGAT,FINEG

    push si
    push bx
	xor ax,ax
	xor bx,bx

	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
	    xor cx,cx
		mov cl,numero[si] 
		cmp cl,45
		je NEGATIVO
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cx,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO

	NEGATIVO:
		inc si
		jmp NEGAT

	NEGAT:
		mov cl,numero[si]
		cmp cl,48
		jl FINEG
		cmp cl,57
		jg FINEG
		inc si
		sub cl,48
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp NEGAT

	FINEG:
		mov cx,ax
		mov bx,2
		mul bx
		sub cx,ax
		mov ax,cx


	FIN:
        pop bx
        pop si
endm

ConvertirSumaAscii macro numero
	LOCAL INICIO,FIN

    push si
    xor ax,ax

	xor si,si
	INICIO:
	    xor cx,cx
		mov cl,numero[si] 
		cmp cl,'$'
		je FIN

        add ax,cx
		inc si
		jmp INICIO

	FIN:
        pop si
endm

colocarRespuesta macro arreglo
    local INICIO, FIN

    push si
    push bx
    xor si,si

    INICIO:
        mov bx,arreglo[si]
        cmp bx,00h
        je FIN

        inc si
        inc si
        jmp INICIO

    FIN:
        mov arreglo[si],ax
    
    pop bx
    pop si

endm

colocarColores macro arreglo
    local INICIO, FIN, ROJO, AZUL, AMARILLO, VERDE, BLANCO, FINALIZAR

    push si
    push bx
    xor si,si

    INICIO:
        mov bx,arreglo[si]
        cmp bx,00h
        je FIN

        inc si
        inc si
        jmp INICIO

    FIN:
        mov arreglo[si],ax
        
        cmp ax,20d
        jle ROJO
        cmp ax,40d
        jle AZUL
        cmp ax,60d
        jle AMARILLO
        cmp ax,80d
        jle VERDE
        cmp ax,99d
        jle BLANCO

    ROJO:
        mov barrasGrafica[si],0Ch
        jmp FINALIZAR
    
    AZUL:
        mov barrasGrafica[si],09h
        jmp FINALIZAR

    AMARILLO:
        mov barrasGrafica[si],0Eh
        jmp FINALIZAR

    VERDE:
        mov barrasGrafica[si],02h
        jmp FINALIZAR
    
    BLANCO:
        mov barrasGrafica[si],0Fh
    
    FINALIZAR:
        pop bx
        pop si

endm

;=========================== FICHEROS ===================
abrirF macro ruta,handle
    push dx
    xor ax,ax
    mov ah,3dh
    mov al,010b
    lea dx,ruta
    int 21h
    mov handle,ax
    ;jc ErrorAbrir
    pop dx
endm

leerF macro numbytes,buffer,handle
    push bx
	mov ah,3fh
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	;jc ErrorLeer
    pop bx
endm

crearF macro ruta, handle
    push ax
    push dx
    xor ax,ax
    mov ah,3ch
    mov cx,00h
    lea dx, ruta
    int 21h
    mov handle,ax
    jc ErrorCrear
    pop dx
    pop ax
endm

escribirF macro handle, numBytes, buffer
    push bx
    push dx
    mov ah,40h
    mov bx,handle
    mov cx,numBytes
    lea dx,buffer
    int 21h
    jc ErrorEscribir
    pop dx
    pop bx
endm

getRuta macro buffer
    LOCAL INICIO,FIN
    push si
    xor si,si
        INICIO:
            call getChar
            cmp al,0dh
            je FIN
            mov buffer[si],al
            inc si
            jmp INICIO
        FIN:
            mov buffer[si],00h
            inc si
            mov buffer[si],00h
            pop si
endm

cerrarF macro handle
    push bx
    xor ax,ax
	mov ah,3eh
	mov bx,handle
	int 21h
	;jc ErrorCerrar
    pop bx
endm

borrarF macro ruta
    mov ah,41h
    lea dx,ruta
    int 21h
endm

escribirA macro arreglo, handle
    local INICIO, FIN
    
    push si
    xor si,si

    INICIO:
        cmp arreglo[si],'$'
        je FIN

        inc si
        jmp INICIO

    FIN:
        mov cx,si
        escribirF handle, cx, arreglo


    pop si
endm

;==================== COMPARACIONES ========================
comparar macro actual, molde
    local INICIO, FIN

    push si
    xor si,si
    xor ax,ax
    tamanoArr molde

    INICIO:
        mov bh,actual[si]
        cmp bh,molde[si]
        jne FIN
        inc si
        loop INICIO
        mov ah,1b
    
    FIN:
        mov al,0b

    pop si      
    ;si son iguales, ah es 1b si no, al,0b
endm

tamanoArr macro actual
    local INICIO, FIN
    push si
    xor si,si
    
    INICIO:
        cmp actual[si],'$'
        je FIN
        inc si
        jmp INICIO
    
    FIN:
        mov cx,si

    pop si
endm

getTamanoWord macro actual
    local INICIO, FIN
    push si
    xor si,si
    
    INICIO:
        cmp actual[si],00h
        je FIN
        inc si
        inc si
        jmp INICIO
    
    FIN:
        mov cx,si

    pop si
endm

mostrarArreglo macro arreglo
    local INICIO, FIN
    push si
    xor si,si
    
    INICIO:
        cmp arreglo[si],00h
        je FIN

        mov ax,arreglo[si]
        ConvertirString auxWord
        lea dx, auxWord
        call print
        call getChar

        inc si
        inc si
        jmp INICIO
    
    FIN:
        mov cx,si

    pop si
endm

pasarArr macro actual, otro
    local INICIO
    push si
    xor si,si
    tamanoArr actual

    INICIO:
        mov bh,actual[si]
        mov otro[si],bh
        inc si
        loop INICIO

    pop si
endm