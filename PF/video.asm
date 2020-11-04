PintarMargen macro color
    local Primera, Segunda, Tercera, Cuarta

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

endm

mostrarTextoVideo macro numTam, fila, columna, cadena

    push ax
    push bx
    push cx
    push dx
    push si
    push di

    push ds
    pop es

    mov ah,13h
    mov al,0
    mov bh,0
    mov bl,0
    mov cx,numTam
    mov dh,fila
    mov dl,columna
    lea bx,cadena
    mov bp,bx
    int 10h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

endm
;============================= GRAFICA DE BARRAS ==============================================
mostrarGrafica macro arreglo,vel
    local INICIO, FIN

    push ax
    push bx
    push cx
    push dx
    push si
    push di 

    getTamanoWord arreglo
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
        mov dx,arreglo[si]
        ;mov dx,23
        mul dx      ;160 * X

        mov bx,variable
        div bx

        mov bx,ax       ;160*X dividido el mas grande
        mov dx,barrasGrafica[si]
        mov si,tamano
        dirModoVideo
        ;PintarBarra si,di,bx,dx
        PintarBarra dx,di,29,bx
        dirModoTexto
        ;pintarNumeros arreglo
        delay vel
        add di,29
        ;mov ax,si
        ;ConvertirString auxWord
        ;print auxWord
        ;getChar

        pop si
        inc si
        inc si
        jmp INICIO

    FIN:
        ;pintarNumeros arreglo
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax

endm

PintarBarra macro color,inicio, tam, altura
	local BARRA, FIN, INICION
	push di
	push si
	push bx
	push dx 
    push cx
    push ax

	mov ax,color
	mov dx,tam 
	sub dx,3; ancho de la barra
	mov si,inicio

	mov cx,altura

	;fila i, columna j = (i,j) = 320 * i + j

	;empieza en pixel (i,j) = (185,10) = 320 * 185 + 10 = 59210
	INICION:
		cmp cx,0
		jle FIN 

		mov di,si ;este es el inicio

		mov bx,si
		add bx,dx ;BX fin horizontalmente

		BARRA:
			mov [di],ax
			inc di
			cmp di,bx
			jne BARRA
		
		sub si,320
		dec cx
		jmp INICION

	FIN:
        pop ax
        pop cx
		pop dx
		pop bx
		pop si
		pop di

endm

pintarNumeros macro arreglo
    local INICIO, FIN

    push si
    push cx
    push di
    push dx

    xor dx,dx
    xor si,si
    getTamanoWord arreglo
    mov di,cx
    mov dl,2

    INICIO:
        cmp si,di
        jge FIN

        cleanArr arregloAux2
        mov ax,arreglo[si]
        ConvertirStringByte arregloAux2
        tamanoArr arregloAux2
        unirNumeros 
        add dl,2


        inc si
        inc si
        jmp INICIO

    FIN:
        mostrarTextoVideo 37,22,2,arregloAux
        pop dx
        pop di
        pop cx
        pop si
endm

;============================= REPORTE DE TOP 10 PUNTOS =======================================
t10Puntos macro
    local INICIO, BUBBLEPICK, QUICKPICK, SHELLPICK, VERSPEED, ASCODESC, ASCPICK, DESCPICK, ERRORSPEED, GRAFICAR, FIN
    ;mostrarGrafica
    INICIO:
        print opc1
        getChar
        cmp al,'1'
        je BUBBLEPICK
        cmp al,'2'
        je  QUICKPICK
        cmp al,'3'
        je SHELLPICK

    jmp INICIO


    ERRORSPEED:
        print contraNumerica
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
        print opc2
        getChar
        cmp al,'0'
        jl ERRORSPEED
        cmp al,'9'
        jg ERRORSPEED

        xor bx,bx
        mov bl,al
        mov encabGrafica[36],bl
        sub bl,47
        mov ax,110
        mul bx
        mov speed,ax
    
    ASCODESC:
        print opc3
        getChar
        cmp al,'1'
        je ASCPICK
        cmp al,'2'
        je  DESCPICK

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
        lecturaPuntos
        ordenarBurbujaDecSinGraf punteos
        mov dx,punteos[0]
        mov variable,dx ;en variable esta el num mas grande

        cleanArr arregloAux
        cleanArrWord punteos
        cleanArrWord barrasGrafica
        lecturaPuntos
        ModoVideo
        PintarMargen 3
        dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica

        mostrarGrafica punteos,10
        pintarNumeros punteos 
        getKey

        dirModoTexto
        cmp encabGrafica[5],'B'
        je HACERBURBUJA
        cmp encabGrafica[5],'S'
        je HACERSHELL

        jmp FIN

    HACERSHELL:
        cmp encabGrafica[18],'A'
        je SHASC

        ;ordernarShellDesc punteos,speed
        jmp FIN
    
    SHASC:
        ;ordernarShellAsc punteos,speed
        jmp FIN

    HACERBURBUJA:
        cmp encabGrafica[18],'A'
        je BUASC

        ordenarBurbujaDec punteos,speed
        jmp FIN
    
    BUASC:
        ordenarBurbujaAsc punteos,speed
        jmp FIN

    FIN:
        ;pintarNumeros punteos
        getKey
        ModoTexto

        ordernarShellAsc punteos,speeds

