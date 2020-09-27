
print macro cadena
LOCAL ETIQUETA
ETIQUETA:
	MOV ah,09h
	MOV dx, offset cadena
	int 21h
endm

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
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
endm

CovertirAscii macro numero
	LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm

getChar macro
	mov ah,01h
	int 21h
endm

getNumero macro buffer
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

.model small
.stack 100h
.data
holamundo db 0ah,0dh,'Hola mundo','$'
buffer db 100 dup('$')
buffer2 db 100 dup('$')
resultado db 100 dup('$')
.code

	main proc
	MOV dx,@data
	MOV ds,dx 

		Imprimir:
			getNumero buffer
			getNumero buffer2
			CovertirAscii buffer
			mov bx,ax
			push bx
			CovertirAscii buffer2
			pop bx

			add ax,bx
			;adc ax,bx
			
			;sub ax,bx
			;sbb ax,bx

			;mul bx
			;xor dx,dx
			;div bx

			ConvertirString resultado
			print resultado



		Salir: 
			MOV ah,4ch
			int 21h
	main endp

end