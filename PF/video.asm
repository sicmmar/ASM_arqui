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

ejecutarSonido macro valor
	local FIN, BLANCO, VERDE, AMARILLO, AZUL, ROJO

	push ax

	cmp valor,99
	jg FIN
	cmp valor,81
	jge BLANCO
	cmp valor,61
	jge VERDE
	cmp valor,41
	jge AMARILLO
	cmp valor,21
	jge AZUL
	cmp valor,1
	jge ROJO

	jmp FIN

	BLANCO:
		sonido 900
		jmp FIN

	VERDE:
		sonido 700
		jmp FIN

	AMARILLO:
		sonido 500
		jmp FIN

	AZUL:
		sonido 300
		jmp FIN

	ROJO:
		sonido 100

	FIN:
		pop ax
endm

sonido macro hz
	mov al, 86h
	out 43h, al
	mov ax, (1193180 / hz) ;numero de hz
	out 42h, al
	mov al, ah
	out 42h, al 
	in al, 61h
	or al, 00000011b

	out 61h, al
	call delay ;mando a ejecutar el delay para que se escuche el sonido por varios segundos
	 ; apagar la bocina
	in al, 61h
	and al, 11111100b
	out 61h, al
endm