	.file	"ps2.c"
	.text
	.align 16
	.globl	sendPS2Command
	.type	sendPS2Command, @function
sendPS2Command:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edx
	movl	8(%ebp), %ebx
	.align 16
.L2:
	subl	$12, %esp
	pushl	$100
	call	inportb
	addl	$16, %esp
	testb	$2, %al
	jne	.L2
	pushl	%eax
	andl	$255, %ebx
	pushl	%eax
	pushl	%ebx
	pushl	$100
	call	outportb
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	sendPS2Command, .-sendPS2Command
	.ident	"GCC: (GNU) 11.5.0"
