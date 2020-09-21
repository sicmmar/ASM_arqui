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

juego macro pas,accio,errCm
    colocarAccion pas,accio,errCm
    print accio
endm

colocarAccion macro paso,accion,errCmd
    local ERROR, CONTINUE, FIN, EXIT, FINEXIT, CMDS;, OTRO

    PUSH si
    PUSH ax

        xor ax,ax
        xor si,si
        CONTINUE:
            xor di,di
            mov al,paso[si]
            cmp al,0dh
            je FIN
            cmp al,'e'
            je EXIT
            cmp al,'s'
            je CMDS
            inc si
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
         
        CMDS:
            inc di
            mov al,paso[di]
            cmp al,'h'
            je SHOW
            cmp al,'a'
            je SAVE
            cmp al,'w'
            jne ERROR
            je FINEXIT

        FINEXIT:
            mov al,1111b
            mov accion[0],al
            jmp FIN
        
        ERROR:
            xor di,di
            print errCmd

        FIN:
            mov al,'$'
            mov accion[2],al

    POP ax
    POP si
endm