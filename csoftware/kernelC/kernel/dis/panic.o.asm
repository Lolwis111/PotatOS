	.file	"panic.c"
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"\r\n\n -- KERNEL PANIC --\r\n\n%s\r\n\nSYSTEM HALT."
	.text
	.align 16
	.globl	panic
	.type	panic, @function
panic:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	pushl	%eax
	pushl	$.LC0
	call	printk
	call	cli
	call	hlt
	addl	$16, %esp
.L2:
	jmp	.L2
	.size	panic, .-panic
	.ident	"GCC: (GNU) 11.5.0"
