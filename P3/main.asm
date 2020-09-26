include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
arregloAux db 100 dup('$'),'$'
bufferLectura db 100 dup('$')
bufferEscritura db 100 dup('$')
handleFichero dw ?
handle2 dw ?
fileHtml db 'estadoTablero.html',00h,00h
encab db 10,10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
enc db 10,10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A','$'
encab2 db 10,13,10,13,'1. Iniciar Juego',10,13,'2. Cargar Juego',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
msjTBlancas db 10,13,'::Turno Blancas ','$'
msjTNegras db 10,23,'::Turno Negras ','$'
guionesInicio db 9,32,32,32,218,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,191,10,13,'$'
guionesFin db 9,32,32,32,192,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,217,10,13,'$'
guiones db 9,32,32,32,195,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,180,10,13,'$'
abc db 9,32,32,32,' A  B  C  D  E  F  G  H  ',10,13,'$'
msjOpc1 db 10,10,13,9,201,205,205,205,205,205,205,' JUEGO INICIADO ',205,205,205,205,205,205,187,10,13,'$'
msjOpc2 db 10,10,13,9,'-----------------------  CARGAR JUEGO  -----------------------',10,13,'$'
msjOpc3 db 10,10,13,9,205,205,205,205,205,205,205,205,205,205,205,'  ADIOS  ',205,205,205,205,205,205,205,205,205,205,205,10,13,'$'
saltoln db 10,13,'$'
pos1 db 9 dup(32), '$'
pos2 db 9 dup(32), '$'
pos3 db 9 dup(32), '$'
pos4 db 9 dup(32), '$'
pos5 db 9 dup(32), '$'
pos6 db 9 dup(32), '$'
pos7 db 9 dup(32), '$'
pos8 db 9 dup(32), '$'
comando db 9 dup(32), '$'
;; mensajees :D
errorComando db ' ',173,173,' Error, ingresa un comando v',160,'lido !!','$'
errorMovimiendo db ' ',173,173,' Error, ingresa un movimiento v',160,'lido !!','$'
errorTurno db ' ',173,173,' Error, a',163,'n no te toca mover ficha !!','$'
errorBlanco db ' ',173,173,' Error, no se puede mover a la casilla indicada !!','$'
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
msmError4 db 0ah,0dh,'Error al escribir archivo','$'
msmError5 db 0ah,0dh,'Error al cerrar archivo','$'
ingreseRuta db 10,13, '::Ingresa nombre archivo ','$'
aCargar db 'a cargar ','$'
showSuccess db 10,13, ' ',173,173,' Estado actual de juego generado !!','$'

;etiq HTML
htmlEncab1 db '<!DOCTYPE html><html><head><meta charset="UTF-8"><style>body {background-image: url("tabla.png");background-repeat: no-repeat;background-attachment: fixed;background-size: 100% 100%;}td',10,13
htmlEncab2 db '{height: 61px;width: 61px;}th, tfoot{background-color: white;}</style><title>201504051</title></head><body><div style="height: 225px;"></div><div style="margin-left: 375px;"><table><tr>',10,13
fechaHTML db '<th colspan="8">Fecha: ',32,32,'/',32,32,'/20',32,32,'</th></tr>',10,13
inicioTR db 10,13,'<tr>'
finT db '</tr>',10,13
filaParHTMLx4 db '<td style="background-color: beige;"></td><td style="background-color: brown;">',32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,'</td>'
filaImparHTMLx4 db '<td style="background-color: brown;">',32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,'</td><td style="background-color: beige;"></td>'
negraHTML db '<img src="negra.png"/></td>    ' ;tam 27
blancaHTML db '<img src="blanca.png"/></td>    ' ;tam 28
negraReinaHTML db '<img src="negraR.png"/></td>    ' ;tam 28
blancaReinaHTML db '<img src="blancaR.png"/></td>    ' ;tam 29
horaHTML db '<tr><th colspan="8">Hora: ',32,32,':',32,32,':',32,32,'</th></tr></table></div></body></html>'

;archivo arq
filaArch db ' , , , , , , , ',10,13
saveSuccess db 10,13, ' ',173,173,' Juego guardado con ',130,'xito !!','$'
loadSuccess db 10,13, ' ',173,173,' Juego cargado con ',130,'xito !!','$'

.code	
	
