; To solve the given task, I have taken the following steps:
; 1. Displayed a greeting message.
; 2. Gathered input from the user.
; 3. Obtained the length of each "part" of the input, i.e., argument 1, operator, and argument 2.
; 4. Recognized each digit and the operator.
; 5. Performed the operation after recognizing the operator.
; 6. Printed the verbal result.

assume cs:code , ds:data

data segment
    ; defines the strings displayed on the screen
    welcome     db "Enter a verbal description of the operation: ", 13, 10, "$"
    result      db 13, 10, "The result is: $"
    empt_line   db 10, 13, "$"

    ; defines the errors for incorrect input
    error1  db 13, 10, "Wrong input data, try again :( :( :( $"
    error2  db 13, 10, "Wrong number of arguments, try again $"

    ; defines a buffer for the string of characters received from the user
    bufor   db 50, ?, 100 dup("$")

    ; defines variables for the received arguments
    ; value, start, end
    arg_1    db 0, 0, 0
    arg_2    db 0, 0, 0
    operator db 0, 0, 0

    res_val  dw 0

    ; defines the data on which we will operate in the form of:
    ; variable name (offset), string length, string, numerical value of the variable
    zero        db 4, "zero$",            0
    one         db 3, "one$",             1
    two         db 3, "two$",             2
    three       db 5, "three$",           3
    four        db 4, "four$",            4
    five        db 4, "five$",            5
    six         db 3, "six$",             6
    seven       db 5, "seven$",           7
    eight       db 5, "eight$",           8
    nine        db 4, "nine$",            9
    ten         db 3, "ten$",            10
    eleven      db 6, "eleven$",         11
    twelve      db 6, "twelve$",         12
    thirteen    db 8, "thirteen$",       13
    fourteen    db 8, "fourteen$",       14
    fifteen     db 7, "fifteen$",        15
    sixteen     db 7, "sixteen$",        16
    seventen    db 9, "seventeen$",      17
    eighteen    db 8, "eighteen$",       18
    nineteen    db 8, "nineteen$",       19
    twenty      db 6, "twenty $",        20
    thirty      db 6, "thirty $",        30
    fourty      db 6, "fourty $",        40
    fifty       db 5, "fifty $",         50
    sixty       db 5, "sixty $",         60
    seventy     db 7, "seventy $",       70
    eighty      db 6, "eighty $",        80

    plus       db 4, "plus $"
    minus      db 5, "minus $"
    multiply   db 5, "times $"

data ends

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

