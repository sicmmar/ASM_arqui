include macros.asm

.model small ;declaracion del programa
.stack ;segmento de stack
.data ;segmento de datos
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
nombrePadre db 72 dup('$')
arregloAux2 db 200 dup('$')
arregloAux db 70 dup('$'),10,13
usuarioActual db 70 dup('$'),10,13
ordenados word 100 dup(00h),'$'
variable word ?
constante word ?
color byte ?
tamano word ?
auxWord word 34 dup('$'),10,13

contrasenas word 100 dup(00h),'$'
usuarios word 100 dup(00h),'$'
punteos word 100 dup(00h),'$'
barrasGrafica word 100 dup (00h),'$'
sonidos word 100 dup(00h),'$'

bufferLectura db 30000 dup('$')
bufferEscritura db 200 dup('$')
handleFichero dw ?
handle2 dw ?
handle dw ?
answers db 'users.rep',00h,00h
puntosRuta db 'puntos.rep',00h,00h
tiempoRuta db 'tiempo.rep',00h,00h

userAdmin db 'adminAI','$$'
contrAdmin db '4321','$$'


encab db 10,10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
enc db 10,10,13,'NOMBRE: ASUNCION MARIANA SIC SOR',10,13,'CARNET: 201504051',10,13,'SECCION: A','$'
encab2 db 10,13,10,13,'1. Ingresar',10,13,'2. Registrar',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
opcAdmin db 10,13,10,13,'1. Top 10 Puntos',10,13,'2. Top 10 Tiempo',10,13,'3. Salir',10,13,10,'::Escoja una opci',162,'n  ','$'
opc1 db 10,13,10,13,'1. Bubble Sort',10,13,'2. Quick Sort',10,13,'3. Shell Sort',10,13,10,'::Escoja un ordenamiento  ','$'
opc2 db 10,13,10,13,'::Ingrese una velocidad (0-9 ',175,' 0 ',25,32,38,' 9 ',24,')  ','$'
opc3 db 10,13,10,13,'1. Descendente',10,13,'2. Ascendente',10,13,10,'::Escoja una opci',162,'n para ordenar  ','$'
msjOpc1 db 10,10,13,9,'-----------------------  INGRESAR  -----------------------',10,13,'$'
msjOpc2 db 10,10,13,9,'-----------------------  REGISTRAR  -----------------------',10,13,'$'
msjOpc3 db 10,10,13,9,'-----------------------  ADIOS  -----------------------',10,13,'$'
msjOpc4 db 10,10,13,9,'-----------------------  TOP 10 PUNTOS  -----------------------',10,13,'$'
msjOpc5 db 10,10,13,9,'-----------------------  TOP 10 TIEMPO  -----------------------',10,13,'$'
msjOpc6 db 10,10,13,9,'-----------------------  INICIO JUEGO  -----------------------',10,13,'$'
saltoln db 10,13,'$'
encabGrafica db 'ORD:  ',32,'    TIPO:  ',32,32,'C    VELOCIDAD:  ' ; 5; 18 y 19; 36
speed word ?
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
contraNumerica db 10,13,32,173,173,' La entrada debe ser num',130,'rica !!','$'
numeroGG db '   '

saveSuccess db 10,13, ' ',173,173,' Archivo guardado con ',130,'xito !!','$'
loadSuccess db 10,13, ' ',173,173,' Archivo cargado con ',130,'xito !!','$'
bandera word 10 dup(00h)

.code	
	
