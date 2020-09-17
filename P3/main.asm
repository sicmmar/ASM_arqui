include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
arreglo db 20 dup('$'),'$'
encab db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A',10,13,10,13,'1. Iniciar Juego',10,13,'2. Cargar Juego',10,13,'3. Salir',10,13,10,'::Escoga una opci',162,'n  ','$'
msjTBlancas db 10,13,'::Turno Blancas ','$'
msjTNegras db 10,23,'::Turno Negras ','$'
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