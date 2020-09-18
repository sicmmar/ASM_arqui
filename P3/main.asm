include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
arregloAux db 39 dup('$'),'$'
encab db 10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A',10,13,10,13,'1. Iniciar Juego',10,13,'2. Cargar Juego',10,13,'3. Salir',10,13,10,'::Escoga una opci',162,'n  ','$'
msjTBlancas db 10,13,'::Turno Blancas ','$'
msjTNegras db 10,23,'::Turno Negras ','$'
guiones db 32,9,'-------------------------',10,13,'$'
abc db 32,9,' A  B  C  D  E  F  G  H  ',10,13,'$'
saltoln db 10,13,'$'
pos1 db 9 dup(32), '$'
pos2 db 9 dup(32), '$'
pos3 db 9 dup(32), '$'
pos4 db 9 dup(32), '$'
pos5 db 9 dup(32), '$'
pos6 db 9 dup(32), '$'
pos7 db 9 dup(32), '$'
pos8 db 9 dup(32), '$'
.code	
	
main proc
	MenuPrincipal:
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
		llenarInicial pos8,pos7,pos6,pos3,pos2,pos1
		print saltoln
		print abc
		print guiones
		imprimirTablero pos8,pos7,pos6,pos5,pos4,pos3,pos2,pos1,arregloAux,guiones
		print abc
		print msjTBlancas
		getChar
		jmp MenuPrincipal

	CARGAJUEGO:
		xor si,si
		mov dh,arregloAux[si]
		printChar dh
		getChar
		jmp MenuPrincipal

	SALIR:
		mov ah,4ch
		int 21h

main endp

end