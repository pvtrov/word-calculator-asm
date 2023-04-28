
assume cs:kod , ds:dane

dane segment
    cztery  db 4, "cztery i juz$", 4
    t1      db  "hej agusia", 10, 13, "$"
    buf1    db 10, ?, 20 dup('$')
dane ends

kod segment
start:
    mov ax,seg wstos
    mov ss,ax
    mov sp, offset wstos

    mov  dx,offset t1
    call wypisz

    mov ax,seg dane
    mov ds,ax
    mov dx,offset buf1
    mov ah,0ah
    int 21h

    mov bp,offset buf1 +1  ; dodaje +1 zeby dostac się "?" w buforze (ile znakow zostalo wpisane)
    mov bl,byte ptr ds:[bp] ; wczytuje do bl komorke pamieci ktora jest pod adresem ds:[bp] 
    add bl,1
    mov bh,0 ; zerujemy rejestr bh

    mov  dx,offset buf1
    call wypisz

    mov al,0
    mov ah,4ch ; koneic or
    int 21h


wypisz:
    mov ax,seg dane
    mov ds,ax
    mov ah,9
    int 21h
    ret


kod ends

stos segment stack
        dw 300 dup(?)
wstos   dw  ?

stos ends

end start
