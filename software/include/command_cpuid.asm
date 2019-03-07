show_cpuid_features:
    mov eax, 1
    cpuid
    push ecx
    call testEDX
    pop ecx
    call testECX
    ret

testECX:
    test ecx, 1
    je .L1
    push ecx
    PRINT .sse3
    pop ecx
.L1:
    test ecx, 2
    je .L2
    push ecx
    PRINT ._pclmulqdq
    pop ecx
.L2:
    test ecx, 4
    je .L3
    push ecx
    PRINT .dtes64
    pop ecx
.L3:
    test ecx, 8
    je .L4
    push ecx
    PRINT .monitorS
    pop ecx
.L4:
    test ecx, 0x10
    je .L5
    push ecx
    PRINT .dscpl
    pop ecx
.L5:
    test ecx, 0x20
    je .L6
    push ecx
    PRINT .vmx
    pop ecx
.L6:
    test ecx, 0x40
    je .L7
    push ecx
    PRINT .smx
    pop ecx
.L7:
    test ecx, 0x80
    je .L8
    push ecx
    PRINT .est
    pop ecx
.L8:
    test ecx, 0x100
    je .L9
    push ecx
    PRINT .tm2
    pop ecx
.L9:
    test ecx, 0x200
    je .L10
    push ecx
    PRINT .ssse3
    pop ecx
.L10:
    test ecx, 0x400
    je .L11
    push ecx
    PRINT .cnxtid
    pop ecx
.L11:
    test ecx, 0x800
    je .L12
    push ecx
    PRINT .sdbg
    pop ecx
.L12:
    test ecx, 0x1000
    je .L13
    push ecx
    PRINT .fma
    pop ecx
.L13:
    test ecx, 0x2000
    je .L14
    push ecx
    PRINT .cx16
    pop ecx
.L14:
    test ecx, 0x4000
    je .L15
    push ecx
    PRINT .xtpr
    pop ecx
.L15:
    test ecx, 0x8000
    je .L16
    push ecx
    PRINT .pdcm
    pop ecx
.L16:
    test ecx, 0x20000
    je .L17
    push ecx
    PRINT .pcid
    pop ecx
.L17:
    test ecx, 0x40000
    je .L18
    push ecx
    PRINT .dca
    pop ecx
.L18:
    test ecx, 0x80000
    je .L19
    push ecx
    PRINT .sse41
    pop ecx
.L19:
    test ecx, 0x100000
    je .L20
    push ecx
    PRINT .sse42
    pop ecx
.L20:
    test ecx, 0x200000
    je .L21
    push ecx
    PRINT .x2apic
    pop ecx
.L21:
    test ecx, 0x400000
    je .L22
    push ecx
    PRINT ._movbe
    pop ecx
.L22:
    test ecx, 0x800000
    je .L23
    push ecx
    PRINT ._popcnt
    pop ecx
.L23:
    test ecx, 0x1000000
    je .L24
    push ecx
    PRINT .tscdeadline
    pop ecx
.L24:
    test ecx, 0x2000000
    je .L25
    push ecx
    PRINT .aes
    pop ecx
.L25:
    test ecx, 0x4000000
    je .L26
    push ecx
    PRINT ._xsave
    pop ecx
.L26:
    test ecx, 0x8000000
    je .L27
    push ecx
    PRINT .osxsave
    pop ecx
.L27:
    test ecx, 0x10000000
    je .L28
    push ecx
    PRINT .avx
    pop ecx
.L28:
    test ecx, 0x20000000
    je .L29
    push ecx
    PRINT .f16c
    pop ecx
.L29:
    test ecx, 0x40000000
    je .L30
    push ecx
    PRINT .rdrnd
    pop ecx
.L30:
    ret
.sse3 db "sse3 ", 0x00 ; bit 0
._pclmulqdq db "pclmulqdq ", 0x00 ; bit 1
.dtes64 db "dtes64 ", 0x00   ; bit 2
.monitorS db "monitor ", 0x00 ; bit 3
.dscpl db "ds-cpl ", 0x00    ; bit 4
.vmx db "vmx ", 0x00         ; bit 5
.smx db "smx ", 0x00         ; bit 6
.est db "est ", 0x00         ; bit 7
.tm2 db "tm2 ", 0x00         ; bit 8
.ssse3 db "ssse3 ", 0x00     ; bit 9
.cnxtid db "cnxt-id ", 0x00  ; bit 10
.sdbg db "sdbg ", 0x00       ; bit 11
.fma db "fma ", 0x00         ; bit 12
.cx16 db "cx16 ", 0x00       ; bit 13
.xtpr db "xtpr ", 0x00       ; bit 14
.pdcm db "pdcm ", 0x00       ; bit 15
.pcid db "pcid ", 0x00       ; bit 17
.dca db "dca ", 0x00         ; bit 18
.sse41 db "sse4.1 ", 0x00    ; bit 19
.sse42 db "sse4.2 ", 0x00    ; bit 20
.x2apic db "x2apic", 0x00    ; bit 21
._movbe db "movbe ", 0x00     ; bit 22
._popcnt db "popcnt ", 0x00   ; bit 23
.tscdeadline db "tsc ", 0x00         ; bit 24
.aes db "aes ", 0x00         ; bit 25
._xsave db "xsave ", 0x00     ; bit 26
.osxsave db "osxsave", 0x00  ; bit 27
.avx db "avx ", 0x00         ; bit 28
.f16c db "f16c ", 0x00       ; bit 29
.rdrnd db "rdrnd ", 0x00     ; bit 30

