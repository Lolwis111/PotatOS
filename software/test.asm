%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

value dq 12345.6789
mult dd 10000000
integerPart dd 0x00000000
decimalPart dd 0x00000000

fpuControlWord dw 0x0000

start:
    ;print NEWLINE

    ;fld qword [value] ; load double
    
    ;fstcw word [fpuControlWord] ; store control word
    
    ;push word [fpuControlWord]  ; save control word
    
    ;or word [fpuControlWord], 0000_1100b ; set rounding to trunc
    
    ;fldcw word [fpuControlWord] ; load new control world
    
    ;frndint ; round double to integer
    
    ;fistp dword [integerPart] ; save integer
    
    ;pop word [fpuControlWord] ; get old control word
    
    ;fldcw word [fpuControlWord] ; load old control word
    
    ;fld qword [value] ; load double
    ;fisub dword [integerPart] ; st0 = st0 - integer
    
    ;fimul dword [mult] ; st0 = st0 * mult
    
    ;frndint ; round to integer
    
    ;fistp dword [decimalPart] ; save integer
    
    ;ltostr string, dword [integerPart]
    ;print string

    ;print NEWLINE
    
    ;ltostr string, dword [decimalPart]
    ;print string
    
    print NEWLINE

    EXIT EXIT_SUCCESS
    
string db 0x00
