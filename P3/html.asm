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

filaParHTML macro posicion
    local INICIO, FB, FN, RB, RN, ESCRIBIR, FIN, BLANK
    xor di,di
    xor si,si
    xor bx,bx

    INICIO:
        mov di,80
        mov cx,30
        inc si ;pos si: 1,3,5,7
        mov bx,si
        cmp bx,9
        je FIN        
        mov al,posicion[si]
        push si
        xor si,si
        cmp al,11b
        je FB
        cmp al,10b
        je FN
        cmp al,01b
        je RB
        cmp al,00b
        je RN
        cmp al,32
        je BLANK
        pop si
        inc si
        jmp INICIO
    
    FB:
        mov dl,blancaHTML[si]
        mov filaParHTMLx4[di],dl
		inc si
		inc di
        loop FB
        jmp ESCRIBIR

    FN:
        mov dl,negraHTML[si]
        mov filaParHTMLx4[di],dl
		inc si
		inc di
        loop FN
        jmp ESCRIBIR
    
    RB:
        mov dl,blancaReinaHTML[si]
        mov filaParHTMLx4[di],dl
		inc si
		inc di
        loop RB
        jmp ESCRIBIR
    
    RN:
        mov dl,negraReinaHTML[si]
        mov filaParHTMLx4[di],dl
		inc si
		inc di
        loop RN
        jmp ESCRIBIR

    BLANK:
        mov filaParHTMLx4[di],32
		inc si
		inc di
        loop BLANK
        jmp ESCRIBIR

    ESCRIBIR:
        escribirF handle2, sizeof filaParHTMLx4, filaParHTMLx4
        pop si
        inc si
        jmp INICIO

    FIN:
        xor si,si
        xor di,di
endm

filaImparHTML macro posicion
    local INICIO, FB, FN, RB, RN, ESCRIBIR, FIN, BLANK
    xor di,di
    xor si,si
    xor bx,bx

    INICIO:
        mov di,38
        mov cx,30
        mov bx,si
        cmp bx,8
        je FIN        
        mov al,posicion[si]
        inc si ;pos si: 0,2,4,6
        push si
        xor si,si
        cmp al,11b
        je FB
        cmp al,10b
        je FN
        cmp al,01b
        je RB
        cmp al,00b
        je RN
        cmp al,32
        je BLANK
        pop si
        inc si
        jmp INICIO
    
    FB:
        mov dl,blancaHTML[si]
        mov filaImparHTMLx4[di],dl
		inc si
		inc di
        loop FB
        jmp ESCRIBIR

    FN:
        mov dl,negraHTML[si]
        mov filaImparHTMLx4[di],dl
		inc si
		inc di
        loop FN
        jmp ESCRIBIR
    
    RB:
        mov dl,blancaReinaHTML[si]
        mov filaImparHTMLx4[di],dl
		inc si
		inc di
        loop RB
        jmp ESCRIBIR
    
    RN:
        mov dl,negraReinaHTML[si]
        mov filaImparHTMLx4[di],dl
		inc si
		inc di
        loop RN
        jmp ESCRIBIR

    BLANK:
        mov filaImparHTMLx4[di],32
		inc si
		inc di
        loop BLANK
        jmp ESCRIBIR

    ESCRIBIR:
        escribirF handle2, sizeof filaImparHTMLx4, filaImparHTMLx4
        pop si
        inc si
        jmp INICIO

    FIN:
        xor si,si
        xor di,di
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