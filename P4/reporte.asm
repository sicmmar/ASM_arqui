
; FECHA Y HORA
escribirFecha macro
    ;;;;;;;;;; FECHA
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DL     ; Day is in DL
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[0],dl
    mov fecha[1],al

    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DH     ; Month is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[14],dl
    mov fecha[15],al

    MOV AH,2AH    ; To get System Date
    INT 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[30],dl
    mov fecha[31],al

    escribirF handle, sizeof fecha, fecha

    ;;;;;;; HORA
    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CH     ; Hour is in CH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[0],dl
    mov hora[1],al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CL     ; Minutes is in CL
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[18],dl
    mov hora[19],al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,DH     ; Seconds is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[37],dl
    mov hora[38],al

    escribirF handle, sizeof hora, hora
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
    local INICIO, FIN, ESID, NUMERALITO, MULTI, DIVIS, SUMA, RESTA
    
    xor di,di

    INICIO:
        cmp di,si
        jge FIN

        leerF sizeof arregloAux, arregloAux, handle2

        comparar arregloAux,numeral
        cmp ah,1b
        je NUMERALITO

        comparar arregloAux,idRes
        cmp ah,1b
        je ESID

        comparar arregloAux,addRes1
        cmp ah,1b
        je SUMA

        comparar arregloAux,subRes1
        cmp ah,1b
        je RESTA

        comparar arregloAux,mulRes1
        cmp ah,1b
        je MULTI

        comparar arregloAux,divRes1
        cmp ah,1b
        je DIVIS

        escribirF handleFichero,sizeof arregloAux,arregloAux
        inc di
        jmp INICIO

    SUMA:
        cleanArr arregloAux
        mov arregloAux[0],32
        mov arregloAux[1],'+'
        escribirF handleFichero, sizeof arregloAux, arregloAux
        inc di
        jmp INICIO

    RESTA:
        cleanArr arregloAux
        mov arregloAux[0],32
        mov arregloAux[1],'-'
        escribirF handleFichero, sizeof arregloAux, arregloAux
        inc di
        jmp INICIO

    MULTI:
        cleanArr arregloAux
        mov arregloAux[0],32
        mov arregloAux[1],'*'
        escribirF handleFichero, sizeof arregloAux, arregloAux
        inc di
        jmp INICIO

    DIVIS:
        cleanArr arregloAux
        mov arregloAux[0],32
        mov arregloAux[1],'/'
        escribirF handleFichero, sizeof arregloAux, arregloAux
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
        mov dx,di
endm

operar macro
    local INICIO, FIN, ESCR, QUIZAID
    
    xor di,di
    inc di

    INICIO:
        cmp di,si
        jge FIN

        cleanArr arregloAux
        leerF sizeof arregloAux, arregloAux, handle2

        cmp arregloAux[0],32
        je QUIZAID

        escribirF handle,sizeof arregloAux,arregloAux
        inc di
        jmp INICIO

    QUIZAID:
        cmp arregloAux[1],'+'
        je ESCR
        cmp arregloAux[1],'-'
        je ESCR
        cmp arregloAux[1],'*'
        je ESCR 
        cmp arregloAux[1],'/'
        je ESCR

        ConvertirSumaAscii arregloAux
        colocarRespuesta idsFinales
        
        cerrarF handle
        mov handle,00h
        ;aqui va la magia de la operacion :o 
        operacionFinal 
        borrarF rutaAux
        crearF rutaAux,handle
        inc di
        jmp INICIO

    ESCR:
        escribirF handle,sizeof arregloAux,arregloAux
        inc di
        jmp INICIO
    

    FIN:
        cerrarF handle
        mov handle,00h
        ;aqui va la magia de la operacion :o 
        operacionFinal
endm

