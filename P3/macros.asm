print macro cadena
    mov ah,09h
    mov dx,@data
    mov ds,dx
    mov dx,offset cadena
    int 21h
endm

ObtenerTexto macro buffer
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
    mov ah,02h
    mov dl,char
    int 21h
endm