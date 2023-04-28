assume cs:code1 , ds:data1

data1 segment
    nline   db 10,13, "$"
	welc	db "Wprowadz slowny opis dzialania: $"
    resmes	db "Wynikiem jest: $"

    zero    db 4, "zero$",     0
    one     db 5, "jeden$",    1
    two     db 3, "dwa$",      2
    three   db 4, "trzy$",     3
    four    db 6, "cztery$",   4
    five    db 4, "piec$",     5
    six     db 5, "szesc$",    6
    seven   db 6, "siedem$",   7
    eight   db 5, "osiem$",    8
    nine    db 8, "dziewiec$", 9

    ten         db 8,  "dziesiec$",       10
    eleven      db 10, "jedenascie$",     11
    twelve      db 9,  "dwanascie$",      12
    thirteen    db 10, "trzynascie$",     13
    fourteen    db 11, "czternascie$",    14
    fifteen     db 10, "pietnascie$",     15
    sixteen     db 10, "szesnascie$",     16
    seventen    db 12, "siedemnascie$",   17
    eighteen    db 11, "osiemnascie$",    18
    nineteen    db 14, "dziewietnascie$", 19

    twenty  db 11, "dwadziescia $",    20
    thirty  db 11, "trzydziesci $",    30
    fourty  db 12, "czterdziesci $",   40
    fifty   db 12, "piecdziesiat $",   50
    sixty   db 13, "szescdziesiat $",  60
    seventy db 14, "siedemdziesiat $", 70
    eighty  db 13, "osiemdziesiat $",  80

    plus     db 4, "plus$"
    minus    db 5, "minus $"
    multiply db 4, "razy$"

    res1     dw 0

    err1    db "Blad danych wejsciowych!$"

    err2    db "Zla liczba argumentow$"

    buff1 db 50, ?, 51 dup("$") ;bufor na znaki wprowadzone przez uzytkownika

    ;arg db start, end, value
    arg1        db 0,0,0
    op          db 0,0,0
    arg2        db 0,0,0



data1 ends

;===============================================================================

