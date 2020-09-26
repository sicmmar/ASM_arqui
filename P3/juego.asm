include html.asm

sigTurno macro
    local SIGTURNO, TURNOBLANCA, TURNONEGRA, SWBN, SWNB, FIN

        SIGTURNO:
            cmp comando[2],1b
            je TURNOBLANCA
            cmp comando[2],0b
            je TURNONEGRA

        
        TURNOBLANCA:
            cmp comando[3],1b
            je SWBN
            print msjTBlancas
            jmp FIN

        SWBN:
            mov comando[2],0b
            mov comando[3],0b
            jmp SIGTURNO
        
        TURNONEGRA:
            cmp comando[3],1b
            je SWNB
            print msjTNegras
            jmp FIN

        SWNB:
            mov comando[2],1b
            mov comando[3],0b
            jmp SIGTURNO

        FIN:
            ObtenerTexto arregloAux

endm

accionesDef macro acc
    mov acc[0],32
    mov acc[1],32
    mov acc[5],32
    mov acc[6],32
endm

colocarAccion macro paso,accion,errCmd
    local ERROR, CONTINUE, FIN, EXIT, FINEXIT, CMDS, SETARR, SETPOS, HAYCOMA, NOHAYCOMA, SET, SICOMA, HAYCOMA2, NOHAYCOMA2, SHOW, FINSHOW, SAVE, FINSAVE

        xor ax,ax
        xor si,si
        xor di,di
        CONTINUE:
            mov al,paso[si]
            cmp al,0dh
            je FIN
            cmp al,'e'
            je EXIT
            cmp al,'s'
            je CMDS
            cmp al,'A'
            je SETARR
            cmp al,'B'
            je SETARR
            cmp al,'C'
            je SETARR
            cmp al,'D'
            je SETARR
            cmp al,'E'
            je SETARR
            cmp al,'F'
            je SETARR
            cmp al,'G'
            je SETARR
            cmp al,'H'
            je SETARR
            jne ERROR
            inc si
            jmp CONTINUE

        SETARR:
            sub al,65
            cmp accion[4],1b
            je HAYCOMA
            cmp accion[4],0b
            je NOHAYCOMA
        
        SET:
            inc di
            mov ah,paso[di]
            cmp ah,'1'
            je SETPOS
            cmp ah,'2'
            je SETPOS
            cmp ah,'3'
            je SETPOS
            cmp ah,'4'
            je SETPOS
            cmp ah,'5'
            je SETPOS
            cmp ah,'6'
            je SETPOS
            cmp ah,'7'
            je SETPOS
            cmp ah,'8'
            je SETPOS
            jne ERROR
        
        HAYCOMA:
            mov accion[1],al
            jmp SET

        NOHAYCOMA:
            mov accion[0],al
            jmp SET

        SETPOS:
            sub ah,48
            cmp accion[4],1b
            je HAYCOMA2
            cmp accion[4],0b
            je NOHAYCOMA2
        
        POS:
            inc di
            cmp paso[di],','
            je SICOMA
            jne FIN

        HAYCOMA2:
            mov accion[6],ah
            jmp POS

        NOHAYCOMA2:
            mov accion[5],ah
            jmp POS
        

        SICOMA:
            mov accion[4],1b 
            inc di
            mov si,di
            jmp CONTINUE


        EXIT:
            inc di
            mov al,paso[di]
            cmp al,'x'
            je EXIT
            cmp al,'i'
            je EXIT
            cmp al,'t'
            jne ERROR
            je FINEXIT
            jmp FIN
         
        CMDS:
            inc di
            mov al,paso[di]
            cmp al,'a'
            je SAVE
            cmp al,'h'
            je SHOW
            jne ERROR
            je FINEXIT

        SHOW:
            inc di
            cmp paso[di],'o'
            je SHOW
            cmp paso[di],'w'
            je FINSHOW
            jne ERROR
            jmp FIN

        SAVE:
            inc di
            cmp paso[di],'v'
            je SAVE
            cmp paso[di],'e'
            je FINSAVE
            jne ERROR
            jmp FIN


        FINEXIT:
            mov al,1111b
            mov accion[7],al
            jmp FIN

        FINSHOW:
            mov al,1101b
            mov accion[7],al
            jmp FIN

        FINSAVE:
            mov al,1110b
            mov accion[7],al
            jmp FIN
        
        ERROR:
            xor di,di
            print errCmd

        FIN:
            mov al,'$'
            mov accion[8],al

