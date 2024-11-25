	.file	"userland.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"0x%p\r\n"
	.text
	.align 16
	.globl	initGDT
	.type	initGDT, @function
initGDT:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	$48
	pushl	$0
	pushl	$the_gdt
	call	memset
	xorl	%edx, %edx
	addl	$12, %esp
	movb	the_gdt+12, %dl
	movl	$tss_entry, %eax
	orl	$14653952, %edx
	pushl	$104
	movl	%edx, the_gdt+12
	xorl	%edx, %edx
	movb	the_gdt+28, %dl
	pushl	$0
	orl	$14678528, %edx
	pushl	$tss_entry
	movl	%edx, the_gdt+28
	xorl	%edx, %edx
	movb	the_gdt+36, %dl
	movw	%ax, the_gdt+42
	orl	$14676480, %edx
	movw	$-1, the_gdt+8
	movl	%edx, the_gdt+36
	movl	%eax, %edx
	shrl	$16, %edx
	movw	$-1, the_gdt+16
	shrl	$24, %eax
	movb	%dl, the_gdt+44
	movw	$-8302, the_gdt+21
	movw	$-1, the_gdt+24
	movw	$-1, the_gdt+32
	movw	$104, the_gdt+40
	movb	$-119, the_gdt+45
	movb	$0, the_gdt+46
	movb	%al, the_gdt+47
	call	memset
	popl	%eax
	movl	$16, tss_entry+8
	popl	%edx
	movl	$589824, tss_entry+4
	pushl	$the_gdt
	pushl	$48
	call	load_gdt
	call	load_tss
	popl	%ecx
	popl	%eax
	pushl	$the_gdt
	pushl	$.LC0
	call	printk
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initGDT, .-initGDT
	.align 16
	.globl	userland_function
	.type	userland_function, @function
userland_function:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	.align 16
.L5:
	call	int80
	jmp	.L5
	.size	userland_function, .-userland_function
	.globl	the_gdt
	.section	.bss
	.align 32
	.type	the_gdt, @object
	.size	the_gdt, 48
the_gdt:
	.zero	48
	.globl	tss_entry
	.align 32
	.type	tss_entry, @object
	.size	tss_entry, 104
tss_entry:
	.zero	104
	.ident	"GCC: (GNU) 11.5.0"
