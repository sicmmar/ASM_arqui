;===============SECCION DE MACROS ===========================
include c7_m.asm

;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encab db 0ah,0dh,' CLASE 7 ARQUI 1',0ah,0dh,'1) Abrir archivo', 0ah,0dh,'2) Crear Archivo',0ah,0dh,'3) Leer Archivo',0ah,0dh,'4) Salir',0ah,0dh,'5) Escribir en Archivo',0ah,0dh,'$'
msm1 db 0ah,0dh,'FUNCION ABRIR',0ah,0dh,'$'
msm2 db 0ah,0dh,'FUNCION CREAR',0ah,0dh,'$'
msm3 db 0ah,0dh,'FUNCION LEER',0ah,0dh,'$'
msm4 db 0ah,0dh,'FUNCION ESCRIBIR',0ah,0dh,'$'
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
msmError4 db 0ah,0dh,'Error al Escribir archivo','$'
rutaArchivo db 100 dup('$')
bufferLectura db 100 dup('$')
bufferEscritura db 100 dup('$')
handleFichero dw ?
handle2 dw ?
.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print encab
			getChar
			cmp al,'1'
			je ABRIR
			cmp al,'2'
			je CREAR
			cmp al,'4'
			je SALIR
			cmp al, '5'
			je ESCRIBIR
			cmp al,'3'
			jmp LEER
			jmp Menu
		ABRIR:
			print msm1
			getRuta rutaArchivo
			abrirF rutaArchivo,handleFichero
			getChar
			jmp Menu
		LEER:
			print msm3
			leerF SIZEOF bufferLectura,bufferLectura,handleFichero
			print bufferLectura
			getChar
			jmp Menu
		CREAR:
			print msm2
			getRuta rutaArchivo
			crearF rutaArchivo, handle2
			getChar
			jmp Menu
		ESCRIBIR:
			print msm4
			getTexto bufferEscritura
			escribirF handle2, SIZEOF bufferEscritura, bufferEscritura
			getChar
			jmp Menu
	    ErrorAbrir:
	    	print msmError1
	    	getChar
	    	jmp Menu
	    ErrorLeer:
	    	print msmError2
	    	getChar
	    	jmp Menu
	    ErrorCrear:
	    	print msmError3
	    	getChar
	    	jmp Menu
	    ErrorEscribir:
	    	print msmError4
	    	getChar
	    	jmp Menu
		SALIR: 
			MOV ah,4ch 
			int 21h
	main endp
;================ FIN DE SECCION DE CODIGO ========================
end