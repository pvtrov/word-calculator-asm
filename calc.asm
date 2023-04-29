; By rozwiazac dane zadanie, popelnilam nastepujace kroki:
; 1. wyswietlilam napis powitujacy
; 2. pobralam dane od uzytkownika
; 3. pobralam dlugosci kazdego z "czlonow" inputu, tj argumentu 1, operatora i argumentu 2
; 4. rozpoznalam kazda z cyfr oraz operator
; 5. po rozpozannaiu operatora wykonalam dzialanie
; 6. wyprintowalam slowny wynik

assume cs:code , ds:data

data segment
    ; definiuje napisy wyświetlane na ekranie
    welcome     db "Wprowadz slowny opis dzialania", 13, 10, "$"
    result      db 13, 10, "Wynikiem jest: $"
    empt_line   db 10, 13, "$"

    ; definuje errory dla zlego wprowadzenia
    error1  db 13, 10, "Zle dane wejsciowe :( :( :( $"
    error2  db 13, 10, "Oj, podales zla liczbe argumnetow :( sproboj ponownie $"

    ; definuje bufor na ciag znakow przyjety od uzytkownika
    bufor   db 50, ?, 100 dup("$")

    ; definuje zmienne na pobrane argumenty
    ; wartosc, poczatek, koniec
    arg_1    db 0, 0, 0
    arg_2    db 0, 0, 0
    operator db 0, 0, 0

    res_val  dw 0  

    ; definuje dane na ktorych bede operowac w postaci:
    ; nazwa zmiennej (offsetu), długosc napisu, napis, wartosc liczbowa zmiennej  
    zero        db 4, "zero$",            0
    one         db 5, "jeden$",           1
    two         db 3, "dwa$",             2    
    three       db 4, "trzy$",            3
    four        db 6, "cztery$",          4
    five        db 4, "piec$",            5
    six         db 5, "szesc$",           6
    seven       db 6, "siedem$",          7
    eight       db 5, "osiem$",           8
    nine        db 8, "dziewiec$",        9
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
    twenty      db 11, "dwadziescia $",   20
    thirty      db 11, "trzydziesci $",   30
    fourty      db 12, "czterdziesci $",  40
    fifty       db 12, "piecdziesiat $",  50
    sixty       db 13, "szescdziesiat $", 60
    seventy     db 14, "siedemdziesiat $",70
    eighty      db 13, "osiemdziesiat $", 80

    plus     db 4, "plus$"
    minus    db 5, "minus $"
    multiply db 4, "razy$"

data ends

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