code1 segment
start1:
	mov	    ax, seg stack1 ;ustawienie wskaznika stosu
	mov	    ss, ax 
	mov	    sp, offset stack1 

    mov     dx,offset welc ;wypisanie powitania
    call    print1

    ;wczytanie danych do bufora
    mov     ax, seg data1 
    mov     ds, ax
    mov     dx, offset buff1
    mov     ah, 0ah
    int     21h

    ;znalezienie poczatkow i koncow argumentów i operatora
    mov     ax, seg data1; znalezienie pierwszego arumentu
    mov     ds, ax
    mov     cl, byte ptr ds:[buff1+1] ;zapisanie rozmiaru bufora danych wpisanych przez użytkownika
    mov     ch, 1 ;zerowanie licznika do iteracji
    mov     bx, 2 ;ustawienie wskaznika na pierwszy znak w buforze

    get_arg1_start:
        mov     byte ptr ds:[arg1], 0
    
    find_arg1_end:
        mov     dh, byte ptr ds:[buff1+bx] ;zaladuj znak z bufora

        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception1 ;wyrzuc wyjatek

        cmp     dh, 32 ;porownaj czy znak jest spacja, 32-kod ASCII spacji
        je      get_arg1_end ;jesli tak to zapisz koniec argumentu

        inc     bx ;przesun wskaznik na kolejny znak
        inc     ch ;inkrementuj licznik
    jmp find_arg1_end

    get_arg1_end:
        dec     ch ;przesun ch na pierwszy znak przed spacja
        mov     byte ptr ds:[arg1+1], ch
        inc     ch

    ;get_op_start:
    inc     bx ;inkrementuj wskaźnik na kolejny znak
    mov     byte ptr ds:[op], ch
    inc     ch 

    find_op_end:
        mov     dh, byte ptr ds:[buff1+bx] ;zaladuj znak z bufora

        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception1 ;wyrzuc wyjatek

        cmp     dh, 32 ;porownaj czy znak jest spacja, 32-kod ASCII spacji
        je      get_op_end ;jesli tak to zapisz koniec argumentu
        
        inc     bx ;przesun wskaznik na kolejny znak
        inc     ch ;inkrementuj licznik petli
    jmp find_op_end

    get_op_end:
        cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
        je      exception1 ;wyrzuc wyjatek
        dec     ch ;przesun ch na pierwszy znak przed spacja
        mov     byte ptr ds:[op+1], ch
        inc     ch
    
    ;get_arg2_start:
    inc     bx ;inkrementuj wskaźnik na kolejny znak
    cmp     cl, ch ;jesli dotarl do konca stringa to podano za malo argumentow
    je      exception1 ;wyrzuc wyjatek
    mov     byte ptr ds:[arg2], ch
    inc     ch ;przejdz do pierwszej pozycji argumentu po spacji

    ;get_arg2_end:
    mov     byte ptr ds:[arg2+1], cl
    

    ;rozpoznaj pierwsza cyfre
    mov     di, offset zero
    call    compare_arg1

    mov     di, offset one
    call    compare_arg1

    mov     di, offset two
    call    compare_arg1

    mov     di, offset three
    call    compare_arg1

    mov     di, offset four
    call    compare_arg1

    mov     di, offset five
    call    compare_arg1

    mov     di, offset six
    call    compare_arg1

    mov     di, offset seven
    call    compare_arg1

    mov     di, offset eight
    call    compare_arg1

    mov     di, offset nine
    call    compare_arg1

    call    exception1 ;jezeli nie znaleziono dopasowania to wyrzuc blad
    end_comparing_arg1:

    ;rozpoznaj druga cyfre
    mov     di, offset zero
    call    compare_arg2

    mov     di, offset one
    call    compare_arg2

    mov     di, offset two
    call    compare_arg2

    mov     di, offset three
    call    compare_arg2

    mov     di, offset four
    call    compare_arg2

    mov     di, offset five
    call    compare_arg2

    mov     di, offset six
    call    compare_arg2

    mov     di, offset seven
    call    compare_arg2

    mov     di, offset eight
    call    compare_arg2

    mov     di, offset nine
    call    compare_arg2

    call    exception1 ;jezeli nie znaleziono dopasowania to wyrzuc blad
    end_comparing_arg2:

    ;rozpoznaj operator
    ;dodawanie
    mov     al, byte ptr ds:[arg1+2]
    add     al, byte ptr ds:[arg2+2]
    mov     ah, 0
    mov     word ptr ds:[res1], ax
    
    mov     di, offset plus
    call    compare_op

    ;odejmowanie
    mov     al, byte ptr ds:[arg1+2]
    mov     bl, byte ptr ds:[arg2+2] 
    mov     ah, 0
    mov     bh, 0
    sub     ax, bx
    mov     word ptr ds:[res1], ax

    mov     di, offset minus
    call    compare_op

    ;mnozenie
    mov     ax, 0
    mov     al, byte ptr ds:[arg1+2]
    mul     byte ptr ds:[arg2+2]
    mov     word ptr ds:[res1], ax

    mov     di, offset multiply
    call    compare_op

    call    exception1 ;jezeli nie znaleziono dopasowania to wyrzuc blad
    end_comparing_op:

    ;wprzygotowanie do wypisania wyniku
    call    printnline
    mov     dx, offset resmes
    call    print1

    ;parsowanie wyniku
    mov     bx, word ptr ds:[res1] ;wrzucenie  wyniku do bx
    cmp     bx, 80
    jg      parse_negative
    cmp     bx, 20 ;jezeli wynik jest niemniejszy niz 20 to parsuj dziesiatki
    jge     parse_dozens
    cmp     bx, 10 ;jezeli wynik jest niemniejszy niz 10 to pasuj nastki
    jge     parse_ovdozen
    cmp     bx, 0 ;jezeli wynik jest niemniejszy niz 0 to pasuj jednosci
    jge     parse_units 
    jmp     parse_negative ;w innym wypadku parsuj ujemne

    parse_negative:
        mov     dx, offset minus+1 ;wypisz minus
        call    print1
        neg     bx ;do bx wrzuc liczbe przeciwna
        jmp     parse_units ;parsuj jednosci (maksymalna ujemna to -8)

    parse_dozens: ;gdy znajde cyfre dziesiatek to w dx jest offset na slowny zapis, a w bx jest liczba po odjeciu dziesiatek
        mov     dx, offset twenty+1
        sub     bx, 20
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset thirty+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset fourty+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset fifty+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset sixty+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset seventy+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        cmp     bx, 10
        jl      print_dozens

        mov     dx, offset eighty+1
        sub     bx, 10
        cmp     bx, 0
        je      print_result
        jmp     print_dozens

    print_dozens:
        call    print1
        jmp     parse_units

    parse_ovdozen:
        mov     dx, offset ten+1
        cmp     bx, 10
        je      print_result

        mov     dx, offset eleven+1
        cmp     bx, 11
        je      print_result

        mov     dx, offset twelve+1
        cmp     bx, 12
        je      print_result

        mov     dx, offset thirteen+1
        cmp     bx, 13
        je      print_result

        mov     dx, offset fourteen+1
        cmp     bx, 14
        je      print_result

        mov     dx, offset fifteen+1
        cmp     bx, 15
        je      print_result

        mov     dx, offset sixteen+1
        cmp     bx, 16
        je      print_result

        mov     dx, offset seventen+1
        cmp     bx, 17
        je      print_result

        mov     dx, offset eighteen+1
        cmp     bx, 18
        je      print_result

        mov     dx, offset nineteen+1
        jmp      print_result

    parse_units:
        mov     dx, offset nine+1
        cmp     bx, 9
        je      print_result

        mov     dx, offset eight+1
        cmp     bx, 8
        je      print_result

        mov     dx, offset seven+1
        cmp     bx, 7
        je      print_result

        mov     dx, offset six+1
        cmp     bx, 6
        je      print_result

        mov     dx, offset five+1
        cmp     bx, 5
        je      print_result

        mov     dx, offset four+1
        cmp     bx, 4
        je      print_result

        mov     dx, offset three+1
        cmp     bx, 3
        je      print_result

        mov     dx, offset two+1
        cmp     bx, 2
        je      print_result

        mov     dx, offset one+1
        cmp     bx, 1
        je      print_result

        mov     dx, offset zero+1
        jmp     print_result

    print_result:
        call    print1

    end_prog:
        mov     al,0 ;koniec programu
        mov     ah,4ch
        int     21h