endm

lecturaPuntos macro
    local LEER, FINLN, FIN, FIN2,PYC,INTERNA

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
            ;getChar
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

endm

;============================= ORDENAMIENTOS ======================================================
; ------------- BUBBLE SORT  ----------------------
ordenarBurbujaAsc macro arreglo,vel
    local INICIO, MAKESWAP, FIN, FIN2

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord arreglo
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,arreglo[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,arreglo[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jg MAKESWAP     ;if arr[x] > arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov arreglo[si],dx  ;mover arr[x] <- arr[x+1] 
        mov arreglo[di],bx  ;mover arr[x+1] <- arr[x]
        mov dx,barrasGrafica[si]
        mov bx,barrasGrafica[di]
        mov barrasGrafica[si],bx
        mov barrasGrafica[di],dx

        ;dirModoVideo
        ModoVideo
        PintarMargen 3

        dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica
        mostrarGrafica arreglo,vel
        dirModoTexto
        
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
endm

ordenarBurbujaDec macro arreglo, vel
    local INICIO, MAKESWAP, FIN, FIN2

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord arreglo
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,arreglo[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,arreglo[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jl MAKESWAP     ;if arr[x] < arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov arreglo[si],dx  ;mover arr[x] <- arr[x+1] 
        mov arreglo[di],bx  ;mover arr[x+1] <- arr[x]

        mov dx,barrasGrafica[si]
        mov bx,barrasGrafica[di]
        mov barrasGrafica[si],bx
        mov barrasGrafica[di],dx

        ;dirModoVideo
        ModoVideo
        PintarMargen 3

        dirModoTexto
        mostrarTextoVideo 37,1,2,encabGrafica
        mostrarGrafica arreglo,vel
        dirModoTexto
        
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
endm

ordenarBurbujaDecSinGraf macro arreglo
    local INICIO, MAKESWAP, FIN, FIN2

    mov [bandera],00b       ;variable para ver si hubo swap
    getTamanoWord arreglo
    
    dec cx
    dec cx

    xor si,si

    INICIO:
        cmp si,cx
        jge FIN

        ;mov [bandera],00b   ;no hubo swap
        mov bx,arreglo[si]  ;pos en el arr[x]
        mov di,si
        inc di
        inc di
        mov dx,arreglo[di]  ;pos en el arr[x+1]
        
        cmp bx,dx
        jl MAKESWAP     ;if arr[x] < arr[x+1] -> go to MAKESWAP

        inc si
        inc si
        jmp INICIO

    MAKESWAP:
        mov arreglo[si],dx  ;mover arr[x] <- arr[x+1] 
        mov arreglo[di],bx  ;mover arr[x+1] <- arr[x]
        
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
endm
; ------------- QUICK SORT -------------------------
ordenarQuickAsc macro arreglo
    local INICIO, QUICK, FIN, QUICK2, PARTITION

    xor bx,bx       ;low
    getTamanoWord arreglo
    
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
        mov dx,arreglo[si]

        ;mov 

        ret
    
    QUICK2:
        call PARTITION
        ; quick before PI
        ; quick after PI


    FIN:

endm

; ------------- SHELL SORT -------------------------
ordernarShellAsc macro arreglo, vel
    
    getTamanoWord arreglo
    mov ax,cx
    sar ax,1
    push ax
    mov di,ax ;di <- array.length

    cleanArrWord auxWord
    pop ax
    mov si,3d
    
    mov bx,(ax/si) ; bx <- array.length / 3
    mov ax,bx
    ConvertirString  auxWord
    print auxWord
    getChar
    
    mov dx,1 ;dx <- intervalo = 1
    
    INTERVALO:
        cmp dx,bx
        jl FIN

        mov ax,dx
        mov si,3
        div si
        add ax,1
        mov dx,ax


        mov ax,dx
        jmp INTERVALO
    
    FIN:
        mov ax,dx

endm