code segment
main:
    mov     ax, seg stack_                      ; wczytuje adres stosu do rejestru AX
    mov     ss, ax                              ; przypisuje wartosc rejestru AX do rejestru SS
    mov     sp, offset stack_                   ; wczytuje offset stosu do rejestru SP

    ; wyswietlam powitanie
    mov     dx, offset welcome
    call    print

    ; wczytuje input uzytkowanika
    mov     ax,seg data
    mov     ds,ax
    mov     dx,offset bufor
    mov     ah,0ah
    int     21h
    
    ; zaczynam poszukiwania poczatku i konca inputu
    mov     ax, seg data
    mov     ds, ax
    mov     bp, offset bufor+1                  ; dodaje +1 zeby dostac się "?" w buforze (ile znakow zostalo wpisane)
    mov     cl, byte ptr ds:[bp]                ; wczytuje do cl liczbe wpisanych znakow 
    mov     ch, 1                               ; zeruje licznik iteracji
    mov     bx, 2                               ; ustawiam wskaznik na pierwszy znak w buforze

    ; ustawiam poczatek argumentu 1 na 0
    mov     byte ptr ds:[arg_1+1], 0    

    find_first_arg_end:
        mov     dh, byte ptr ds:[bufor+bx]

        cmp     cl, ch                          ; jesli to koniec stringa to podano za malo argumentow
        je      throw_exception_2

        cmp     dh, 32                          ; jesli to spacja to zapisz koniec argumnetu
        je      set_first_arg_end

        inc     bx                              ; przesuwamy wskaznik dalej
        inc     ch                              ; wzrastamy licznik
    jmp     find_first_arg_end

    set_first_arg_end:
        dec     ch                              ; przesuwam ch na pierwszy znak przed spacja
        mov     bp, offset arg_1+2 
        mov     byte ptr ds:[bp], ch            ; wpisuje dlugosc pierwszego argumentu
        inc     ch

    ; ustawiam poczatek operatora na aktualny numer
    inc     bx                                  ; przesuwam wsakznik na kolejny znak
    mov     byte ptr ds:[operator+1], ch        ; ustaw poczatek operatora na aktualny numer
    inc     ch

    find_operator_end:
        mov     dh, byte ptr ds:[bufor+bx]      ; zczytuje znak z bufora
        
        cmp     cl, ch                          ; jesli koniec stringa to za malo argumentow
        je      throw_exception_2          

        cmp     dh, 32                          ; jesli to spacja to zapisz koniec operatora
        je      set_operator_end

        inc     bx                              ; przesuwam wskaznik na kolejny znak
        inc     ch                              ; wzrastam licznik
    jmp find_operator_end

    set_operator_end:
        cmp     cl, ch                          ; jesli koniec stringa to za malo argumentow
        je      throw_exception_2

        dec     ch                              ; przesuwam wskaznik na znak przed spacja
        mov     byte ptr ds:[operator+2], ch    ; zapisuje jako koniec aktualny numer ch
        inc     ch                              ; wzrastam ch

    ; usawiam poczatek drugiego argumentu na aktualny numer
    inc     bx                                  ; przesuwam wskaznik na kolejny znak 
    mov     byte ptr ds:[arg_2+1], ch           ; ustawiam poacztek argumentu drugiego
    inc     ch                                  ; wzrastam ch

    find_second_argument_end:
        mov     dh, byte ptr ds:[bufor+bx]      ; zczytuje znak z bufora

        cmp     cl, ch                          ; jesli koniec stringa to za malo argumentow
        je      throw_exception_2

        jmp     continue

    throw_exception_2:
        ; za mala ilosc argumentow
        mov     dx,offset error2
        call    print
        jmp     end_program


    continue:
    ; jesli nie wyrzucilo nam wyjatku to znaczy ze mamy 3 argumenmty, 
    ; a wiec koniec 2 argumentu znajduje sie na koncu stringa:
    ; ustawiam koniec drugiego argumentu:

    mov     byte ptr ds:[arg_2+2], cl


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ponizej proboje znalezc dopasowanie do cyfr i operatorów
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    find_first_arg:
    ; zczytuje jaka cyfra to pierwszy argument

    mov     di, offset zero
    call    match_first_argument

    mov     di, offset one
    call    match_first_argument

    mov     di, offset two
    call    match_first_argument

    mov     di, offset three
    call    match_first_argument

    mov     di, offset four
    call    match_first_argument

    mov     di, offset five
    call    match_first_argument

    mov     di, offset six
    call    match_first_argument

    mov     di, offset seven
    call    match_first_argument

    mov     di, offset eight
    call    match_first_argument

    mov     di, offset nine
    call    match_first_argument

    
    call    throw_exception_1                   ; jak nic nie znalazlo to wyrzuc blad

    find_second_arg:
   ; zczytuje jaka cyfra to drugi argument

    mov     di, offset zero
    call    match_second_argument

    mov     di, offset one
    call    match_second_argument

    mov     di, offset two
    call    match_second_argument

    mov     di, offset three
    call    match_second_argument

    mov     di, offset four
    call    match_second_argument

    mov     di, offset five
    call    match_second_argument

    mov     di, offset six
    call    match_second_argument

    mov     di, offset seven
    call    match_second_argument

    mov     di, offset eight
    call    match_second_argument

    mov     di, offset nine
    call    match_second_argument


    call    throw_exception_1                   ; jak nic nie znalazlo to wyrzuc blad


    find_operator:
        mov     di, offset plus
        call    match_operator_plus

        mov     di, offset minus
        call    match_operator_minus

        mov     di, offset multiply
        call    match_operator_multiply


        call    throw_exception_1               ; jak nic nie znalazlo to wyrzuc blad


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ponizsze funkcje odpowiadaja za wykonanie dzialania
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    add_arguments:
        mov     al, byte ptr ds:[arg_1]         ; zapisuje do al wartosc pierwszego argumentu
        add     al, byte ptr ds:[arg_2]         ; dodaje do al wartosc drugiego argumentu
        mov     ah, 0
        mov     word ptr ds:[res_val], ax       ; ustawiam wartosc wyniku na optrzymana z dodawania wartosc

        jmp     print_solution                  ; przeskakuje do printowania wyniku
    

    substract_arguments:
        mov     al, byte ptr ds:[arg_1]         ; zapisuje do al wartosc pierwszego argumentu
        mov     bl, byte ptr ds:[arg_2]         ; zapisuje do bl wartosc drugiego argumnetu
        mov     ah, 0   
        mov     bh, 0
        sub     ax, bx                          ; odejmuje wartosci
        mov     word ptr ds:[res_val], ax       ; przypisuje otzrymana wartosc do wyniku

        jmp     print_solution


    multiply_arguments:
        mov     ax, 0                            
        mov     al, byte ptr ds:[arg_1]         ; przypisuje do al wartosc pierwszego argumnetu 
        mul     byte ptr ds:[arg_2]             ; mnoze wartosci
        mov     word ptr ds:[res_val], ax       ; przypisuje optrzymana wartosc do wyniku

        jmp     print_solution


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ponizsze funkcje odpowiadaja za wyprintowanie wyniku
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    print_solution:
        mov     dx, offset result               ; wypisuje "wynikiem jest: "
        call    print

        mov     dx, offset empt_line            ; wypisuje nową linie
        call    print

    mov     bx, word ptr ds:[res_val]           ; wpisuje wynik do bx

    cmp     bx, 0                               ; jezeli wynik jest równy 0 to wypisuje 0 i koncze program
    je      print_zero

    cmp     bx, 20                              ; jezeli wynik jest wiekszy badz rowny 20 to przechodze do anazliy dziesiatek
    jge     print_tens

    jmp     compare_teens                       ; w innym wypadku sprawdzam czy wynik zawiera sie w 10-19

    print_zero:
        mov     dx, offset zero+1
        call    print
        jmp     end_program

    print_tens:                                 
            ; odejmujac kolejno znajduje rzad dziesiatek, gdy go znajde do printuje slowo i przechodze do badania jednosci 

            mov     dx, offset twenty+1         ; zakladam najpierw ze wynik jest rzedu 20
            sub     bx, 20                      ; odejmuje 20
            cmp     bx, 0                       ; jesli otrzymana roznica jest rowna 0 to znaczy ze wynik to 20
            je      print_tens_result           ; printuje "dwadziescia "
            cmp     bx, 10                      ; jesli otrzymana roznica jest mniejsza od 10 to znaczy ze wynik jest rzedu 21-29
            jl      print_dozens                ; przechodze do printowania

            mov     dx, offset thirty+1         ; analogicznie jak powyzej
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            cmp     bx, 10
            jl      print_dozens

            mov     dx, offset fourty+1
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            cmp     bx, 10
            jl      print_dozens

            mov     dx, offset fifty+1
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            cmp     bx, 10
            jl      print_dozens

            mov     dx, offset sixty+1
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            cmp     bx, 10
            jl      print_dozens

            mov     dx, offset seventy+1
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            cmp     bx, 10
            jl      print_dozens

            mov     dx, offset eighty+1
            sub     bx, 10
            cmp     bx, 0
            je      print_tens_result
            jmp     print_dozens

        print_dozens:
            call    print                       ; printuje dziesiatki
            jmp     print_units                 ; przechodze do printowania jednosci

        print_tens_result:
            call    print                       ; printuje same dziesiatki tj. 10, 20, 30 etc.
            jmp     end_program

    compare_teens:
        cmp     bx, 10                          ; jezeli bx jest rowny badz wiekszy 10 to znaczy ze wynik jest 10-19
        jge     print_teens                     ; printujemy nastki

        jmp     compare_units                   ; jesli nie to porownujemy jednosci (wynik jest jednocyfrowy)

    print_teens:
        ; sprawdzam po kolei i jesli cos jest rowne to printuje wynik

        mov     dx, offset ten+1            
        cmp     bx, 10
        je      print_teens_result

        mov     dx, offset eleven+1
        cmp     bx, 11
        je      print_teens_result

        mov     dx, offset twelve+1
        cmp     bx, 12
        je      print_teens_result

        mov     dx, offset thirteen+1
        cmp     bx, 13
        je      print_teens_result

        mov     dx, offset fourteen+1
        cmp     bx, 14
        je      print_teens_result

        mov     dx, offset fifteen+1
        cmp     bx, 15
        je      print_teens_result

        mov     dx, offset sixteen+1
        cmp     bx, 16
        je      print_teens_result

        mov     dx, offset seventen+1
        cmp     bx, 17
        je      print_teens_result

        mov     dx, offset eighteen+1
        cmp     bx, 18
        je      print_teens_result

        mov     dx, offset nineteen+1
        jmp     print_teens_result

    print_teens_result:
        call    print                           ; printuje wynik nastkowy
        jmp     end_program                     ; koncze program

    compare_units:
        cmp     bx, 0                           ; jezeli bx jest rowne badz wieksze od 0 to znaczy ze wynik jest 0-9
        jge     print_units                     ; printuje jednosci

        jmp     print_negative                  ; w innym wypadku wynik musi byc -8 do -1 wiec printujemy ujemne

    print_negative:                         
        mov     dx, offset minus+1              ; printuje minus
        call    print

        neg     bx                              ; zamieniam liczbe na przeciwna
        jmp     print_units                     ; teraz printuje liczbe


    print_units:
        ; sprawdzam po kolei i jesli cos jest rowne to printuje wynik

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


    print_result:                               ; printuje wynik
        call print

    jmp     end_program                         ; zakoncz program


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ponizsze funkcje zajmuja sie dopasowaniem cyfr oraz operatora
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

