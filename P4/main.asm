include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
arregloAux db 70 dup('$'),10,13
bufferLectura db 30000 dup('$')
bufferEscritura db 200 dup('$')
resultados db 1000 dup('$')
handleFichero dw ?
handle2 dw ?
rutaAux db 'nuevo.arq',00h,00h

exit db 'exit','$'
shMedia db 'show media','$'
mediaes db 10,13,'::La media es:                          ','$' ;pos 17
shModa db 'show moda','$'
modaes db 10,13,'::La moda es:                          ','$' ;pos 16
shMediana db 'show mediana','$'
medianaes db 10,13,'::La mediana es:                          ','$' ;pos 19
shMayor db 'show mayor','$'
mayores db 10,13,'::El n',163,'mero mayor es:                          ','$' ;pos 24
shMenor db 'show menor','$'
menores db 10,13,'::El n',163,'mero menor es:                          ','$' ;pos 24
addRes1 db ' add','$'
addRes2 db ' +','$'
subRes1 db ' sub','$'
subRes2 db ' -','$'
mulRes1 db ' mul','$'
mulRes2 db ' *','$'
divRes1 db ' div','$'
divRes2 db ' /','$'
idRes db ' id','$'


encab db 10,10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
enc db 10,10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A','$'
encab2 db 10,13,10,13,'1. Cargar Archivo',10,13,'2. Consola',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
msjOpc1 db 10,10,13,9,'-----------------------  CARGAR ARCHIVO  -----------------------',10,13,'$'
msjOpc2 db 10,10,13,9,'-----------------------  CONSOLA  -----------------------',10,13,'$'
msjOpc3 db 10,10,13,9,'-----------------------  ADIOS  -----------------------',10,13,'$'
saltoln db 10,13,'$'
console db 10,13,32,32,175,32,'$'
;; mensajees :D
msmError1 db 0ah,0dh,'Error al abrir archivo','$'
msmError2 db 0ah,0dh,'Error al leer archivo','$'
msmError3 db 0ah,0dh,'Error al crear archivo','$'
msmError4 db 0ah,0dh,'Error al escribir archivo','$'
msmError5 db 0ah,0dh,'Error al cerrar archivo','$'
errorComando db ' ',173,173,' Error, ingresa un comando v',160,'lido !!','$'
ingreseRuta db 10,13, '::Ingresa nombre archivo a cargar  ','$'

;archivo - reporte
rep1 db '{',10,13,' '
saveSuccess db 10,13, ' ',173,173,' Archivo guardado con ',130,'xito !!','$'
loadSuccess db 10,13, ' ',173,173,' Archivo cargado con ',130,'xito !!','$'

.code	
	
main proc
    mov dx,@data
    mov ds,dx

	MenuPrincipal:
		print encab
		print enc
		print encab2
		getChar
		cmp al,'1'
		je CARGA
		cmp al,'2'
		je CONSOLA
		cmp al,'3'
		je SALIR
		jmp MenuPrincipal

	
	CARGA:
        mov handle2,00h
		print msjOpc1
        print ingreseRuta
        getRuta arregloAux
        abrirF arregloAux,handle2
        leerF sizeof bufferLectura, bufferLectura, handle2
        cerrarF handle2

        mov handle2,00h

        crearF rutaAux,handle2
        cleanArr arregloAux
        tamanoArr bufferLectura
        mov bx,cx
        sub bx,1
        mov di,bx
        calcularJson bufferLectura
        cerrarF handle2
        mov handle2,00h

        print loadSuccess
        getChar

		jmp MenuPrincipal
        
    CONSOLA:
        print msjOpc2
        print console
        cleanArr arregloAux
        ObtenerTexto arregloAux

        tamanoArr exit
        comparar arregloAux,exit
        cmp ah,1b
        je EXITCONSOLA
        tamanoArr shMedia
        comparar arregloAux,shMedia
        cmp ah,1b
        je MEDIA
        tamanoArr shModa
        comparar arregloAux,shModa
        cmp ah,1b
        je MODA
        tamanoArr shMediana
        comparar arregloAux,shMediana
        cmp ah,1b
        je MEDIANA
        tamanoArr shMayor
        comparar arregloAux,shMayor
        cmp ah,1b
        je MAYOR
        tamanoArr shMenor
        comparar arregloAux,shMenor
        cmp ah,1b
        je MENOR

        jne ErrorCmd
        jmp CONSOLA
    
    MEDIA:
        print mediaes
        jmp CONSOLA

    MODA:
        print modaes
        jmp CONSOLA
    
    MEDIANA:
        print medianaes
        jmp CONSOLA

    MAYOR:
        print mayores
        jmp CONSOLA

    MENOR:
        print menores
        jmp CONSOLA
    
    EXITCONSOLA:
        jmp MenuPrincipal


	SALIR:
        borrarF rutaAux
		print msjOpc3
		mov ah,4ch
		int 21h
    
    ErrorCmd:
        print errorComando
        getChar
        jmp CONSOLA
	    
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

main endp


DISP PROC
    MOV DL,BH      ; Since the values are in BX, BH Part
    ADD DL,30H     ; ASCII Adjustment

    MOV al,BL      ; BL Part 
    ADD al,30H     ; ASCII Adjustment
    RET
DISP ENDP      ; End Disp Procedure

end