mostrarTextoVideo macro numTam, fila, columna, cadena

    push ax
    push bx
    push cx
    push dx
    push si
    push di

    push ds
    pop es

    mov ah,13h
    mov al,0
    mov bh,0
    mov bl,0
    mov cx,numTam
    mov dh,fila
    mov dl,columna
    lea bx,cadena
    mov bp,bx
    int 10h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

endm

PintarBarra macro color,inicio, tam, altura
	local BARRA, FIN, INICION
	push di
	push si
	push bx
	push dx 
    push cx
    push ax

	mov ax,color
	mov dx,tam 
	sub dx,3; ancho de la barra
	mov si,inicio

	mov cx,altura

	;fila i, columna j = (i,j) = 320 * i + j

	;empieza en pixel (i,j) = (185,10) = 320 * 185 + 10 = 59210
	INICION:
		cmp cx,0
		jle FIN 

		mov di,si ;este es el inicio

		mov bx,si
		add bx,dx ;BX fin horizontalmente

		BARRA:
			mov [di],ax
			inc di
			cmp di,bx
			jne BARRA
		
		sub si,320
		dec cx
		jmp INICION

	FIN:
        pop ax
        pop cx
		pop dx
		pop bx
		pop si
		pop di

endm

pintarNumeros macro arreglo
    local INICIO, FIN

    push si
    push cx
    push di
    push dx

    xor dx,dx
    xor si,si
    getTamanoWord arreglo
    mov di,cx
    mov dl,2

    INICIO:
        cmp si,di
        jge FIN

        cleanArr arregloAux2
        mov ax,arreglo[si]
        ConvertirStringByte arregloAux2
        tamanoArr arregloAux2
        call unirNumeros 
        add dl,2


        inc si
        inc si
        jmp INICIO

    FIN:
        mostrarTextoVideo 37,22,2,arregloAux
        pop dx
        pop di
        pop cx
        pop si
endm
