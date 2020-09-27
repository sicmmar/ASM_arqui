include reporte.asm

print macro cadena
    mov ah,09h
    lea dx,cadena
    int 21h
endm

ObtenerTexto macro buffer
    local CONTINUE, FIN
        PUSH SI
        PUSH AX

        xor si,si
        CONTINUE:
            getChar
            cmp al,0dh
            je FIN
            mov buffer[si],al
            inc si
            jmp CONTINUE

        FIN:
            mov al,'$'
            mov buffer[si],al

        POP AX
        POP SI
endm

getChar macro
    mov ah,0dh
    int 21h
    mov ah,01h
    int 21h
endm

printChar macro char
    push dx
    mov ah,02h
    mov dl,char
    int 21h
    pop dx
endm

cleanArr macro arr
    local CONTINUE, FIN
    PUSH SI
    PUSH AX

    xor si,si
    mov bx,sizeof arr
    CONTINUE:
        cmp si,bx
        je FIN
        mov al,'$'
        mov arr[si],al
        inc si
        jmp CONTINUE

    FIN:
        mov al,'$'
        mov arr[si],al

    POP AX
    POP SI
endm


;=========================== FICHEROS ===================
abrirF macro ruta,handle
    mov ah,3dh
    mov al,010b
    lea dx,ruta
    int 21h
    mov handle,ax
    jc ErrorAbrir
endm

leerF macro numbytes,buffer,handle
	mov ah,3fh
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorLeer
endm

crearF macro ruta, handle
    mov ah,3ch
    mov cx,00h
    lea dx, ruta
    int 21h
    mov handle,ax
    jc ErrorCrear
endm

escribirF macro handle, numBytes, buffer
    mov ah,40h
    mov bx,handle
    mov cx,numBytes
    lea dx,buffer
    int 21h
    jc ErrorEscribir
endm

getRuta macro buffer
    LOCAL INICIO,FIN
    xor si,si
        INICIO:
            getChar
            cmp al,0dh
            je FIN
            mov buffer[si],al
            inc si
            jmp INICIO
        FIN:
            mov buffer[si],00h
            inc si
            mov buffer[si],00h
endm

cerrarF macro handle
	mov ah,3eh
	mov bx,handle
	int 21h
	jc ErrorCerrar
endm

;==================== COMPARACIONES ========================
comparar macro actual, molde
    local INICIO, FIN

    xor si,si
    xor ax,ax
    mov cx,sizeof molde

    INICIO:
        mov bh,actual[si]
        cmp bh,molde[si]
        jne FIN
        inc si
        loop INICIO
        mov ah,1b
    
    FIN:
        mov al,0b
endm