;============================================
;paramert dx - offset
    print1: 
        mov     ax, seg data1
        mov     ds, ax 
        mov     ah, 9h
        int     21h
        ret
;============================================
    printnline:
        mov     ax, seg data1
        mov     ds, ax 
        mov     dx,offset nline
        mov     ah, 9h
        int     21h
        ret
;============================================
    exception1:
        call    printnline
        mov     dx, offset err1
        call    print1
        jmp     end_prog  
;============================================
;parametr di - offset na liczbę (one, two itd.)
    compare_arg1:
        mov     ax, seg data1
        mov     ds, ax

        mov     al, byte ptr ds:[arg1+1] ;do al arg_end
        mov     ah, byte ptr ds:[arg1] ;do ah arg_start
        sub     al, ah ;odejmnij i zdobadz dlugosc arg1 w al

        mov     ah, byte ptr ds:[di] ;do ah dlugosc parametru (na pierwszym bajcie mam zawsze dlugosci)

        cmp     al, ah ;jesli dlugosc tych slow sie rozni to skoncz porownanie
        jne     end_comp1

        mov     cl, al ;do cl zapisuje sobie dlugosc slowa

        inc     di ;di przesuwam na pierwszy znak parametru

        mov     bx, 2 ;ustawiam bx jako znacznik na pierwszy znak arg1 w buforze
        mov     bh, 0 
        add     bl, byte ptr ds:[arg1]

        mov     ch, 1 ;ustawiam licznik petli

        comp1:
            mov     dh, byte ptr ds:[buff1+bx] ;do dh wrzucam literke z arg1
            mov     dl, byte ptr ds:[di] ;do dl wrzucam literke z parametru

            cmp     dh, dl ;porownuje obie literki
            jne     end_comp1 ;jesli sa rozne to nie sprawdzam dalej

            cmp     ch, cl ;jesli dotarlam do konca petli to znalzlam argument
            je      is_found1

            inc bx ;zwiekszam wskazniki i liczniki petli
            inc di
            inc ch
        jmp comp1

        end_comp1:
            ret

        is_found1:
            inc     di
            inc     di ;ustaw di na wartosc liczby
            mov     al, byte ptr ds:[di]
            mov     byte ptr ds:[arg1+2], al ;ustaw wartosc argumentu
            jmp     end_comparing_arg1