code segment
main:
    mov     ax, seg stack_                      ; loads the stack address to the AX register
    mov     ss, ax                              ; assigns the value of the AX register to the SS register
    mov     sp, offset stack_                   ; loads the stack offset to the SP register

    ; displays a welcome message
    mov     dx, offset welcome
    call    print

    ; reads user input
    mov     ax,seg data
    mov     ds,ax
    mov     dx,offset bufor
    mov     ah,0ah
    int     21h

    ; starts searching for the beginning and end of the input
    mov     ax, seg data
    mov     ds, ax
    mov     bp, offset bufor+1                  ; adds +1 to access the "?" in the buffer (number of characters entered)
    mov     cl, byte ptr ds:[bp]                ; loads the number of entered characters into cl
    mov     ch, 1                               ; resets the iteration counter
    mov     bx, 2                               ; sets the pointer to the first character in the buffer

    ; sets the beginning of argument 1 to 0
    mov     byte ptr ds:[arg_1+1], 0

    find_first_arg_end:
        mov     dh, byte ptr ds:[bufor+bx]

        cmp     cl, ch                          ; if it is the end of the string then too few arguments were provided
        je      too_few_args_exception

        cmp     dh, 32                          ; if it is a space then mark the end of the argument
        je      set_first_arg_end

        inc     bx                              ; move the pointer further
        inc     ch                              ; increase the counter
    jmp     find_first_arg_end

    set_first_arg_end:
        dec     ch                              ; move ch to the first character before the space
        mov     bp, offset arg_1+2
        mov     byte ptr ds:[bp], ch            ; write the length of the first argument
        inc     ch

    ; set the beginning of the operator to the current number
    inc     bx                                  ; move the pointer to the next character
    mov     byte ptr ds:[operator+1], ch        ; set the beginning of the operator to the current number
    inc     ch

    find_operator_end:
        mov     dh, byte ptr ds:[bufor+bx]      ; read a character from the buffer

        cmp     cl, ch                          ; if end of string, not enough arguments
        je      too_few_args_exception

        cmp     dh, 32                          ; if it's a space, set operator end
        je      set_operator_end

        inc     bx                              ; move pointer to the next character
        inc     ch                              ; increment counter
    jmp find_operator_end

    set_operator_end:
        cmp     cl, ch                          ; if end of string, not enough arguments
        je      too_few_args_exception

        dec     ch                              ; move the pointer to the character before the space
        mov     byte ptr ds:[operator+2], ch    ; save current number as the end of the operator
        inc     ch                              ; increment ch counter

    ; set the beginning of the second argument to the current number
    inc bx                                      ; move the pointer to the next character
    mov byte ptr ds:[arg_2+1], ch               ; set the beginning of the second argument
    inc ch                                      ; increase ch

    find_second_argument_end:
        mov     dh, byte ptr ds:[bufor+bx]      ; read a character from the buffer

        cmp     cl, ch                          ; if the end of the string is reached, there are too few arguments
        je      too_few_args_exception

        jmp     continue

    too_few_args_exception:
        ; too few arguments
        mov     dx, offset error2
        call    print
        jmp     end_program

    continue:
    ; if no exception was thrown, it means we have 3 arguments,
    ; so the end of the second argument is at the end of the string:
    ; set the end of the second argument:
    mov     byte ptr ds:[arg_2+2], cl

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; below, I try to find a match for digits and operators
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    find_first_arg:
    ; finds value of the first argument

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


    call    bad_input_exception                   ; if nothing was found, throw an bad input error

    find_second_arg:
    ; finds value of the second argument

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


    call    bad_input_exception                   ; if nothing was found, throw an bad input error


    find_operator:
        mov     di, offset plus
        call    match_operator_plus

        mov     di, offset minus
        call    match_operator_minus

        mov     di, offset multiply
        call    match_operator_multiply


        call    bad_input_exception               ; if nothing was found, throw an bad input error


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; The following functions are responsible for performing the operation
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    add_arguments:
        mov     al, byte ptr ds:[arg_1]         ; store the value of the first argument in al
        add     al, byte ptr ds:[arg_2]         ; add the value of the second argument to al
        mov     ah, 0
        mov     word ptr ds:[res_val], ax       ; set the value of the result to the obtained sum

        jmp     print_solution                  ; jump to printing the result


    substract_arguments:
        mov     al, byte ptr ds:[arg_1]         ; save the value of the first argument to al
        mov     bl, byte ptr ds:[arg_2]         ; save the value of the second argument to bl
        mov     ah, 0
        mov     bh, 0
        sub     ax, bx                          ; subtract the values
        mov     word ptr ds:[res_val], ax       ; assign the obtained value to the result

        jmp     print_solution


    multiply_arguments:
        mov     ax, 0
        mov     al, byte ptr ds:[arg_1]         ; assign the value of the first argument to al
        mul     byte ptr ds:[arg_2]             ; multiply the values
        mov     word ptr ds:[res_val], ax       ; assign the obtained value to the result

        jmp     print_solution


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; the following functions are responsible for printing the result
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    print_solution:
        mov     dx, offset result               ; print "the result is: "
        call    print

        mov     dx, offset empt_line            ; print a new line
        call    print

    mov     bx, word ptr ds:[res_val]           ; move the result to bx

    cmp     bx, 0                               ; if the result is 0, print 0 and end the program
    je      print_zero

    cmp     bx, 20                              ; if the result is greater than or equal to 20, move to analyzing the tens place
    jge     print_tens

    jmp     compare_teens                       ; otherwise, check if the result is between 10-19

    print_zero:
        mov     dx, offset zero+1
        call    print
        jmp     end_program

    print_tens:
            ; by subtracting sequentially, I find the order of tens, when I find it,
            ; I print the word and move on to examining the units

            mov     dx, offset twenty+1         ; first, I assume the result is in the 20s range
            sub     bx, 20                      ; subtract 20
            cmp     bx, 0                       ; if the resulting difference is equal to 0, it means the result is 20
            je      print_tens_result           ; print "twenty"
            cmp     bx, 10                      ; if the resulting difference is less than 10, it means the result is in the 21-29 range
            jl      print_dozens                ; move on to printing

            mov     dx, offset thirty+1         ; similar to above
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
            call    print                       ; print the tens place digit
            jmp     print_units                 ; move on to print the ones place digit

        print_tens_result:
            call    print                       ; print the tens place digit (10, 20, 30 etc.)
            jmp     end_program

    compare_teens:
        cmp     bx, 10                          ; if bx is equal or greater than 10, the result is 10-19
        jge     print_teens                     ; print the teens

        jmp     compare_units                   ; if not, compare the ones place digit (the result is one digit)

    print_teens:
        ; checking one by one and if something is equal, print the result

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
        call    print                           ; prints the teen result
        jmp     end_program                     ; ends the program

    compare_units:
        cmp     bx, 0                           ; if bx is greater or equal to 0, the result is 0-9
        jge     print_units                     ; prints the units

        jmp     print_negative                  ; otherwise, the result must be -8 to -1, so we print negative

    print_negative:
        mov     dx, offset minus+1              ; prints minus
        call    print

        neg     bx                              ; converts the number to its negative equivalent
        jmp     print_units                     ; now we print the number


    print_units:
        ; checking one by one and if something is equal, print the result

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


    print_result:                               ; print result
        call print

    jmp     end_program                         ; end program


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; the following functions are responsible for matching digits and operators
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

