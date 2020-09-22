print macro cadena 
	LOCAL ETIQUETA 
	ETIQUETA: 
		MOV ah,09h 
		MOV dx,@data 
		MOV ds,dx 
		MOV dx, offset cadena 
		int 21h
endm

getRuta macro buffer
LOCAL INICIO,FIN
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
endm

getTexto macro buffer
LOCAL INICIO1,FIN1
	xor si,si
INICIO1:
	getChar
	cmp al,0dh
	je FIN1
	mov buffer[si],al
	inc si
	jmp INICIO1
FIN1:
	mov buffer[si],'$'

endm

getChar macro
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm

;=========================== FICHEROS ===================
abrirF macro ruta,handle
mov ah,3dh
mov al,010b
lea dx,ruta
int 21h
mov handle,ax
jc ErrorAbrir
endm

leerF macro numbytes,buffer,handle
	mov ah,3fh
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorLeer
endm

crearF macro ruta, handle
mov ah,3ch
mov cx,00h
lea dx, ruta
int 21h
mov handle,ax
jc ErrorCrear
endm

escribirF macro handle, numBytes, buffer
mov ah,40h
mov bx,handle
mov cx,numBytes
lea dx,buffer
int 21h
jc ErrorEscribir
endm