endm

movimiento macro accion, errMV
    local FIN, ERROR, HAYCOMA, ERRORTURNO, MOVERFICHA, REFRESH;, NOHAYCOMA
    

    mov comando[7],00b
    cmp accion[0],0
    jl ERROR
    cmp accion[0],8
    jge ERROR
    cmp accion[5],0
    jle ERROR
    cmp accion[5],8
    jg ERROR

    cmp accion[4],1b
    je HAYCOMA
    ;cmp accion[4],0b
    ;je NOHAYCOMA

    HAYCOMA:
        mov cx,1
        mov dx,6
        cmp accion[1],0
        jl ERROR
        cmp accion[1],8
        jge ERROR
        cmp accion[6],0
        jle ERROR
        cmp accion[6],8
        jg ERROR
        
        leerFichaActual 
        cmp ah,100b
        je MOVERFICHA
        cmp ah,10b
        je MOVERFICHA
        cmp ah,00b
        je MOVERFICHA
        jne ERRORTURNO
        jmp FIN

    MOVERFICHA:
        leerDestino
        cmp comando[7],1100b
        jne REFRESH
        jmp FIN

    ERROR:
        print errMV
        jmp FIN

    REFRESH:
        actualizarMovimiento
        jmp FIN

    ERRORTURNO:
        print errorTurno 

    FIN:
        getChar
endm

leerFichaActual macro 
    local ENPOS1, ENPOS2, ENPOS3, ENPOS4, ENPOS5, ENPOS6, ENPOS7, ENPOS8, TURNOCORRECTO
    
    xor bx,bx
    mov bl,comando[0] ;LETRA -> posNUMERO[LETRA]
    mov si,bx
    mov bl,comando[5] ;NUMERO -> posNUMERO
    
    push bx ; numero de arreglo a modificar
    cmp bl,1
    je ENPOS1
    cmp bl,2
    je ENPOS2
    cmp bl,3
    je ENPOS3
    cmp bl,4
    je ENPOS4
    cmp bl,5
    je ENPOS5
    cmp bl,6
    je ENPOS6
    cmp bl,7
    je ENPOS7
    cmp bl,8
    je ENPOS8

    ENPOS1:
        mov al,pos1[si]
        jmp TURNOCORRECTO

    ENPOS2:
        mov al,pos2[si]
        jmp TURNOCORRECTO

    ENPOS3:
        mov al,pos3[si]
        jmp TURNOCORRECTO

    ENPOS4:
        mov al,pos4[si]
        jmp TURNOCORRECTO

    ENPOS5:
        mov al,pos5[si]
        jmp TURNOCORRECTO

    ENPOS6:
        mov al,pos6[si]
        jmp TURNOCORRECTO

    ENPOS7:
        mov al,pos7[si]
        jmp TURNOCORRECTO

    ENPOS8:
        mov al,pos8[si]
        jmp TURNOCORRECTO

    TURNOCORRECTO:
        push si ;posicion en el arreglo
        xor ah,ah
        push ax
        mov ah,comando[2]
        add ah,al
endm

