print macro cadena
mov ah,09h
mov dx,@data
mov ds,dx
mov dx,offset cadena
int 21h
endm

ObtenerTexto macro buffer
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
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm

printChar macro char
mov ah,02h
mov dl,char
int 21h
endm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
arreglo db 20 dup('$'),'$'
encab db 'Bienvenidos!!',10,13,'1) Ingresar Texto',10,13,'2) Mostrar Texto',10,13,'3) Mostrar ARR[0]',10,13,'4) Mostrar ARR[SI]',10,13,'5) Salir',10,13,'Escoja Opcion','$'
.code	
	
main proc
	MenuPrincipal:
		print encab
		getChar
		cmp al,'1'
		je INGRESAR
		cmp al,'2'
		je MOSTRAR
		cmp al,'3'
		je MOSTRAR1
		cmp al,'4'
		je MOSTRAR2
		cmp al,'5'
		je SALIR
		jmp MenuPrincipal

	MOSTRAR1:
		mov dh,arreglo[3]
		printChar dh
		getChar
		jmp MenuPrincipal

	MOSTRAR2:
		xor si,si
		mov dh,arreglo[si]
		printChar dh
		getChar
		jmp MenuPrincipal

	MOSTRAR:
		print arreglo
		getChar
		jmp MenuPrincipal

	INGRESAR:
		ObtenerTexto arreglo

		getChar
		jmp MenuPrincipal

	SALIR:
		mov ah,4ch
		int 21h

main endp

end