include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
nombrePadre db 72 dup('$')
arregloAux db 70 dup('$'),10,13
ordenados word 100 dup(00h),'$'
variable word ?
auxWord word 34 dup('$'),10,13
resultadosTmp word 34 dup('$'),10,13
resultadosFinales word 100 dup(00h),'$'
idsFinales word 100 dup(00h),'$'
nombresIdentificadores db 3000 dup('$')
bufferLectura db 30000 dup('$')
bufferEscritura db 200 dup('$')
resultados db 1000 dup('$')
handleFichero dw ?
handle2 dw ?
handle dw ?
rutaAux db 'nuevo.arq',00h,00h
ruta2 db 'nuev2.arq',00h,00h
answers db 'reporte.json',00h,00h

exit db 'EXIT','$'
sh db 'SHOW','$'
shMedia db 'MEDIA','$'
mediaes db 10,10,13,'::La media es: ','$' ;pos 17
shModa db 'MODA','$'
modaes db 10,10,13,'::La moda es: ','$' ;pos 16
shMediana db 'MEDIANA','$'
medianaes db 10,10,13,'::La mediana es: ','$' ;pos 19
shMayor db 'MAYOR','$'
mayores db 10,10,13,'::El n',163,'mero mayor es: ','$' ;pos 24
shMenor db 'MENOR','$'
menores db 10,10,13,'::El n',163,'mero menor es: ','$' ;pos 24
addRes1 db ' add','$'
addRes2 db ' +','$'
subRes1 db ' sub','$'
subRes2 db ' -','$'
mulRes1 db ' mul','$'
mulRes2 db ' *','$'
divRes1 db ' div','$'
divRes2 db ' /','$'
numeral db ' #','$'
idRes db ' id','$'
aprox db ' aproximadamente','$'
elresid db 10,10,13,'El resultado de ','$'
esRes db ' es: ','$'
noexisteMsj db 'La operaci',162,'n que ingresaste no existe','$'
repGenerado db 10,10,13,32,173,173,' Reporte Generado !!','$'


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
rep1 db '{',10,13,9,'"reporte":{',10,13,9,9,'"alumno":{',10,13,9,9,9,'"nombre":"Asuncion Mariana Sic Sor",',10,13,9,9,9,'"carnet":201504051,',10,13,9,9,9,'"seccion":"A",'
rep2 db 10,13,9,9,9,'"curso":"Arquitectura de Computadores y Ensambladores 1"',10,13,9,9,'},',10,13,9,9,'"fecha":{',10,13,9,9,9,'"dia":'
fecha db '  ,',10,13,9,9,9,'"mes":  ,',10,13,9,9,9,'"a',126,'o":20  ',10,13,9,9,'},',10,13,9,9,'"hora":{',10,13,9,9,9,'"hora":'
hora db '  ,',10,13,9,9,9,'"minutos":  ,',10,13,9,9,9,'"segundos":  ',10,13,9,9,'},',10,13,9,9,'"resultados":{',10,13,9,9,9,'"media":'
medRep db ',',10,13,9,9,9,'"mediana":'
modRep db ',',10,13,9,9,9,'"moda":'
menRep db ',',10,13,9,9,9,'"menor":'
mayRep db ',',10,13,9,9,9,'"mayor":'
op1 db 10,13,9,9,'},',10,13,9,9,'"'
op2 db '":['
inOperaciones db 10,13,9,9,9,'{',10,13,9,9,9,9,'"'
middleOperaciones db '":'
finOperaciones db 10,13,9,9,9,'}'
coma db ','
finRep db 10,13,9,9,']',10,13,9,'}',10,13,'}'
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
        cleanArrWord resultadosFinales
        cleanArrWord idsFinales
        cleanArr nombresIdentificadores
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

        crearF ruta2,handleFichero
        abrirF rutaAux,handle2
        leerF sizeof bufferLectura,bufferLectura,handle2
        xor dx,dx
        mov bl,72
        div bl
        mov si,ax
        cerrarF handle2
        mov handle2,00h


        abrirF rutaAux,handle2
        analisis2
        cerrarF handle2
        cerrarF handleFichero
        mov handle2,00h
        mov handleFichero,00h
        borrarF rutaAux

        abrirF ruta2,handle2
        leerF sizeof bufferLectura,bufferLectura,handle2
        xor dx,dx
        mov bl,72
        div bl
        mov si,ax
        cerrarF handle2
        mov handle2,00h

        abrirF ruta2,handle2
        crearF rutaAux,handle
        leerF sizeof arregloAux,arregloAux,handle2
        pasarPadre
        operar
        cerrarF handle2
        borrarF ruta2
        mov handle2,00h

        print loadSuccess
        getChar

		jmp MenuPrincipal
        
    CONSOLA:
        print msjOpc2
        print console
        cleanArr arregloAux
        ObtenerTexto arregloAux

        comparar arregloAux,exit
        cmp ah,1b
        je EXITCONSOLA

        comparar arregloAux,sh
        cmp ah,1b
        je SHOWCMD

        jne ErrorCmd
        jmp CONSOLA
    
    MEDIA:
        print mediaes
        getMedia
        print resultadosTmp
        jmp CONSOLA

    MODA:
        print modaes
        jmp CONSOLA
    
    MEDIANA:
        print medianaes
        getMediana
        jmp CONSOLA

    MAYOR:
        print mayores
        getMayor
        print resultadosTmp
        jmp CONSOLA

    MENOR:
        print menores
        getMenor
        print resultadosTmp
        jmp CONSOLA
    
    EXITCONSOLA:
        jmp MenuPrincipal
    
    SHOWCMD:

        cleanArr arregloAux
        ObtenerTexto arregloAux

        comparar arregloAux,shMedia
        cmp ah,1b
        je MEDIA
        comparar arregloAux,shModa
        cmp ah,1b
        je MODA
        comparar arregloAux,shMediana
        cmp ah,1b
        je MEDIANA
        comparar arregloAux,shMayor
        cmp ah,1b
        je MAYOR
        comparar arregloAux,shMenor
        cmp ah,1b
        je MENOR
        comparar arregloAux,nombrePadre
        cmp ah,1b
        je REPORTEFINAL

        print elresid
        print arregloAux
        print esRes
        ConvertirSumaAscii arregloAux
        add ax,32
        searchID 

        cmp dx,0
        je NOEXISTE

        mov ax,dx
        ConvertirString resultadosTmp
        print resultadosTmp

        jmp CONSOLA
    
    NOEXISTE:
        print noexisteMsj
        jmp CONSOLA
    
    REPORTEFINAL:
        print repGenerado
        generarReporte
        jmp CONSOLA
    
	SALIR:
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