operacionFinal macro
    local INICIO, FIN, ESCR, BUSCARID, IN2, FIN2, IN3, FIN3, SUMARS, MULTIPLICARS, DIVIDIRS, RESTARS, SACARRESPUESTA, FINALITO

    cleanArr arregloAux
    abrirF rutaAux,handle
    leerF sizeof bufferLectura,bufferLectura,handle
    xor dx,dx
    mov bl,72
    div bl
    mov dx,ax
    cerrarF handle
    mov handle,00h

    abrirF rutaAux,handle
    mov bx,0
     
    mov variable,dx

    INICIO:
        ;cleanArr arregloAux
        cmp bx,variable
        jge FIN
        ;darle la vuelta para operar
        leerF sizeof arregloAux, arregloAux, handle

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
        xor ax,ax
        mov al,arregloAux[1]
        mov dx,1000
        add dx,ax
        push dx
        inc bx
        jmp INICIO

    BUSCARID:
        xor dx,dx
        mov dl,arregloAux[0]
        ConvertirSumaAscii arregloAux ;en ax esta la suma de asciis del id, hay que restarle 1
        sub ax,1
        searchID
        push dx
        inc bx
        jmp INICIO



    FIN:
        cerrarF handle
        borrarF rutaAux

        mov handle,00h
        crearF rutaAux,handle
        abrirF rutaAux,handle
        xor bx,bx
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    IN2:
        cmp bx,variable
        jge FIN2

        pop dx 
        mov ax,dx
        ConvertirString resultadosTmp
        escribirF handle, sizeof resultadosTmp, resultadosTmp
        inc bx 
        jmp IN2


    FIN2:
        cerrarF handle
        mov handle,00h

        abrirF rutaAux,handle
        xor bx,bx
        mov auxWord[0],'N'

    IN3:
        cmp bx,variable
        jge FIN3

        leerF sizeof arregloAux, arregloAux, handle

        ConvertirAscii arregloAux
        cmp ax,1042 ;multiplicacion
        je MULTIPLICARS
        cmp ax,1043 ;suma
        je SUMARS
        cmp ax,1045 ;resta
        je RESTARS
        cmp ax,1047 ;division
        je DIVIDIRS

        mov dx,ax
        push dx
        
        inc bx
        jmp IN3

    MULTIPLICARS:
        pop dx 
        mov ax,dx
        pop dx
        mov cx,dx
        imul cx
        mov dx,ax
        push dx
        mov auxWord[0],'Y'
        inc bx
        jmp IN3
    
    SUMARS:
        pop dx
        mov ax,dx
        pop dx
        add ax,dx
        mov dx,ax
        push dx
        mov auxWord[0],'Y'
        inc bx
        jmp IN3

    RESTARS:
        pop dx 
        mov ax,dx
        pop dx
        sub ax,dx
        mov dx,ax
        push dx
        mov auxWord[0],'Y'
        inc bx
        jmp IN3
    
    DIVIDIRS:
        pop dx
        mov ax,dx
        pop dx
        mov cx,dx
        xor dx,dx
        idiv cx
        mov dx,ax
        push dx
        mov auxWord[0],'Y'
        inc bx
        jmp IN3

    FIN3:
        cerrarF handle
        mov handle,00h
        borrarF rutaAux
        cmp auxWord[0],'Y'
        je SACARRESPUESTA
        jmp FINALITO

    SACARRESPUESTA:
        pop dx ;resultado final
        mov ax,dx
        colocarRespuesta resultadosFinales
        ;ConvertirString resultadosTmp
        ;print resultadosTmp
        ;getChar

    
    FINALITO:
        ;getChar

        
endm

; ================= REPORTE FINAL ===============
generarReporte macro
    mov handle,00h
    crearF answers,handle
    escribirF handle, sizeof rep1, rep1
    escribirF handle, sizeof rep2, rep2
    escribirFecha
    escribirF handle, sizeof medRep, medRep
    escribirF handle, sizeof modRep, modRep
    escribirF handle, sizeof menRep, menRep
    escribirF handle, sizeof mayRep, mayRep
    escribirF handle, sizeof op1, op1
    escribirA nombrePadre, handle 
    escribirF handle, sizeof op2, op2

    getOperaciones

    escribirF handle, sizeof finRep, finRep
    cerrarF handle
    mov handle,00h
endm

getOperaciones macro
    local INICIO, FIN, ESCRIBCOMA

    xor si,si
    xor di,di

    INICIO:
        mov ax,resultadosFinales[si]
        cmp ax,00h
        je FIN

        ConvertirString resultadosTmp

        cmp si,0
        jg ESCRIBCOMA
    
    NORMAL:
        escribirF handle, sizeof inOperaciones, inOperaciones
        ; agarrar id de las operaciones
        escribirF handle, sizeof middleOperaciones, middleOperaciones
        escribirA resultadosTmp, handle
        inc si
        inc si
        jmp INICIO


    ESCRIBCOMA:
        escribirF handle, sizeof finOperaciones, finOperaciones
        escribirF handle, sizeof coma, coma
        jmp NORMAL

    FIN:
        escribirF handle, sizeof finOperaciones, finOperaciones
        


endm

;;; ================ estadisticos ==================
getMedia macro
    local INICIO, FIN, NEGATIVO, FINSI

    xor si,si
    xor ax,ax
    xor cx,cx

    INICIO:
        mov bx,resultadosFinales[si]
        cmp bx,00h
        je FIN

        add ax,bx

        inc si
        inc si
        inc cx
        jmp INICIO

    FIN:
        cmp ax,0
        jl NEGATIVO

        jmp FINSI

    NEGATIVO:
        neg ax
    
    FINSI:
        idiv cx
        ConvertirString resultadosTmp
        print resultadosTmp
        getChar

endm

getMayor macro
    local INICIO, FIN, ESMAYOR

    xor si,si
    xor ax,ax
    xor cx,cx

    INICIO:
        mov bx,resultadosFinales[si]
        cmp bx,00h
        je FIN

        cmp bx,ax
        jg ESMAYOR

        inc si
        inc si
        jmp INICIO

    ESMAYOR:
        mov ax,bx
        inc si
        inc si
        jmp INICIO


    FIN:
        ConvertirString resultadosTmp
        print resultadosTmp

endm

getMenor macro
    local INICIO, FIN, ESMAYOR

    xor si,si
    xor ax,ax
    xor cx,cx

    INICIO:
        mov bx,resultadosFinales[si]
        cmp bx,00h
        je FIN

        cmp bx,ax
        jl ESMAYOR

        inc si
        inc si
        jmp INICIO

    ESMAYOR:
        mov ax,bx
        inc si
        inc si
        jmp INICIO


    FIN:
        ConvertirString resultadosTmp
        print resultadosTmp

endm