testEDX:
    ; EDX features
    test edx, 1
    je .L1
    push edx
    PRINT .fpu
    pop edx
.L1:
    test edx, 2
    je .L2
    push edx
    PRINT .vme
    pop edx
.L2:
    test edx, 4
    je .L3
    push edx
    PRINT .de
    pop edx
.L3:
    test edx, 8
    je .L4
    push edx
    PRINT .pse
    pop edx
.L4: 
    test edx, 0x10
    je .L5
    push edx
    PRINT .tsc
    pop edx
.L5:
    test edx, 0x20
    je .L6
    push edx
    PRINT .msr
    pop edx
.L6:
    test edx, 0x40
    je .L7
    push edx
    PRINT .pae
    pop edx
.L7:
    test edx, 0x80
    je .L8
    push edx
    PRINT .mce
    pop edx
.L8:
    test edx, 0x100
    je .L9
    push edx
    PRINT .cx8
    pop edx
.L9:
    test edx, 0x200
    je .L10
    push edx
    PRINT .apic
    pop edx
.L10:
    test edx, 0x400
    je .L11
    push edx
    PRINT .sep
    pop edx
.L11:
    test edx, 0x1000
    je .L12
    push edx
    PRINT .mtrr
    pop edx
.L12:
    test edx, 0x2000
    je .L13
    push edx
    PRINT .pge
    pop edx
.L13:
    test edx, 0x4000
    je .L14
    push edx
    PRINT .mca
    pop edx
.L14:
    test edx, 0x8000
    je .L15
    push edx
    PRINT .cmov
    pop edx
.L15:
    test edx, 0x10000
    je .L16
    push edx
    PRINT .pat
    pop edx
.L16:
    test edx, 0x20000
    je .L17
    push edx
    PRINT .pse36
    pop edx
.L17:
    test edx, 0x40000
    je .L18
    push edx
    PRINT .psn
    pop edx
.L18:
    test edx, 0x80000
    je .L19
    push edx
    PRINT .clfsh
    pop edx
.L19:
    test edx, 0x100000
    je .L20
    push edx
    PRINT .ds
    pop edx
.L20:
    test edx, 0x200000
    je .L21
    push edx
    PRINT .acpi
    pop edx
.L21:
    test edx, 0x400000
    je .L22
    push edx
    PRINT .mmx
    pop edx
.L22:
    test edx, 0x800000
    je .L23
    push edx
    PRINT .fxsr
    pop edx
.L23:
    test edx, 0x1000000
    je .L24
    push edx
    PRINT .sse
    pop edx
.L24:
    test edx, 0x2000000
    je .L25
    push edx
    PRINT .sse2
    pop edx
.L25:
    test edx, 0x4000000
    je .L26
    push edx
    PRINT .ss
    pop edx
.L26:
    test edx, 0x8000000
    je .L27
    push edx
    PRINT .htt
    pop edx
.L27:
    test edx, 0x10000000
    je .L28
    push edx
    PRINT .tm
    pop edx
.L28:
    test edx, 0x20000000
    je .L29
    push edx
    PRINT .ia64
    pop edx
.L29:
    test edx, 0x40000000
    je .L30
    push edx
    PRINT .pbe
    pop edx
.L30:
    ret
.fpu db "x87 ", 0x00     ; bit 0
.vme db "vme ", 0x00     ; bit 1
.de db  "de ", 0x00      ; bit 2
.pse db "pse ", 0x00     ; bit 3
.tsc db "tsc ", 0x00     ; bit 4
.msr db "msr ", 0x00     ; bit 5
.pae db "pae ", 0x00     ; bit 6
.mce db "mce ", 0x00     ; bit 7
.cx8 db "cx8 ", 0x00     ; bit 8
.apic db "apic ", 0x00   ; bit 9
.sep db "sep ", 0x00     ; bit 11
.mtrr db "mtrr ", 0x00   ; bit 12
.pge db "pge ", 0x00     ; bit 13
.mca db "mca ", 0x00     ; bit 14
.cmov db "cmov ", 0x00   ; bit 15
.pat db "pat ", 0x00     ; bit 16
.pse36 db "pse36 ", 0x00 ; bit 17
.psn db "psn ", 0x00     ; bit 18
.clfsh db "clfsh ", 0x00 ; bit 19
.ds db "ds ", 0x00       ; bit 21
.acpi db "acpi ", 0x00   ; bit 22
.mmx db "mmx ", 0x00     ; bit 23
.fxsr db "fsxr ", 0x00   ; bit 24
.sse db "sse ", 0x00     ; bit 25
.sse2 db "sse2 ", 0x00   ; bit 26
.ss db "ss ", 0x00       ; bit 27
.htt db "htt ", 0x00     ; bit 28
.tm db "tm ", 0x00       ; bit 29
.ia64 db "ia64 ", 0x00   ; bit 30
.pbe db "pbe ", 0x00     ; bit 31


