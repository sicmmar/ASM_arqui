PintarMargen macro color
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

;============================= REPORTE DE TOP 10 PUNTOS =======================================
t10Puntos macro
    lecturaPuntos
    ordenarBurbuja punteos
    ModoVideo
    PintarMargen 3

    getChar
    ModoTexto
endm

lecturaPuntos macro
    local LEER, FINLN, FIN, FIN2

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
ordenarBurbuja macro arreglo
    
endm