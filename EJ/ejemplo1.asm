print macro cadena
LOCAL ETIQUETA
	ETIQUETA:
		MOV ah,09h
		MOV dx,@data
		MOV ds,dx
		MOV dx, offset cadena
		int 21h
endm

.model small
.stack 100h
.data
;segmento de datos
;el siguiente es un arreglo
holamundo db 0ah,0dh,'Hola Mundo','$'
holamundo2 db 0ah,0dh,'Hola Mundo 2','$'
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
;segmento de codigo
.code 
	main proc
		Imprimir:
			print holamundo
			print holamundo2

		Salir:
			MOV ah,4ch
			int 21h
	main endp

end