match_first_argument:
    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[arg_1+2]           ; loads the end of the 1st argument into al
    mov     ah, byte ptr ds:[arg_1+1]           ; loads the beginning of the 1st argument into ah
    sub     al, ah                              ; calculates the length of the argument

    mov     ah, byte ptr ds:[di]                ; loads the length of the digit being examined into ah

    cmp     ah, al                              ; if the lengths are different, then do not continue checking
    jne     return

    mov     cl, al                              ; stores the length of the word in cl

    mov     bx, 2                               ; sets bx to the beginning of the digit
    mov     bh, 0
    add     bl, byte ptr ds:[arg_1+1]

    inc     di                                  ; moves the pointer to the first letter of the examined digit

    mov     ch, 1                               ; sets the loop counter

    compare_loop:
        mov     dh, byte ptr ds:[bufor+bx]      ; read a letter from the first argument
        mov     dl, byte ptr ds:[di]            ; read a letter from the examined digit

        cmp     dh, dl                          ; if they are different, end the comparison
        jne     return

        cmp     ch, cl                          ; if the whole word has been read, the digit has been found
        je      founded

        inc     ch                              ; increase the loop counter
        inc     bx                              ; increase the input pointer
        inc     di                              ; increase the pointer to the examined digit
    jmp compare_loop

    return:
        ret

    founded:
        inc     di
        inc     di                              ; set di to the numeric value
        mov     al, byte ptr ds:[di]            ; read the numeric value to al
        mov     byte ptr ds:[arg_1], al         ; read the argument value
        jmp     find_second_arg                 ; move on to finding the second argument

match_second_argument:
    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[arg_2+2]           ; load end of argument
    mov     ah, byte ptr ds:[arg_2+1]           ; load start of argument
    sub     al, ah                              ; calculate length of argument 2

    mov     ah, byte ptr ds:[di]

    cmp     al, ah                              ; if the length is different, do not finish comparing
    jne     return_2

    mov     cl, al                              ; save the length of the word

    inc     di                                  ; move di to the first character of the parameter

    mov     bx, 2                               ; bx as a marker for the first arg2 character in the buffer
    mov     bh, 0
    add     bl, byte ptr ds:[arg_2+1]

    mov     ch, 1                               ; set loop counter

    compare_loop_2:
        mov     dh, byte ptr ds:[bufor+bx]      ; load the letter from the second argument
        mov     dl, byte ptr ds:[di]            ; load the letter from the tested number

        cmp     dh, dl                          ; if they different, end the comparison
        jne     return_2

        cmp     ch, cl                          ; if I have read the entire word, I have found the number
        je      founded_2

        inc     ch                              ; increase loop counter
        inc     bx                              ; increase the pointer to the input
        inc     di                              ; increase the pointer to the tested number
    jmp compare_loop_2

    return_2:
        ret

    founded_2:
        inc     di
        inc     di                              ; set di to the numeric value
        mov     al, byte ptr ds:[di]            ; load the numeric value into al
        mov     byte ptr ds:[arg_2], al         ; load the argument value
        jmp     find_operator                   ; move on to finding the operator