leerDestino macro
    local IMPAR, PAR, MOVALIDO, ENPOS1, ENPOS2, ENPOS3, ENPOS4, ENPOS5, ENPOS6, ENPOS7, ENPOS8, ERROR, FIN

    mov si,cx
    mov di,dx

    xor bx,bx
    mov bl,comando[si] ;LETRA -> posNUMERO[LETRA]
    mov si,bx
    mov bl,comando[di] ;NUMERO -> posNUMERO

    cmp bl,1
    je IMPAR
    cmp bl,2
    je PAR
    cmp bl,3
    je IMPAR
    cmp bl,4
    je PAR
    cmp bl,5
    je IMPAR
    cmp bl,6
    je PAR
    cmp bl,7
    je IMPAR
    cmp bl,8
    je PAR
    
    IMPAR:
        cmp si,0
        je MOVALIDO
        cmp si,2
        je MOVALIDO
        cmp si,4
        je MOVALIDO
        cmp si,6
        je MOVALIDO

    PAR:
        cmp si,1
        je MOVALIDO
        cmp si,3
        je MOVALIDO
        cmp si,5
        je MOVALIDO
        cmp si,7
        je MOVALIDO

    MOVALIDO:
        cmp bl,1
        je ENPOS1
        cmp bl,2
        je ENPOS2
        cmp bl,3
        je ENPOS3
        cmp bl,4
        je ENPOS4
        cmp bl,5
        je ENPOS5
        cmp bl,6
        je ENPOS6
        cmp bl,7
        je ENPOS7
        cmp bl,8
        je ENPOS8

    ENPOS1:
        mov al,pos1[si]
        jmp TURNOCORRECTO

    ENPOS2:
        mov al,pos2[si]
        jmp TURNOCORRECTO

    ENPOS3:
        mov al,pos3[si]
        jmp TURNOCORRECTO

    ENPOS4:
        mov al,pos4[si]
        jmp TURNOCORRECTO

    ENPOS5:
        mov al,pos5[si]
        jmp TURNOCORRECTO

    ENPOS6:
        mov al,pos6[si]
        jmp TURNOCORRECTO

    ENPOS7:
        mov al,pos7[si]
        jmp TURNOCORRECTO

    ENPOS8:
        mov al,pos8[si]
        jmp TURNOCORRECTO

    TURNOCORRECTO:
        cmp al,32
        jne ERROR
        je FIN

    ERROR:
        print errorBlanco
        mov comando[7],1100b
        jmp FIN

    FIN:
        ;getChar
        
endm

actualizarMovimiento macro
    local ENPOS1, ENPOS2, ENPOS3, ENPOS4, ENPOS5, ENPOS6, ENPOS7, ENPOS8, TURNOCORRECTO, INICIO, BORRARANTERIOR, FIN
    pop ax
    xor di,di

    INICIO:
        cmp bl,1
        je ENPOS1
        cmp bl,2
        je ENPOS2
        cmp bl,3
        je ENPOS3
        cmp bl,4
        je ENPOS4
        cmp bl,5
        je ENPOS5
        cmp bl,6
        je ENPOS6
        cmp bl,7
        je ENPOS7
        cmp bl,8
        je ENPOS8

    ENPOS1:
        mov pos1[si],al
        jmp TURNOCORRECTO

    ENPOS2:
        mov pos2[si],al
        jmp TURNOCORRECTO

    ENPOS3:
        mov pos3[si],al
        jmp TURNOCORRECTO

    ENPOS4:
        mov pos4[si],al
        jmp TURNOCORRECTO

    ENPOS5:
        mov pos5[si],al
        jmp TURNOCORRECTO

    ENPOS6:
        mov pos6[si],al
        jmp TURNOCORRECTO

    ENPOS7:
        mov pos7[si],al
        jmp TURNOCORRECTO

    ENPOS8:
        mov pos8[si],al
        jmp TURNOCORRECTO

    TURNOCORRECTO:
        cmp di,0
        je BORRARANTERIOR
        cmp di,1
        je FIN
        

    BORRARANTERIOR:
        pop si
        pop bx
        mov al,32
        inc di
        jmp INICIO
    
    FIN:
        mov comando[3],1b
        mov comando[7],0000b 

endm