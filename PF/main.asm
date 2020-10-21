include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
nombrePadre db 72 dup('$')
arregloAux2 db 70 dup('$'),10,13
arregloAux db 70 dup('$'),10,13
usuarioActual db 70 dup('$'),10,13
ordenados word 100 dup(00h),'$'
variable word ?
auxWord word 34 dup('$'),10,13
resultadosTmp word 34 dup('$'),10,13
contrasenas word 100 dup(00h),'$'
usuarios word 100 dup(00h),'$'
punteos word 100 dup(00h),'$'
nombresIdentificadores db 3000 dup('$')
bufferLectura db 30000 dup('$')
bufferEscritura db 200 dup('$')
resultados db 1000 dup('$')
handleFichero dw ?
handle2 dw ?
handle dw ?
rutaAux db 'nuevo.arq',00h,00h
ruta2 db 'nuev2.arq',00h,00h
answers db 'users.rep',00h,00h
puntosRuta db 'puntos.rep',00h,00h
tiempoRuta db 'tiempo.rep',00h,00h

exit db 'EXIT','$'
noexisteMsj db 'La operaci',162,'n que ingresaste no existe','$'
repGenerado db 10,10,13,32,173,173,' Reporte Generado !!','$'
userAdmin db 'adminAI','$$'
contrAdmin db '4321','$$'


encab db 10,10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
enc db 10,10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A','$'
encab2 db 10,13,10,13,'1. Ingresar',10,13,'2. Registrar',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
opcAdmin db 10,13,10,13,'1. Top 10 Puntos',10,13,'2. Top 10 Tiempo',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
msjOpc1 db 10,10,13,9,'-----------------------  INGRESAR  -----------------------',10,13,'$'
msjOpc2 db 10,10,13,9,'-----------------------  REGISTRAR  -----------------------',10,13,'$'
msjOpc3 db 10,10,13,9,'-----------------------  ADIOS  -----------------------',10,13,'$'
msjOpc4 db 10,10,13,9,'-----------------------  TOP 10 PUNTOS  -----------------------',10,13,'$'
msjOpc5 db 10,10,13,9,'-----------------------  TOP 10 TIEMPO  -----------------------',10,13,'$'
msjOpc6 db 10,10,13,9,'-----------------------  INICIO JUEGO  -----------------------',10,13,'$'
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
ingreseUser db 10,13,'::Ingresa tu usuario  ','$'
welcome db 10,10,13,173,173,' Bienvenido ','$'
ennd db ' !!',10,13,'$'
ingreseCont db 10,13,'::Ingresa tu contrase',164,'a  ','$'
userNoValido db 10,13,32,173,173,' Usuario No Existe !!','$'
userRegistrado db 10,13,32,173,173,' Usuario Registrado !!',10,13,'$'
userNoValido2 db 10,13,32,173,173,' Usuario Ya Existe !!',10,13,'$'
contraNoValida db 10,13,32,173,173,' Contrase',164,'a Inv',160,'lida !!','$'
contraNumerica db 10,13,32,173,173,' Contrase',164,'a debe ser num',130,'rica !!','$'


saveSuccess db 10,13, ' ',173,173,' Archivo guardado con ',130,'xito !!','$'
loadSuccess db 10,13, ' ',173,173,' Archivo cargado con ',130,'xito !!','$'

.code	
	
main proc
    mov dx,@data
    mov ds,dx

	MenuPrincipal:
        cleanArr usuarioActual
		print encab
		print enc
		print encab2
		getChar
		cmp al,'1'
		je INGRESAR
		cmp al,'2'
		je REGISTRAR
		cmp al,'3'
		je SALIR
		jmp MenuPrincipal

	
	INGRESAR:
        cleanArr arregloAux
        ConvertirSumaAscii userAdmin
        colocarRespuesta usuarios
        ConvertirSumaAscii contrAdmin
        colocarRespuesta contrasenas
		print msjOpc1
        print ingreseUser
        ObtenerTexto arregloAux
        ConvertirSumaAscii arregloAux
        searchID
        push dx
        cmp dx,0
        je USERINVALIDO

        ;usuario valido
        pasarArr arregloAux,usuarioActual
        print welcome
        print arregloAux
        print ennd
        cleanArr arregloAux
        print ingreseCont
        ObtenerPwd arregloAux
        ConvertirSumaAscii arregloAux
        pop dx
        cmp dx,ax
        je VALIDOS

        print contraNoValida
        getChar
		jmp MenuPrincipal
    
    USERINVALIDO:
        print userNoValido
        getChar
        jmp MenuPrincipal
    
    VALIDOS:
        comparar usuarioActual,userAdmin
        cmp ah,0b
        je NORMALUSER

        print opcAdmin
        getChar
        cmp al,'1'
        je TOP10PUNTOS
        cmp al,'2'
        je TOP10TIEMPO
        
        jmp MenuPrincipal

    NORMALUSER:
        print msjOpc6
        jmp MenuPrincipal
    
    TOP10PUNTOS:
        print msjOpc4
        t10Puntos 
        jmp MenuPrincipal

    TOP10TIEMPO:
        print msjOpc5
        jmp MenuPrincipal
    
    REGISTRAR:
        print msjOpc2
        print ingreseUser
        cleanArr arregloAux
        ObtenerTexto arregloAux
        ConvertirSumaAscii arregloAux
        searchID
        push ax
        cmp dx,0
        jne YAEXISTE
        
        pop ax
        colocarRespuesta usuarios
    
    INGCONTRASE:
        print ingreseCont
        cleanArr arregloAux
        ObtenerPwd arregloAux
        cmp ch,00h
        je INVALISENA

        ConvertirSumaAscii arregloAux
        colocarRespuesta contrasenas
        print userRegistrado
        

        jmp MenuPrincipal

    INVALISENA:
        jmp INGCONTRASE

    YAEXISTE:
        print userNoValido2
        getChar
        jmp REGISTRAR
    
    
	SALIR:
		print msjOpc3
		mov ah,4ch
		int 21h
    	    
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