match_first_argument:
    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[arg_1+2]           ; wczytuje do al koniec 1 argumentu
    mov     ah, byte ptr ds:[arg_1+1]           ; wczytuje do ah poczatek 1 argumentu
    sub     al, ah                              ; wyliczam dlugosc argumentu 

    mov     ah, byte ptr ds:[di]                ; wczytuje z danych do ah dlugosc badanej cyfry

    cmp     ah, al                              ; jesli dlugosci sa inne to nie sprawdzam dalej
    jne     return

    mov     cl, al                              ; wpisuje dlugosc slowa do cl

    mov     bx, 2                               ; ustawiam bx na poczatek cyfry
    mov     bh, 0
    add     bl, byte ptr ds:[arg_1+1]

    inc     di                                  ; przesuwam wskaznik na pierwsza lioterke sperawdzanej cyfry

    mov     ch, 1                               ; ustawiam licznik petli

    compare_loop:
        mov     dh, byte ptr ds:[bufor+bx]      ; wczytuje litere z pierwszego argumentu
        mov     dl, byte ptr ds:[di]            ; wczytuje litere z badanej cyfry

        cmp     dh, dl                          ; jesli sie roznia to koncze porownywanie
        jne     return

        cmp     ch, cl                          ; jesli przeliterowalam cale slowo to znalazlam cyfre
        je      founded

        inc     ch                              ; zwiekszam licznik petli
        inc     bx                              ; zwiekszam wskaznik na input
        inc     di                              ; zwiekszam wskaznik na badana cyfre
    jmp compare_loop

    return:
        ret

    founded:
        inc     di
        inc     di                              ; ustawiam di na wartosc liczbowa
        mov     al, byte ptr ds:[di]            ; wczytuje do al wartosc liczbowa
        mov     byte ptr ds:[arg_1], al         ; wczytuje wartosc argumentu
        jmp     find_second_arg                 ; przechodze do szukania drugiego argumentu


