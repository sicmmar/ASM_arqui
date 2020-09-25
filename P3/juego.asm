include html.asm

sigTurno macro com,msB,msN,arr
    local SIGTURNO, TURNOBLANCA, TURNONEGRA, SWBN, SWNB

        SIGTURNO:
            cmp com[2],1b
            je TURNOBLANCA
            cmp com[2],0b
            je TURNONEGRA

        
        TURNOBLANCA:
            print msB
            cmp com[3],1b
            je SWBN
            jmp FIN

        SWBN:
            mov com[2],0b
            mov com[3],0b
        
        TURNONEGRA:
            print msN
            cmp com[3],1b
            je SWNB
            jmp FIN

        SWNB:
            mov com[2],1b
            mov com[3],0b

        FIN:
            ObtenerTexto arr

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
    local FIN, ERROR, HAYCOMA, ERRORTURNO, MOVERFICHA;, NOHAYCOMA
    
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
        jmp FIN

    ERROR:
        print errMV
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
        mov ah,comando[2]
        add ah,al
endm

leerDestino macro
    
endm