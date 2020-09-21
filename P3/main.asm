include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
arregloAux db 39 dup('$'),'$'
encab db 10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A',10,13,10,13,'1. Iniciar Juego',10,13,'2. Cargar Juego',10,13,'3. Salir',10,13,10,'::Escoga una opci',162,'n  ','$'
msjTBlancas db 10,13,'::Turno Blancas ','$'
msjTNegras db 10,23,'::Turno Negras ','$'
guionesInicio db 9,32,32,32,218,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,194,196,196,191,10,13,'$'
guionesFin db 9,32,32,32,192,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,193,196,196,217,10,13,'$'
guiones db 9,32,32,32,195,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,197,196,196,180,10,13,'$'
abc db 9,32,32,32,' A  B  C  D  E  F  G  H  ',10,13,'$'
msjOpc1 db 10,10,13,9,201,205,205,205,205,205,205,' JUEGO INICIADO ',205,205,205,205,205,205,187,10,13,'$'
msjOpc2 db 10,10,13,9,201,205,205,205,205,205,205,'  CARGAR JUEGO  ',205,205,205,205,205,205,187,10,13,'$'
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
comando db 3 dup('$'), '$'
errorComando db ' ',173,173,' Error, ingresa un comando v',160,'lido !!','$'
.code	
	
main proc
    mov dx,@data
    mov ds,dx

	MenuPrincipal:
		llenarInicial pos8,pos7,pos6,pos3,pos2,pos1
		print encab
		getChar
		cmp al,'1'
		je INICIOJUEGO
		cmp al,'2'
		je CARGAJUEGO
		cmp al,'3'
		je SALIR
		jmp MenuPrincipal

	INICIOJUEGO:
		print msjOpc1
		print saltoln
		print abc
		print guionesInicio
		imprimirTablero pos8,pos7,pos6,pos5,pos4,pos3,pos2,pos1,arregloAux,guiones
		print guionesFin
		print abc
		print msjTBlancas
		ObtenerTexto arregloAux
		juego arregloAux, comando, errorComando
		;comandos especiales
		xor bx,bx
		mov bl,comando[0]
		cmp bl,1111b ;exit
		je MenuPrincipal
	
		jmp INICIOJUEGO

	CARGAJUEGO:
		print msjOpc2
		jmp MenuPrincipal

	SALIR:
		print msjOpc3
		mov ah,4ch
		int 21h

main endp

end