match_second_argument:
    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[arg_2+2]           ; wczytuje koniec argumentu
    mov     ah, byte ptr ds:[arg_2+1]           ; wczytuje poczatek argumentu
    sub     al, ah                              ; licze dlugosc argumentu 2

    mov     ah, byte ptr ds:[di]

    cmp     al, ah                              ; jesli dlugosc sie rozni to nie skoncz porownywanie
    jne     return_2

    mov     cl, al                              ; zapisuje dlugosc slowa

    inc     di                                  ; di przesuwam na pierwszy znak parametru

    mov     bx, 2                               ; bx jako znacznik na pierwszy znak arg2 w buforze
    mov     bh, 0
    add     bl, byte ptr ds:[arg_2+1]

    mov     ch, 1                               ; ustawiam licznik petli

    compare_loop_2:
        mov     dh, byte ptr ds:[bufor+bx]      ; wczytuje litere z drugiego argumentu
        mov     dl, byte ptr ds:[di]            ; wczytuje litere z badanej cyfry

        cmp     dh, dl                          ; jesli sie roznia to koncze porownywanie
        jne     return_2

        cmp     ch, cl                          ; jesli przeliterowalam cale slowo to znalazlam cyfre
        je      founded_2

        inc     ch                              ; zwiekszam licznik petli
        inc     bx                              ; zwiekszam wskaznik na input
        inc     di                              ; zwiekszam wskaznik na badana cyfre
    jmp compare_loop_2

    return_2:
        ret

    founded_2:
        inc     di
        inc     di                              ; ustawiam di na wartosc liczbowa
        mov     al, byte ptr ds:[di]            ; wczytuje do al wartosc liczbowa
        mov     byte ptr ds:[arg_2], al         ; wczytuje wartosc argumentu
        jmp     find_operator                   ; przechodze do zanalezienia operatora