main proc
    mov dx,@data
    mov ds,dx

	MenuPrincipal:
		lea dx, encab
        call print
	    lea dx, enc
        call print
		lea dx, encab2
        call print
		call getChar
		cmp al,'1'
		je INGRESAR
		cmp al,'2'
		je REGISTRAR
		cmp al,'3'
		je SALIR
		jmp MenuPrincipal

	
	INGRESAR:
        cleanArr usuarioActual
        cleanArr arregloAux
        ConvertirSumaAscii userAdmin
        colocarRespuesta usuarios
        ConvertirSumaAscii contrAdmin
        colocarRespuesta contrasenas
		lea dx, msjOpc1
        call print
        lea dx, ingreseUser
        call print
        ObtenerTexto arregloAux
        ConvertirSumaAscii arregloAux
        call searchID
        push dx
        cmp dx,0
        je USERINVALIDO

        ;usuario valido
        pasarArr arregloAux,usuarioActual
        lea dx, welcome
        call print
        lea dx, arregloAux
        call print
        lea dx, ennd
        call print
        cleanArr arregloAux
        lea dx, ingreseCont
        call print
        ObtenerPwd arregloAux
        ConvertirSumaAscii arregloAux
        pop dx
        cmp dx,ax
        je VALIDOS

        lea dx, contraNoValida
        call print
        cleanArr usuarioActual
        call getChar
		jmp MenuPrincipal
    
    USERINVALIDO:
        lea dx, userNoValido
        call print
        call getChar
        jmp MenuPrincipal
    
    VALIDOS:
        comparar usuarioActual,userAdmin
        cmp ah,0b
        je NORMALUSER

        lea dx, opcAdmin
        call print
        call getChar
        cmp al,'1'
        je TOP10PUNTOS
        cmp al,'2'
        je TOP10TIEMPO
        
        jmp MenuPrincipal

    NORMALUSER:
        lea dx, msjOpc6
        call print
        jmp VALIDOS
    
    TOP10PUNTOS:
        lea dx, msjOpc4
        call print

        call t10Puntos 
        jmp VALIDOS

    TOP10TIEMPO:
        lea dx, msjOpc5
        call print 
        jmp VALIDOS
    
    REGISTRAR:
        lea dx, msjOpc2
        call print
        lea dx, ingreseUser
        call print
        cleanArr arregloAux
        ObtenerTexto arregloAux
        ConvertirSumaAscii arregloAux
        call searchID
        push ax
        cmp dx,0
        jne YAEXISTE
        
        pop ax
        colocarRespuesta usuarios
    
    INGCONTRASE:
        lea dx, ingreseCont
        call print 
        cleanArr arregloAux
        ObtenerPwd arregloAux
        cmp ch,00h
        je INVALISENA

        ConvertirSumaAscii arregloAux
        colocarRespuesta contrasenas
        lea dx, userRegistrado
        call print
        

        jmp MenuPrincipal

    INVALISENA:
        jmp INGCONTRASE

    YAEXISTE:
        lea dx, userNoValido2
        call print
        call getChar
        jmp REGISTRAR
    
    
	SALIR:
		lea dx, msjOpc3
        call print
		mov ah,4ch
		int 21h
    	    
    ErrorAbrir:
		lea dx, msmError1
        call print
		call getChar
		jmp MenuPrincipal

	ErrorLeer:
		lea dx, msmError2
        call print
		call getChar
		jmp MenuPrincipal

	ErrorCrear:
		lea dx, msmError3
        call print
		call getChar
		jmp MenuPrincipal

	ErrorEscribir:
		lea dx, msmError4
        call print
		call getChar
		jmp MenuPrincipal

	ErrorCerrar:
		lea dx, msmError5
        call print
		call getChar
		jmp MenuPrincipal

main endp


DISP PROC
    MOV DL,BH      ; Since the values are in BX, BH Part
    ADD DL,30H     ; ASCII Adjustment

    MOV al,BL      ; BL Part 
    ADD al,30H     ; ASCII Adjustment
    RET
DISP ENDP      ; End Disp Procedure


searchID proc
    ;lo que devuelve el id, se coloca en dx
    ;local INICIO, NOENCONTRADO, ENCONTRADO, FIN
    push si
    push bx
    xor si,si

    INICIO:
        mov bx,usuarios[si]
        cmp bx,00h
        je NOENCONTRADO
        cmp bx,ax
        je ENCONTRADO

        inc si
        inc si
        jmp INICIO
    
    NOENCONTRADO:
        mov dx,0
        jmp FIN
    
    ENCONTRADO:
        mov dx,contrasenas[si]

    FIN:

    pop bx 
    pop si

    ret
searchID endp

