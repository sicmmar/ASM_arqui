juego macro pas,accio,errCm
    colocarAccion pas,accio,errCm
    print accio
endm

colocarAccion macro paso,accion,errCmd
    local ERROR, CONTINUE, FIN, EXIT, FINEXIT;, CMDS, OTRO

    PUSH si
    PUSH ax

        xor si,si
        xor di,di
        xor ax,ax
        CONTINUE:
            mov al,paso[si]
            cmp al,0dh
            je FIN
            cmp al,'e'
            je EXIT
            ;cmp al,'s'
            ;je CMDS
            ;jmp OTRO

        EXIT:
            inc si
            inc di
            mov al,paso[si]
            cmp al,'x'
            je EXIT
            cmp al,'i'
            je EXIT
            cmp al,'t'
            jne ERROR
            je FINEXIT
            jmp FIN

        FINEXIT:
            mov al,1111b
            mov accion[0],al
            ;ret
        
        ERROR:
            xor di,di
            print errCmd

        FIN:
            mov al,'$'
            mov accion[2],al

    POP ax
    POP si
endm