;============================================
;UWAGA - nie robie jednej funkcji dla porownania obu argumentow, zeby latwo wrocic do end_comparing_argX
;parametr di - offset na liczbę (one, two itd.)
    compare_arg2:
        mov     ax, seg data1
        mov     ds, ax

        mov     al, byte ptr ds:[arg2+1] ;do al arg_end
        mov     ah, byte ptr ds:[arg2] ;do ah arg_start
        sub     al, ah ;odejmnij i zdobadz dlugosc arg2 w al

        mov     ah, byte ptr ds:[di] ;do ah dlugosc parametru (na pierwszym bajcie mam zawsze dlugosci)

        cmp     al, ah ;jesli dlugosc tych slow sie rozni to skoncz porownanie
        jne     end_comp2

        mov     cl, al ;do cl zapisuje sobie dlugosc slowa

        inc     di ;di przesuwam na pierwszy znak parametru

        mov     bx, 2 ;ustawiam bx jako znacznik na pierwszy znak arg2 w buforze
        mov     bh, 0 
        add     bl, byte ptr ds:[arg2]

        mov     ch, 1 ;ustawiam licznik petli

        comp2:
            mov     dh, byte ptr ds:[buff1+bx] ;do dh wrzucam literke z arg2
            mov     dl, byte ptr ds:[di] ;do dl wrzucam literke z parametru

            cmp     dh, dl ;porownuje obie literki
            jne     end_comp2 ;jesli sa rozne to nie sprawdzam dalej

            cmp     ch, cl ;jesli dotarlam do konca petli to znalzlam argument
            je      is_found2

            inc bx ;zwiekszam wskazniki i liczniki petli
            inc di
            inc ch
        jmp comp2

        end_comp2:
            ret

        is_found2:
            inc     di
            inc     di ;ustaw di na wartosc liczby
            mov     al, byte ptr ds:[di]
            mov     byte ptr ds:[arg2+2], al ;ustaw wartosc argumentu
            jmp     end_comparing_arg2

;============================================
;parametr di - offset na operator (plus, minus, razy)
    compare_op:
        mov     ax, seg data1
        mov     ds, ax

        mov     al, byte ptr ds:[op+1] ;do al op_end
        mov     ah, byte ptr ds:[op] ;do ah op_start
        sub     al, ah ;odejmnij i zdobadz dlugosc op w al

        mov     ah, byte ptr ds:[di] ;do ah dlugosc parametru (na pierwszym bajcie mam zawsze dlugosci)

        cmp     al, ah ;jesli dlugosc tych slow sie rozni to skoncz porownanie
        jne     end_comp3

        mov     cl, al ;do cl zapisuje sobie dlugosc slowa

        inc     di ;di przesuwam na pierwszy znak parametru

        mov     bx, 2 ;ustawiam bx jako znacznik na pierwszy znak arg1 w buforze
        mov     bh, 0 
        add     bl, byte ptr ds:[op]

        mov     ch, 1 ;ustawiam licznik petli

        comp3:
            mov     dh, byte ptr ds:[buff1+bx] ;do dh wrzucam literke z arg1
            mov     dl, byte ptr ds:[di] ;do dl wrzucam literke z parametru

            cmp     dh, dl ;porownuje obie literki
            jne     end_comp3 ;jesli sa rozne to nie sprawdzam dalej

            cmp     ch, cl ;jesli dotarlam do konca petli to znalzlam argument
            je      is_found3

            inc bx ;zwiekszam wskazniki i liczniki petli
            inc di
            inc ch
        jmp comp3

        end_comp3:
            ret

        is_found3:
            jmp     end_comparing_op

code1 ends

;===============================================================================

stack1 segment stack
	dw	300 dup(?) 
wstack1	dw	?
stack1 ends

;===============================================================================

end start1