match_operator_plus:
    ; sprawdzam czy operator to plus

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; wpisuje koniec operatora
    mov     ah, byte ptr ds:[operator + 1]      ; wpisuje poczatek operatora
    sub     al, ah                              ; zdobywam dlugosc

    mov     ah, byte ptr ds:[di]                ; wpisuje do ah dlugosc badanego slowa

    cmp     al, ah                              ; jesli dlugosc sie rozni to nie skoncz porownywanie
    jne     return_pl

    mov     cl, al                              ; zapisuje dlugosc slowa

    inc     di                                  ; di przesuwam na pierwszy znak parametru

    mov     bx, 2                               ; bx jako znacznik na pierwszy znak arg2 w buforze
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; ustawiam licznik petli

    compare_loop_plus:
        mov     dh, byte ptr ds:[bufor+bx]      ; wczytuje litere z operatora
        mov     dl, byte ptr ds:[di]            ; wczytuje litere z badanego operatora

        cmp     dh, dl                          ; jesli sie roznia to koncze porownywanie
        jne     return_pl

        cmp     ch, cl                          ; jesli przeliterowalam cale slowo to znalazlam operator
        je      plus_founded

        inc     ch                              ; zwiekszam licznik petli
        inc     bx                              ; zwiekszam wskaznik na input
        inc     di                              ; zwiekszam wskaznik na badany operator
    jmp compare_loop_plus

    return_pl:
        ret

    plus_founded:
        jmp     add_arguments                   ; skoro operator to plus to przechodze do dodawania argumentow


