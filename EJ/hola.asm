;===============SECCION DE MACROS ===========================
print macro cadena ;print -> id del macro ;macro -> palabra reservada, representa al macro; cadena -> parámetro
LOCAL ETIQUETA ;LOCAL -> palabra reservada, representa la espera de una lista de etiquetas
	ETIQUETA: ;etiqueta
		MOV ah,09h ;función para la impresión de cadenas
		MOV dx,@data ;lugar donde se ecuentra almacenados nuestros datos
		MOV ds,dx 
		MOV dx, offset cadena ;desplazamiento de la cadena de datos
		int 21h ;interrupción 21h
endm

;================= DECLARACION TIPO DE EJECUTABLE ============
.model small ;modo en el que se creará el ejecutable
.stack 100h ;espacio asignado a la pila
.data ;segemento de datos
;================ SEGMENTO DE DATOS ========================
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
holamundo db 10,13,'Hola mundo','$' ;caracter "$" para finalizar cadenas;
;10, 13	   
;se pueden concatenar caracteres ascii haciendo uso de su código ascii en decimal o en hexadecimal
;se concatenan con la coma, ejemplo: 'HOLA','_CONCATENADO',10h,'$'
holamundo2 db 0ah,0dh, 'Hola mundo 2','$'
.code ;segmento de código
;================== SEGMENTO DE CODIGO ===========================
	main proc ;inicio de procedimiento
		Imprimir:
			print holamundo ;llamada al macro declarado hasta arriba
			print holamundo2 ;llamada al macro declarado hasta arriba
		Salir: 
			MOV ah,4ch ;función de la interrupcion 21h para finalizar el programa
			int 21h
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end