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

juego macro pas,accio,errCm, errMv
    colocarAccion pas,accio,errCm
    ;print accio
    movimiento accio, errMV
endm

accionesDef macro acc
    mov acc[0],32
    mov acc[1],32
    mov acc[5],32
    mov acc[6],32
endm

colocarAccion macro paso,accion,errCmd
    local ERROR, CONTINUE, FIN, EXIT, FINEXIT, CMDS, SETARR, SETPOS, HAYCOMA, NOHAYCOMA, SET, SICOMA, HAYCOMA2, NOHAYCOMA2, SHOW, FINSHOW

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
            sub al,64
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
            sub ah,49
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
            ;cmp al,'h'
            ;je SHOW
            ;cmp al,'a'
            ;je SAVE
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


        FINEXIT:
            mov al,1111b
            mov accion[7],al
            jmp FIN

        FINSHOW:
            mov al,1101b
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
    
endm