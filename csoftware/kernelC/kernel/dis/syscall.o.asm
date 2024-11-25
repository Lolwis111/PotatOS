	.file	"syscall.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Systemcall\r\n\n"
	.text
	.align 16
	.globl	syscall
	.type	syscall, @function
syscall:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	pushl	$.LC0
	cld
	call	printk
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	syscall, .-syscall
	.ident	"GCC: (GNU) 11.5.0"
