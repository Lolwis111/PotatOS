	.file	"dma.c"
	.text
	.align 16
	.globl	initalizeFloppyDMA
	.type	initalizeFloppyDMA, @function
initalizeFloppyDMA:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$6
	pushl	$10
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$255
	pushl	$12
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$0
	pushl	$4
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$16
	pushl	$4
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$255
	pushl	$12
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$255
	pushl	$5
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$35
	pushl	$5
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$129
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$2
	pushl	$10
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initalizeFloppyDMA, .-initalizeFloppyDMA
	.align 16
	.globl	initalizeFloppyWrite
	.type	initalizeFloppyWrite, @function
initalizeFloppyWrite:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$6
	pushl	$10
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$90
	pushl	$11
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$2
	pushl	$10
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initalizeFloppyWrite, .-initalizeFloppyWrite
	.align 16
	.globl	initalizeFloppyRead
	.type	initalizeFloppyRead, @function
initalizeFloppyRead:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$6
	pushl	$10
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$86
	pushl	$11
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$2
	pushl	$10
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initalizeFloppyRead, .-initalizeFloppyRead
	.ident	"GCC: (GNU) 11.5.0"
