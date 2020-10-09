include reporte.asm

print macro cadena
    mov ah,09h
    lea dx,cadena
    int 21h
endm

ObtenerTexto macro buffer
    local CONTINUE, FIN
        PUSH SI
        PUSH AX

        xor si,si
        CONTINUE:
            getChar
            cmp al,0dh
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

getChar macro
    mov ah,01h
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

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
    push si
    push cx 
    push bx
    push dx

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
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
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
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,45
		je NEGATIVO
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
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

;=========================== FICHEROS ===================
abrirF macro ruta,handle
    push dx
    xor ax,ax
    mov ah,3dh
    mov al,010b
    lea dx,ruta
    int 21h
    mov handle,ax
    jc ErrorAbrir
    pop dx
endm

leerF macro numbytes,buffer,handle
    push bx
	mov ah,3fh
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorLeer
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
            getChar
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
	jc ErrorCerrar
    pop bx
endm

borrarF macro ruta
    mov ah,41h
    lea dx,ruta
    int 21h
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
        inc si
        mov cx,si

    pop si
endm
