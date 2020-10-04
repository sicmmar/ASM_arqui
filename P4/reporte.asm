; FECHA Y HORA
escribirFecha macro handle, fecha, hora
    ;;;;;;;;;; FECHA
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DL     ; Day is in DL
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[23],dl
    mov fecha[24],al

    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DH     ; Month is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[26],dl
    mov fecha[27],al

    MOV AH,2AH    ; To get System Date
    INT 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[31],dl
    mov fecha[32],al

    escribirF handle, sizeof fecha, fecha

    ;;;;;;; HORA
    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CH     ; Hour is in CH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[26],dl
    mov hora[27],al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CL     ; Minutes is in CL
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[29],dl
    mov hora[30],al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,DH     ; Seconds is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[32],dl
    mov hora[33],al
endm

;;;;;;;;;; ARCHIVO EXTENSION .ARQ
guardarArq macro posicion
    local FIRST, LAST
    xor si,si
    xor di,di
    mov cx,8
    FIRST:
        mov al,posicion[si]
        mov filaArch[di],al
        inc si
        inc di
        inc di
        loop FIRST
    
    escribirF handle2, sizeof filaArch, filaArch

    xor di,di
    mov cx,8
    LAST:
        mov filaArch[di],32
        inc di
        inc di
        loop LAST

endm

cargaFichero macro posicion
    local LAST, FIRST

    xor di,di
    mov cx,8
    LAST:
        mov filaArch[di],32
        inc di
        inc di
        loop LAST

    leerF sizeof filaArch, filaArch, handle2

    xor si,si
    xor di,di
    mov cx,8
    FIRST:
        mov al,filaArch[di]
        mov posicion[si],al
        inc si
        inc di
        inc di
        loop FIRST

endm

; =============== LEER JSON ====================
calcularJson macro archivo
    local LEER, STRING, FIN, QUIZANUM, FIJONUM, NOESNUM
    ;resultados es el arr res
    xor si,si
    
    LEER:
        cmp si,di
        jge FIN
        cmp archivo[si],'"'
        je STRING
        cmp archivo[si],'-'
        je NEGATIVO
        cmp archivo[si],48
        jge QUIZANUM
        inc si
        jmp LEER

    NEGATIVO:
        cleanArr arregloAux
        push di
        xor di,di
        mov arregloAux[di],'-'
        inc di
        inc si
        guardarNumero archivo
        escribirF handle2,sizeof arregloAux, arregloAux
        jmp LEER
    
    QUIZANUM:
        cmp archivo[si],57
        jle FIJONUM
        jmp NOESNUM
    
    FIJONUM:
        cleanArr arregloAux
        push di
        xor di,di
        guardarNumero archivo
        escribirF handle2,sizeof arregloAux, arregloAux
        jmp LEER

    NOESNUM:
        inc si
        jmp LEER
    
    STRING:
        inc si
        cleanArr arregloAux
        obtenerEntreComilla archivo
        escribirF handle2,sizeof arregloAux, arregloAux
        jmp LEER
    
    FIN:
        ;fin de la lectura del archivo
endm

guardarNumero macro archivo
    local INICIO, QUIZANUM, FIJONUM, FIN
    push ax
    ;xor ax,ax
    INICIO:
        cmp archivo[si],48
        jge QUIZANUM
        jmp FIN

    QUIZANUM:
        cmp archivo[si],57
        jle FIJONUM
        jmp FIN

    FIJONUM:
        mov al,archivo[si]
        mov arregloAux[di],al
        inc si
        inc di
        jmp INICIO

    FIN:
        pop ax
        pop di
endm

obtenerEntreComilla macro archivo
    local INICIO, FIN, FIJOMAYUS, NOESMAYUS, QUIZAMAYUS

    push di
    push ax
    xor ax,ax
    xor di,di
    mov arregloAux[0],32
    inc di

    INICIO:
        cmp archivo[si],'"'
        je FIN
        cmp archivo[si],65
        jge QUIZAMAYUS
        mov al,archivo[si]
        mov arregloAux[di],al
        inc si
        inc di
        jmp INICIO

    QUIZAMAYUS:
        cmp archivo[si],90
        jle FIJOMAYUS
        jmp NOESMAYUS
    
    FIJOMAYUS:
        mov al,archivo[si]
        add al,32 ;para que sea minuscula
        mov arregloAux[di],al
        inc di
        inc si
        jmp INICIO
    
    NOESMAYUS:
        mov al,archivo[si]
        mov arregloAux[di],al
        inc di
        inc si
        jmp INICIO

    FIN:
        inc si
        pop ax
        pop di
endm

analisis2 macro
    local INICIO, FIN, ESID, NUMERALITO
    
    xor di,di

    INICIO:
        cmp di,si
        jge FIN

        leerF sizeof arregloAux, arregloAux, handle2

        tamanoArr numeral
        comparar arregloAux,numeral
        cmp ah,1b
        je NUMERALITO

        tamanoArr idRes
        comparar arregloAux,idRes
        cmp ah,1b
        je ESID

        escribirF handleFichero,sizeof arregloAux,arregloAux
        inc di
        jmp INICIO

    NUMERALITO:
        inc di
        jmp INICIO
    
    ESID:
        leerF sizeof arregloAux, arregloAux, handle2
        inc di
        mov arregloAux[0],'!'
        escribirF handleFichero,sizeof arregloAux,arregloAux
        inc di
        jmp INICIO


    FIN:
endm