lecturaPuntos proc

    mov handle,0000h
    abrirF puntosRuta, handle
    leerF sizeof bufferLectura, bufferLectura, handle
    push ax
    cerrarF handle

    pop ax
    mov bx,ax
    xor si,si
    xor di,di
    LEER:
        cmp si,bx
        jge FIN

        mov al,bufferLectura[si]
        mov arregloAux[di],al
        cmp al,'#'
        je FINLN

        inc di
        inc si
        jmp LEER

    FINLN:
        push si
        push bx
        mov bx,di
        xor si,si
        xor di,di

        INTERNA:
            cmp si,bx
            jge FIN2

            mov al,arregloAux[si]
            mov arregloAux2[di],al
            cmp al,';'
            je PYC
            
            inc di
            inc si
            jmp INTERNA

        PYC:
            xor di,di
            cleanArr arregloAux2
            inc si
            jmp INTERNA

        FIN2:
            ;print arregloAux2
            ;call getChar
            ConvertirAscii arregloAux2
            colocarRespuesta punteos
            colocarColores barrasGrafica
            cleanArr arregloAux2
            cleanArr arregloAux
            pop bx
            pop si
            inc si
            xor di,di
            jmp LEER

    FIN:
        ret
lecturaPuntos endp

getChar proc
    mov ah,01h
    int 21h

    ret
getChar endp

print proc
    mov ah,09h
    ;lea dx,cadena
    int 21h
    ret
print endp

unirNumeros proc

    push si
    push di
    push bx
    push cx

    xor di,di
    tamanoArr arregloAux ;donde esta TODO
    mov si,cx

    tamanoArr arregloAux2 ;donde esta un solo NUM

    INICIO:
        mov bh,arregloAux2[di]
        mov arregloAux[si],bh
        inc si
        inc di
        loop INICIO
    
    pop cx
    pop bx
    pop di
    pop si

    ret
unirNumeros endp

ModoVideo proc
    mov ah,00h
    mov al,13h
    int 10h
    call dirModoVideo

    ret
ModoVideo endp

dirModoVideo proc
    mov ax, 0A000h
    mov ds, ax  ; DS = A000h (memoria de graficos).
    ret
dirModoVideo endp

ModoTexto proc
    mov ah,00h
    mov al,03h
    int 10h
    call dirModoTexto
    ret
ModoTexto endp

dirModoTexto proc
    mov ax,@data
    mov ds,ax
    ret
dirModoTexto endp

delay proc
    push cx
	push dx
    push ax

	mov cx,constante
    mov dx,4240h
    mov ah,86h
    int 15h

	Fin:
        pop ax
		pop dx
		pop cx
    ret
delay endp

PintarMargen proc
    push di
    ;push dx
    mov dl, color

    ;formula es de 320 * i + j
    ;empieza en pixel (i,j) = (20,5) = 20*320+5 = 6405
    ;barra horizontal superior
    mov di,6405
    Primera:
        mov [di],dl
        inc di
        ;la barra termina cuando llegue a 304 -> entonces: 6405 + 304 + 5 (del margen izq) = 6714
        cmp di,6714
        jne Primera

    ;barra horizontal inferior
    ;empieza en pixel (i,j) = (190,5) = 190 * 320 + 5 = 60805
    mov di,60805
    Segunda:
        mov [di],dl
        inc di
        cmp di, 61114
        jne Segunda

    ;barra vertical izquierda
    mov di, 6405
    Tercera:
        mov [di], dl
        add di,320
        cmp di,60805
        jne Tercera

    ;barra vertical derecha
    mov di,6714
    Cuarta:
        mov [di], dl
        add di,320
        cmp di,61114
        jne Cuarta
    ;pop dx
    pop di
    ret
PintarMargen endp

