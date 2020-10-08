;operacionFinal macro
    local INICIO, FIN, ESCR, BUSCARID, IN2, FIN2, VOLTEAR
    xor bx,bx

    mov handle,00h
    abrirF rutaAux,handle
    leerF sizeof bufferLectura,bufferLectura,handle
    xor dx,dx
    mov bl,72
    div bl
    mov cx,ax
    cerrarF handle
    mov handle,00h

    abrirF rutaAux,handle

    INICIO:
        cmp bx,cx
        jge FIN
        ;darle la vuelta para operar
        leerF sizeof arregloAux, arregloAux, handle
        print arregloAux
        getChar

        cmp arregloAux[1],'+'
        je ESCR
        cmp arregloAux[1],'-'
        je ESCR
        cmp arregloAux[1],'*'
        je ESCR
        cmp arregloAux[1],'/'
        je ESCR
        cmp arregloAux[0],'!'
        je BUSCARID

        
        ConvertirAscii arregloAux
        mov dx,ax
        push dx
        inc bx
        jmp INICIO

    ESCR:
        xor dx,dx
        mov dl,arregloAux[1]
        push dx
        inc bx
        jmp INICIO

    BUSCARID:
        xor dx,dx
        mov dl,arregloAux[0]
        push dx
        inc bx
        jmp INICIO

    FIN:
        getChar
        cerrarF handle
        mov handle,00h

        cleanArr arregloAux
        mov ax,bx
        ConvertirString arregloAux
        print arregloAux
        getChar
        jmp FIN2
        crearF rutaAux,handle
        abrirF rutaAux,handle
        xor si,si
        jmp IN2

    IN2:
        cmp si,di
        jge FIN2

        cleanArr arregloAux
        xor dx,dx
        pop dx
        mov variable,dx
        print variable
        print saltoln
        print saltoln
        getChar
        
        cmp dl,'+'
        je VOLTEAR
        cmp dl,'-'
        je VOLTEAR
        cmp dl,'*'
        je VOLTEAR
        cmp dl,'/'
        je VOLTEAR
        cmp dl,'!'
        je VOLTEAR
        
        ConvertirString arregloAux
        escribirF handle,sizeof arregloAux, arregloAux
        inc di
        jmp IN2

    VOLTEAR:
        mov arregloAux[0],dl
        print shMayor
        print saltoln
        print arregloAux
        getChar
        escribirF handle, sizeof arregloAux, arregloAux
        inc di
        jmp IN2

    FIN2:
        cerrarF handle
        mov handle,00h
        print enc
        getChar
        pop di
        pop si
endm