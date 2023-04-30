# :star2: Word Calculator in Assembly :star2:
### :sparkles: :sparkles: Program written with patience, love and pride :sparkles: :sparkles:

#### I am pleased to present my program written in assembler language which is a word calculator.
#### This calculator takes as arguments the operation to be performed and returns a word result of the operation. Unfortunately, so far only in Polish :neutral_face:



### What input does the program accept?:
The program accepts numbers from 1 to 9 (written in words), and performs plus, minus and times operations. The number required is 3 words, separated by a space and ended with an enter.

#### Examples:
Input: dwa plus trzy (two plus three) \
Output: wynikiem jest: szesc (the result is six) \
\
Input: piec minus osiem (five minus eight)\
Output: wynikiem jest: minus trzy (the result is minus three)\
\
Input: dziewiec razy dziewiec (nine times nine)\
Output: wynikiem jest: osiemdziesiat jeden (the result is eighty one)


#### Moreover, my program handles exceptions and errors such as *insufficient number of arguments* or *bad input* data:
Input: dwa plus pienc (two plus fiwe)\
Output: złe dane wejściowe :( (bad input data)\
\
Input: dwa (two)\
Output: za mala liczba argumentow (not enough arguments)

### How to run?
*for Linux OS*
1. Install dosbox:
    ```bash
    # For Debian/Ubuntu-based systems:
    sudo apt install dosbox
    # For Fedora/RHEL/CentOS systems:
    sudo dnf install dosbox
    # For Arch-based systems:
    sudo pacman -S dosbox
2. Run dosbox
    ```bash
    dosbox
    ```
3. Mount C in *word-calculator-asm* directory:
    ```bash
    Z:\> mount c <path-to-directory>
    Z:\> c:
    ```
4. Do this:
    ```bash
    C:\> masm calc;
    C:\> link calc;
    C:\> calc
    ```
5. Now you can introduce your equation :full_moon_with_face:
