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