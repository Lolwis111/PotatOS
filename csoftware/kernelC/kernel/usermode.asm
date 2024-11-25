[bits 32]

global jump_usermode
extern userland_function
jump_usermode:
	mov ax, (4 * 8) | 3 ; ring 3 data with bottom 2 bits set for ring 3
	mov ds, ax
	mov es, ax 
	mov fs, ax 
	mov gs, ax ; SS is handled by iret

	; set up the stack frame iret expects
	mov eax, esp
	push (4 * 8) | 3 ; data selector
	push eax ; current esp
	pushf ; eflags
	push (3 * 8) | 3 ; code selector (ring 3 code with bottom 2 bits set for ring 3)
	push userland_function ; instruction address to return to
	iret

; C declaration: void load_tss(void);
global load_tss
load_tss:
	mov ax, (5 * 8) | 0 ; fifth 8-byte selector, symbolically OR-ed with 0 to set the RPL (requested privilege level).
	
	ltr ax

	ret

; void load_gdt(uint16_t, struct gdt_entry_bits*);
global load_gdt
load_gdt:
	push ebp
	mov ebp, esp
	
	mov ax, word [ebp+8]
	mov word [.storage], ax

	mov ebx, [ebp+12]
	mov dword [.storage+2], ebx

	lgdt [.storage]

	jmp 0x08:.segementReload
.segementReload:

	mov ax, 0x10
	mov ds, ax
	mov ss, ax
	mov fs, ax
	mov gs, ax
	mov es, ax

	leave
	ret
.storage:
	dw 0
	dd 0

global store_gdt
store_gdt:
	sgdt [.storage]
	mov eax, dword [.storage+2]
	ret
.storage:
	dw 0
	dd 0