match_operator_minus:
    ; sprawdzam czy operator to minus

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; wpisuje koniec operatora
    mov     ah, byte ptr ds:[operator + 1]      ; wpisuje poczatek operatora
    sub     al, ah                              ; zdobywam dlugosc

    mov     ah, byte ptr ds:[di]                ; wpisuje do ah dlugosc badanego slowa

    cmp     al, ah                              ; jesli dlugosc sie rozni to nie skoncz porownywanie
    jne     return_mi

    mov     cl, al                              ; zapisuje dlugosc slowa

    inc     di                                  ; di przesuwam na pierwszy znak parametru

    mov     bx, 2                               ; bx jako znacznik na pierwszy znak arg2 w buforze
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; ustawiam licznik petli

    compare_loop_minus:
        mov     dh, byte ptr ds:[bufor+bx]      ; wczytuje litere z operatora
        mov     dl, byte ptr ds:[di]            ; wczytuje litere z badanego operatora

        cmp     dh, dl                          ; jesli sie roznia to koncze porownywanie
        jne     return_mi

        cmp     ch, cl                          ; jesli przeliterowalam cale slowo to znalazlam operator
        je      minus_founded   

        inc     ch                              ; zwiekszam licznik petli
        inc     bx                              ; zwiekszam wskaznik na input
        inc     di                              ; zwiekszam wskaznik na badany operator
    jmp compare_loop_minus

    return_mi:
        ret

    minus_founded:
        jmp     substract_arguments             ; skoro operator to minus to przechodze do odejmowania argumentow


match_operator_multiply:
    ; sprawdzam czy operator to mnozenie

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; wpisuje koniec operatora
    mov     ah, byte ptr ds:[operator + 1]      ; wpisuje poczatek operatora
    sub     al, ah                              ; zdobywam dlugosc

    mov     ah, byte ptr ds:[di]                ; wpisuje do ah dlugosc badanego slowa

    cmp     al, ah                              ; jesli dlugosc sie rozni to nie skoncz porownywanie
    jne     return_mul

    mov     cl, al                              ; zapisuje dlugosc slowa

    inc     di                                  ; di przesuwam na pierwszy znak parametru

    mov     bx, 2                               ; bx jako znacznik na pierwszy znak arg2 w buforze
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; ustawiam licznik petli

    compare_loop_mul:
        mov     dh, byte ptr ds:[bufor+bx]      ; wczytuje litere z operatora
        mov     dl, byte ptr ds:[di]            ; wczytuje litere z badanego operatora

        cmp     dh, dl                          ; jesli sie roznia to koncze porownywanie
        jne     return_mul

        cmp     ch, cl                          ; jesli przeliterowalam cale slowo to znalazlam operator
        je      multiply_founded

        inc     ch                              ; zwiekszam licznik petli
        inc     bx                              ; zwiekszam wskaznik na input
        inc     di                              ; zwiekszam wskaznik na badany operator
    jmp compare_loop_mul

    return_mul:
        ret

    multiply_founded:
        jmp     multiply_arguments              ; skoro operator to mnozenie to przechodze do mnozenia argumentow


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ponizsze funkcje odpowiadaja za pomocnicze dzialania programu
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end_program:        
    ; zakonczenie programu                           
    mov     al,0
    mov     ah,4ch 
    int     21h

throw_exception_1:
    ; zle dane wejsciowe
    mov     dx,offset error1
    call    print
    jmp     end_program

print:
    ; printowanie tego czego chcemy
    mov ax,seg data
    mov ds,ax
    mov ah,9
    int 21h
    ret

code ends

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

stack_ segment stack
        dw      300 dup(?)
wstack  dw      ?
stack_ ends

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end main