t10Puntos proc
    ;mostrarGrafica
    INICIO:
        lea dx,opc1
        call print
        call getChar
        cmp al,'1'
        je BUBBLEPICK
        cmp al,'2'
        je  QUICKPICK
        cmp al,'3'
        je SHELLPICK

    jmp INICIO


    ERRORSPEED:
        lea dx,contraNumerica
        call print
        jmp INICIO

    BUBBLEPICK:
        mov encabGrafica[5],'B'

        jmp VERSPEED

    QUICKPICK:
        mov encabGrafica[5],'Q'
        jmp VERSPEED

    SHELLPICK:
        mov encabGrafica[5],'S'
    
    VERSPEED:
        lea dx,opc2
        call print
        call getChar
        cmp al,'0'
        jl ERRORSPEED
        cmp al,'9'
        jg ERRORSPEED

        xor bx,bx
        mov bl,al
        mov encabGrafica[36],bl
        sub bl,47
        mov ax,01h
        mul bx
        mov constante,ax
    
    ASCODESC:
        lea dx, opc3
        call print
        call getChar
        cmp al,'2'
        je ASCPICK
        cmp al,'1'
        je DESCPICK

    jmp INICIO

    ASCPICK:
        mov encabGrafica[18],'A'
        mov encabGrafica[19],'S'
        jmp GRAFICAR

    DESCPICK:
        mov encabGrafica[17],'D'
        mov encabGrafica[18],'E'
        mov encabGrafica[19],'S'
        jmp GRAFICAR

    GRAFICAR:   
        cleanArrWord barrasGrafica
        call lecturaPuntos
        call ordenarBurbujaDecSinGraf
        mov dx,punteos[0]
        mov variable,dx ;en variable esta el num mas grande

        cleanArr arregloAux
        cleanArrWord punteos
        cleanArrWord barrasGrafica
        call lecturaPuntos
        call ModoVideo
        mov color,3
        call PintarMargen
        call dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica
        push constante
        mov constante,00h
        call mostrarGrafica
        pop constante
        call pintarNumeros
        getKey

        call dirModoTexto
        cmp encabGrafica[5],'B'
        je HACERBURBUJA
        cmp encabGrafica[5],'S'
        je HACERSHELL

        jmp FIN

    HACERSHELL:
        cmp encabGrafica[18],'A'
        je SHASC

        call ordernarShellDec
        jmp FIN
    
    SHASC:
        call ordernarShellAsc
        jmp FIN

    HACERBURBUJA:
        cmp encabGrafica[18],'A'
        je BUASC

        call ordenarBurbujaDec
        jmp FIN
    
    BUASC:
        call ordenarBurbujaAsc
        jmp FIN

    FIN:
        call ModoVideo
        mov color,3
        call PintarMargen
        call dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica
        push constante
        mov constante,00h
        call mostrarGrafica
        pop constante
        call pintarNumeros


        getKey
        call ModoTexto

        ;call ordernarShellDec
    ret
t10Puntos endp

mostrarGrafica proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di 

    getTamanoWord punteos
    mov ax,cx
    sar ax,1
    mov bx,ax       ;en BX esta la cantidad de numeros guardados
    
    mov ax,299 ;;ancho de 299px
    div bx   
    mov tamano,ax       ;en tamano esta 'TAM'

    mov di,52817        ;en DI esta punto de partida

    xor si,si

    INICIO:

        cmp si,cx
        jge FIN
        
        push si

        mov ax,137      ;alto de 160px
        mov dx,punteos[si]
        ;mov dx,23
        mul dx      ;160 * X

        mov bx,variable
        div bx

        mov bx,ax       ;160*X dividido el mas grande
        mov dx,barrasGrafica[si]
        mov si,tamano
        call dirModoVideo
        ;PintarBarra si,di,bx,dx
        PintarBarra dx,di,29,bx
        call dirModoTexto
        ;pintarNumeros punteos
        call delay
        add di,29
        ;mov ax,si
        ;ConvertirString auxWord
        ;print auxWord
        ;call getChar

        pop si
        inc si
        inc si
        jmp INICIO

    FIN:
        ;pintarNumeros punteos
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    
    ret
mostrarGrafica endp

