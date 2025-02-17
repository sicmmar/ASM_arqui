
include juego.asm

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

llenarInicial macro n1,n2,n3,b1,b2,b3,sp1,sp2
    local SPACE1, SPACE2

    mov b1[0],11b
    mov b1[2],11b
    mov b1[4],11b
    mov b1[6],11b
    mov b2[1],11b
    mov b2[3],11b
    mov b2[5],11b
    mov b2[7],11b
    mov b3[0],11b
    mov b3[2],11b
    mov b3[4],11b
    mov b3[6],11b
    mov n2[0],10b
    mov n2[2],10b
    mov n2[4],10b
    mov n2[6],10b
    mov n1[1],10b
    mov n1[3],10b
    mov n1[5],10b
    mov n1[7],10b
    mov n3[1],10b
    mov n3[3],10b
    mov n3[5],10b
    mov n3[7],10b

    xor si,si
    mov cx,8
    SPACE1:
        mov sp1[si],32
        inc si
        loop SPACE1
    
    xor si,si
    mov cx,8
    SPACE2:
        mov sp2[si],32
        inc si
        loop SPACE2

endm

imprimirTablero macro p8,p7,p6,p5,p4,p3,p2,p1,arr,g
    cleanArr arr, sizeof arr
    mov bl,'8'
    llenarArr arr,p8
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'7'
    llenarArr arr,p7
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'6'
    llenarArr arr,p6
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'5'
    llenarArr arr,p5
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'4'
    llenarArr arr,p4
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'3'
    llenarArr arr,p3
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'2'
    llenarArr arr,p2
    print arr
    print g

    cleanArr arr, sizeof arr
    mov bl,'1'
    llenarArr arr,p1
    print arr

    cleanArr arr, sizeof arr
endm

llenarArr macro arr,entrada
    local CONTINUE, FIN, FB, FN, RB, RN, SPACE
    mov arr[0],9
    mov arr[1],bl
    mov arr[2],32
    mov arr[3],32
    mov arr[4],179 ;|
    
    mov di,5
    mov si,0
    CONTINUE:
        cmp si,8
        je FIN
        mov al,entrada[si]
        cmp al,11b
        je FB
        cmp al,10b
        je FN
        cmp al,01b
        je RB
        cmp al,00b
        je RN
        cmp al,32
        je SPACE
    
    FB:
        mov arr[di],'F'
        inc di
        mov arr[di],'B'
        inc di
        mov arr[di],179
        inc di
        inc si
        jmp CONTINUE

    FN:
        mov arr[di],'F'
        inc di
        mov arr[di],'N'
        inc di
        mov arr[di],179
        inc di
        inc si
        jmp CONTINUE

    RB:
        mov arr[di],'R'
        inc di
        mov arr[di],'B'
        inc di
        mov arr[di],179
        inc di
        inc si
        jmp CONTINUE

    RN:
        mov arr[di],'R'
        inc di
        mov arr[di],'N'
        inc di
        mov arr[di],179
        inc di
        inc si
        jmp CONTINUE

    SPACE:
        mov arr[di],32
        inc di
        mov arr[di],32
        inc di
        mov arr[di],179
        inc di
        inc si
        jmp CONTINUE

    FIN:
        mov al,10
        mov arr[di],al
        inc di
        mov al,13
        mov arr[di],al
        inc di
        mov al,'$'
        mov arr[di],al
endm

cleanArr macro arr,tamano
    local CONTINUE, FIN
    PUSH SI
    PUSH AX

    xor si,si
    mov bx,tamano
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
endm

cerrarF macro handle
	mov ah,3eh
	mov bx,handle
	int 21h
	jc ErrorCerrar
endm