main proc
    mov dx,@data
    mov ds,dx

	MenuPrincipal:
		llenarInicial pos8,pos7,pos6,pos3,pos2,pos1
		mov comando[2],1b
		mov comando[3],0b
		print encab
		print enc
		print encab2
		getChar
		cmp al,'1'
		je INICIOJUEGO
		cmp al,'2'
		je CARGAJUEGO
		cmp al,'3'
		je SALIR
		jmp MenuPrincipal

	INICIOJUEGO:
        mov comando[7],00b
		mov comando[4],0b
    	accionesDef comando
		print msjOpc1
		print saltoln
		print abc
		print guionesInicio
		imprimirTablero pos8,pos7,pos6,pos5,pos4,pos3,pos2,pos1,arregloAux,guiones
		print guionesFin
		print abc
		cleanArr arregloAux, sizeof arregloAux
		sigTurno
		;print msjTBlancas
		;ObtenerTexto arregloAux
		colocarAccion arregloAux,comando,errorComando
		;comandos especiales
		xor bx,bx
		mov bl,comando[7]
		cmp bl,1111b ;exit
		je MenuPrincipal
		cmp bl,1101b ;show
		je CREARHTML
		cmp bl,1110b ;save
		je SAVE 
		
		movimiento comando, errorMovimiendo
		jmp INICIOJUEGO

	SAVE:
		mov handle2,00h
		print ingreseRuta
		getRuta arregloAux
		crearF arregloAux, handle2
		guardarArq pos8
		guardarArq pos7
		guardarArq pos6
		guardarArq pos5
		guardarArq pos4
		guardarArq pos3
		guardarArq pos2
		guardarArq pos1
		cerrarF handle2
		mov handle2,00h
		jnc SAVECREADO
		jmp INICIOJUEGO
	
	CARGAJUEGO:
		mov handle2,00h
		print msjOpc2
		print ingreseRuta
		print aCargar
		getRuta arregloAux
		abrirF arregloAux, handle2
		cargaFichero pos8
		cargaFichero pos7
		cargaFichero pos6
		cargaFichero pos5
		cargaFichero pos4
		cargaFichero pos3
		cargaFichero pos2
		cargaFichero pos1
		cerrarF handle2
		mov handle2,00h
		print loadSuccess
		getChar
		jmp INICIOJUEGO

	SALIR:
		print msjOpc3
		mov ah,4ch
		int 21h
	
	CREARHTML:
		mov handle2,00h
		crearF fileHtml, handle2
		escribirF handle2, sizeof htmlEncab1, htmlEncab1
		escribirF handle2, sizeof htmlEncab2, htmlEncab2
		escribirFecha handle2, fechaHTML, horaHTML
		; fila 8
		escribirF handle2, sizeof inicioTR, inicioTR
		filaParHTML pos8
		escribirF handle2, sizeof finT, finT
		;fila 7
		escribirF handle2, sizeof inicioTR, inicioTR
		filaImparHTML pos7
		escribirF handle2, sizeof finT, finT
		;fila 6
		escribirF handle2, sizeof inicioTR, inicioTR
		filaParHTML pos6
		escribirF handle2, sizeof finT, finT
		;fila 5
		escribirF handle2, sizeof inicioTR, inicioTR
		filaImparHTML pos5
		escribirF handle2, sizeof finT, finT
		;fila 4
		escribirF handle2, sizeof inicioTR, inicioTR
		filaParHTML pos4
		escribirF handle2, sizeof finT, finT
		;fila 3
		escribirF handle2, sizeof inicioTR, inicioTR
		filaImparHTML pos3
		escribirF handle2, sizeof finT, finT
		;fila 2
		escribirF handle2, sizeof inicioTR, inicioTR
		filaParHTML pos2
		escribirF handle2, sizeof finT, finT
		;fila 1
		escribirF handle2, sizeof inicioTR, inicioTR
		filaImparHTML pos1
		escribirF handle2, sizeof finT, finT

		escribirF handle2, sizeof horaHTML, horaHTML
		cerrarF handle2
		cleanArr arregloAux, sizeof arregloAux
		mov handle2,00h
		jnc SHOWCREADO
		;getChar
		jmp INICIOJUEGO

	
	
	ErrorAbrir:
		print msmError1
		getChar
		jmp MenuPrincipal

	ErrorLeer:
		print msmError2
		getChar
		jmp MenuPrincipal

	ErrorCrear:
		print msmError3
		getChar
		jmp MenuPrincipal

	ErrorEscribir:
		print msmError4
		getChar
		jmp MenuPrincipal

	ErrorCerrar:
		print msmError5
		getChar
		jmp MenuPrincipal

	SHOWCREADO:
		print showSuccess
		getChar
		jmp INICIOJUEGO

	SAVECREADO:
		print saveSuccess
		getChar
		jmp INICIOJUEGO

main endp


DISP PROC
    MOV DL,BH      ; Since the values are in BX, BH Part
    ADD DL,30H     ; ASCII Adjustment

    MOV al,BL      ; BL Part 
    ADD al,30H     ; ASCII Adjustment
    RET
DISP ENDP      ; End Disp Procedure

end