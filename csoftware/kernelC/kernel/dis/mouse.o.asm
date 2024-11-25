	.file	"mouse.c"
	.text
	.align 16
	.globl	initMouse
	.type	initMouse, @function
initMouse:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
	pushl	$167
	call	sendPS2Command
	movl	$96, (%esp)
	call	inportb
	movl	$168, (%esp)
	call	sendPS2Command
	movl	$32, (%esp)
	call	sendPS2Command
	movl	$96, (%esp)
	call	inportb
	movb	%al, %bl
	movl	$96, (%esp)
	orl	$2, %ebx
	call	sendPS2Command
	andl	$255, %ebx
	movl	%ebx, (%esp)
	call	sendPS2Command
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initMouse, .-initMouse
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"m"
	.text
	.align 16
	.globl	mouse_irq
	.type	mouse_irq, @function
mouse_irq:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	pushl	$96
	cld
	call	inportb
	movl	$.LC0, (%esp)
	call	printk
	movl	$12, (%esp)
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	mouse_irq, .-mouse_irq
	.ident	"GCC: (GNU) 11.5.0"