pintarNumeros proc

    push si
    push cx
    push di
    push dx

    xor dx,dx
    xor si,si
    getTamanoWord punteos
    mov di,cx
    mov dl,2

    INICIO:
        cmp si,di
        jge FIN

        cleanArr arregloAux2
        mov ax,punteos[si]
        ConvertirStringByte arregloAux2
        tamanoArr arregloAux2
        call unirNumeros 
        add dl,2


        inc si
        inc si
        jmp INICIO

    FIN:
        mostrarTextoVideo 37,22,2,arregloAux
        call dirModoTexto
        pop dx
        pop di
        pop cx
        pop si
        ret
pintarNumeros endp

;============================= ORDENAMIENTOS ======================================================
; ------------- BUBBLE SORT  ----------------------
ordenarBurbujaAsc proc

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord punteos
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,punteos[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,punteos[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jg MAKESWAP     ;if arr[x] > arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov punteos[si],dx  ;mover arr[x] <- arr[x+1] 
        mov punteos[di],bx  ;mover arr[x+1] <- arr[x]
        mov dx,barrasGrafica[si]
        mov bx,barrasGrafica[di]
        mov barrasGrafica[si],bx
        mov barrasGrafica[di],dx

        ;call dirModoVideo
        call ModoVideo
        mov color,3
        call PintarMargen

        call dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica

        call mostrarGrafica
        call dirModoTexto
        
        mov [bandera],01b   ;hubo swap

        inc si
        inc si
        jmp INICIO

    FIN:
        cmp [bandera],00b   ;no hubo swap
        je FIN2

        xor si,si
        mov [bandera],00b
        jmp INICIO
    
    FIN2:
        ret
ordenarBurbujaAsc endp

ordenarBurbujaDec proc

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord punteos
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,punteos[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,punteos[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jl MAKESWAP     ;if arr[x] < arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov punteos[si],dx  ;mover arr[x] <- arr[x+1] 
        mov punteos[di],bx  ;mover arr[x+1] <- arr[x]

        mov dx,barrasGrafica[si]
        mov bx,barrasGrafica[di]
        mov barrasGrafica[si],bx
        mov barrasGrafica[di],dx

        ;call dirModoVideo
        call ModoVideo
        mov color,3
        call PintarMargen

        call dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica
        call mostrarGrafica
        ;pintarNumeros
        call dirModoTexto
        
        mov [bandera],01b   ;hubo swap

        inc si
        inc si
        jmp INICIO

    FIN:
        cmp [bandera],00b   ;no hubo swap
        je FIN2

        xor si,si
        mov [bandera],00b
        jmp INICIO
    
    FIN2:
        ret
ordenarBurbujaDec endp

ordenarBurbujaDecSinGraf proc

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord punteos
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,punteos[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,punteos[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jl MAKESWAP     ;if arr[x] < arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov punteos[si],dx  ;mover arr[x] <- arr[x+1] 
        mov punteos[di],bx  ;mover arr[x+1] <- arr[x]
        
        mov [bandera],01b   ;hubo swap

        inc si
        inc si
        jmp INICIO

    FIN:
        cmp [bandera],00b   ;no hubo swap
        je FIN2

        xor si,si
        mov [bandera],00b
        jmp INICIO
    
    FIN2:
        ret
ordenarBurbujaDecSinGraf endp

; ------------- QUICK SORT -------------------------
ordenarQuickAsc proc

    xor bx,bx       ;low
    getTamanoWord punteos
    
    dec cx
    dec cx          ;high

    INICIO:
        call QUICK
        jmp FIN
    
    QUICK:
        cmp bx,cx
        jl QUICK2   ;if low < high then QUICK2

        ret
    
    PARTITION:
        mov si,cx   ;si es ahora high
        mov dx,punteos[si]

        ;mov 

        ret
    
    QUICK2:
        call PARTITION
        ; quick before PI
        ; quick after PI


    FIN:
        ret
ordenarQuickAsc endp

; ------------- SHELL SORT -------------------------
ordernarShellAsc proc
    getTamanoWord punteos
    sar cx,1;no usar CX <- es la cant. de veces que necesita recorrer el array
    mov bx,cx ;bx <- array.length

    cleanArrWord auxWord
    sar bx,1 ;bx <- gap inicial (n/2)
    
    PRIMERFOR:
        cmp bx,0 
        jle FIN ;salir solo si gap <= 0

        mov si,bx ;i (reg. si) = gap
        
        SEGUNDOFOR:
            cmp si,cx
            jge FINPRIMERFOR

            sal si,1
            mov dx,barrasGrafica[si]
            push dx
            mov dx,punteos[si] ;temp -> dx
            sar si,1

            mov di,si ;j (reg. di) = i (reg.si)

            TERCERFOR:
                cmp di,bx
                jl FINSEGUNDOFOR

                sub di,bx
                sal di,1
                cmp punteos[di],dx
                jle ETIQAUX

                push dx

                mov dx,punteos[di]

                push dx
                mov dx,barrasGrafica[di]

                sar di,1
                add di,bx

                sal di,1

                mov barrasGrafica[di],dx
                pop dx
                mov punteos[di],dx

    
                sar di,1

                call ModoVideo
                mov color,3
                call PintarMargen

                call dirModoTexto
                mostrarTextoVideo 37,1,2,encabGrafica

                call mostrarGrafica
                call dirModoTexto

                pop dx
                                
                sub di,bx ;j = j - gap
                jmp TERCERFOR

            ETIQAUX:
                sar di,1
                add di,bx

            FINSEGUNDOFOR:
                ;add di,bx
                sal di,1
                mov punteos[di],dx
                pop dx
                mov barrasGrafica[di],dx
                sar di,1

                call ModoVideo
                mov color,3
                call PintarMargen

                call dirModoTexto
                mostrarTextoVideo 37,1,2,encabGrafica

                call mostrarGrafica
                call dirModoTexto

                inc si
                jmp SEGUNDOFOR
        
        FINPRIMERFOR:
            sar bx,1 ;reducir -> gap = gap / 2
            jmp PRIMERFOR

    FIN:
        ret
ordernarShellAsc endp

ordernarShellDec proc
    getTamanoWord punteos
    sar cx,1;no usar CX <- es la cant. de veces que necesita recorrer el array
    mov bx,cx ;bx <- array.length

    cleanArrWord auxWord
    sar bx,1 ;bx <- gap inicial (n/2)
    
    PRIMERFOR:
        cmp bx,0 
        jle FIN ;salir solo si gap <= 0

        mov si,bx ;i (reg. si) = gap
        
        SEGUNDOFOR:
            cmp si,cx
            jge FINPRIMERFOR

            sal si,1
            mov dx,barrasGrafica[si]
            push dx
            mov dx,punteos[si] ;temp -> dx
            sar si,1

            mov di,si ;j (reg. di) = i (reg.si)

            TERCERFOR:
                cmp di,bx
                jl FINSEGUNDOFOR

                sub di,bx
                sal di,1
                cmp punteos[di],dx
                jge ETIQAUX

                push dx

                mov dx,punteos[di]

                push dx
                mov dx,barrasGrafica[di]

                sar di,1
                add di,bx

                sal di,1

                mov barrasGrafica[di],dx
                pop dx
                mov punteos[di],dx

    
                sar di,1

                call ModoVideo
                mov color,3
                call PintarMargen

                call dirModoTexto
                mostrarTextoVideo 37,1,2,encabGrafica

                call mostrarGrafica
                call dirModoTexto

                pop dx
                                
                sub di,bx ;j = j - gap
                jmp TERCERFOR

            ETIQAUX:
                sar di,1
                add di,bx

            FINSEGUNDOFOR:
                ;add di,bx
                sal di,1
                mov punteos[di],dx
                pop dx
                mov barrasGrafica[di],dx
                sar di,1

                call ModoVideo
                mov color,3
                call PintarMargen

                call dirModoTexto
                mostrarTextoVideo 37,1,2,encabGrafica

                call mostrarGrafica
                call dirModoTexto

                inc si
                jmp SEGUNDOFOR
        
        FINPRIMERFOR:
            sar bx,1 ;reducir -> gap = gap / 2
            jmp PRIMERFOR

    FIN:
        ret
ordernarShellDec endp

end