match_operator_plus:
    ; checking if the operator is plus

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; write the end of the operator
    mov     ah, byte ptr ds:[operator + 1]      ; write the beginning of the operator
    sub     al, ah                              ; get the length

    mov     ah, byte ptr ds:[di]                ; write the length of the examined word to ah

    cmp     al, ah                              ; if the lengths are different, end the comparison
    jne     return_pl

    mov     cl, al                              ; store the length of the word

    inc     di                                  ; move di to the first character of the parameter

    mov     bx, 2                               ; bx as a marker on the first character of arg2 in the buffer
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; set the loop counter

    compare_loop_plus:
        mov     dh, byte ptr ds:[bufor+bx]      ; read the letter from the operator
        mov     dl, byte ptr ds:[di]            ; read the letter from the examined operator

        cmp     dh, dl                          ; if they different, end the comparison
        jne     return_pl

        cmp     ch, cl                          ; if I have iterated through the whole word, I have found the operator
        je      plus_founded

        inc     ch                              ; increase the loop counter
        inc     bx                              ; increase the pointer to the input
        inc     di                              ; increase the pointer to the examined operator
    jmp compare_loop_plus

    return_pl:
        ret

    plus_founded:
        jmp     add_arguments                   ; if the operator is plus, go to adding arguments


match_operator_minus:
    ; checking if the operator is minus

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; put the end of the operator into al
    mov     ah, byte ptr ds:[operator + 1]      ; put the beginning of the operator into ah
    sub     al, ah                              ; obtain the length of the operator

    mov     ah, byte ptr ds:[di]                ; put the length of the analyzed word into ah

    cmp     al, ah                              ; if the lengths differ, stop comparing
    jne     return_mi

    mov     cl, al                              ; store the length of the word

    inc     di                                  ; move di to the first character of the parameter

    mov     bx, 2                               ; bx as a marker on the first character of arg2 in the buffer
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; set the loop counter

    compare_loop_minus:
        mov     dh, byte ptr ds:[bufor+bx]      ; load a letter from the operator
        mov     dl, byte ptr ds:[di]            ; load a letter from the analyzed operator

        cmp     dh, dl                          ; if they differ, stop comparing
        jne     return_mi

        cmp     ch, cl                          ; if I've looped through the whole word, I found the operator
        je      minus_founded

        inc     ch                              ; increase the loop counter
        inc     bx                              ; increase the pointer to the input
        inc     di                              ; increase the pointer to the analyzed operator
    jmp compare_loop_minus

    return_mi:
        ret

    minus_founded:
        jmp     substract_arguments             ; if the operator is minus, go to subtracting arguments



match_operator_multiply:
    ; check if the operator is multiplication

    mov     ax, seg data
    mov     ds, ax

    mov     al, byte ptr ds:[operator + 2]      ; write the end of the operator
    mov     ah, byte ptr ds:[operator + 1]      ; write the beginning of the operator
    sub     al, ah                              ; get the length

    mov     ah, byte ptr ds:[di]                ; write the length of the examined word to ah

    cmp     al, ah                              ; if the length is different, do not continue the comparison
    jne     return_mul

    mov     cl, al                              ; save the length of the word

    inc     di                                  ; move di to the first character of the parameter

    mov     bx, 2                               ; bx as a marker for the first character of arg2 in the buffer
    mov     bh, 0
    add     bl, byte ptr ds:[operator+1]

    mov     ch, 1                               ; set the loop counter

    compare_loop_mul:
        mov     dh, byte ptr ds:[bufor+bx]      ; read a letter from the operator
        mov     dl, byte ptr ds:[di]            ; read a letter from the examined operator

        cmp     dh, dl                          ; if they are different, end the comparison
        jne     return_mul

        cmp     ch, cl                          ; if I have iterated over the entire word, I have found the operator
        je      multiply_founded

        inc     ch                              ; increase the loop counter
        inc     bx                              ; increase the pointer to the input
        inc     di                              ; increase the pointer to the examined operator
    jmp compare_loop_mul

    return_mul:
        ret

    multiply_founded:
        jmp     multiply_arguments              ; since the operator is multiplication, proceed to multiply the arguments



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; the following functions are responsible for auxiliary operations of the program
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end_program:
    ; end of the program
    mov al,0
    mov ah,4ch
    int 21h

bad_input_exception:
    ; incorrect input data
    mov dx,offset error1
    call print
    jmp end_program

print:
    ; printing what we want
    mov ax, seg data
    mov ds, ax
    mov ah, 9
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