
print macro cadena
LOCAL ETIQUETA
ETIQUETA:
	MOV ah,09h
	MOV dx, offset cadena
	int 21h
endm

getChar macro
    mov ah,0dh
    int 21h
    mov ah,01h
    int 21h
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
buffer3 db 100 dup('$')
resultado db 100 dup('$')
res word 50 dup('$')
auxDiv word ?
auxDiv2 word ?
.code

	main proc
	MOV dx,@data
	MOV ds,dx 

		Imprimir:
			getNumero buffer
			getNumero buffer2
			ConvertirAscii buffer
			mov bx,ax
			push bx
			ConvertirAscii buffer2
			pop bx


			mov cx,ax
			mov ax,bx

			xor dx,dx

			DIVIDIRS:
				cmp ax,0
				jl NEG1
				cmp cx,0
				jl NEG2

				div cx
				jmp FINDIV

			NEG1:
				mov auxDiv,1b
				neg ax
				cmp cx,0
				jl NEG2

				div cx
				jmp FINDIV
			
			NEG2:
				mov auxDiv2,1b
				neg cx

				div cx
				jmp FINDIV

			FINDIV:
				mov cx,auxDiv
				mov dx,auxDiv2
				xor cx,dx
				cmp cx,1b
				je DIVNEG
				jmp PRINTDIV

			DIVNEG:
				mov cx,ax
				mov dx,2
				mul dx
				sub cx,ax
				mov ax,cx

			PRINTDIV:
				ConvertirString res
				;print resultado
				;mov res,ax
				print res



		Salir: 
			MOV ah,4ch
			int 21h
	main endp

end