	.file	"fs.c"
	.text
	.align 16
	.globl	readFileSystem
	.type	readFileSystem, @function
readFileSystem:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$0
	pushl	$0
	call	floppyRead
	addl	$12, %esp
	movl	8(%ebp), %eax
	pushl	$36
	pushl	$4096
	pushl	%eax
	call	memcpy
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	readFileSystem, .-readFileSystem
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%10s%5s%8d\r\n"
	.text
	.align 16
	.globl	readRoot
	.type	readRoot, @function
readRoot:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	xorl	%edx, %edx
	pushl	%ebx
	subl	$604, %esp
	movl	8(%ebp), %ecx
	movw	22(%ecx), %dx
	movb	16(%ecx), %al
	imull	%edx, %eax
	xorl	%edx, %edx
	movw	14(%ecx), %dx
	addl	%edx, %eax
	movl	%eax, -604(%ebp)
	cmpw	$0, 17(%ecx)
	je	.L4
	xorl	%esi, %esi
	movl	$512, %ebx
	leal	-568(%ebp), %edi
	jmp	.L5
	.align 16
.L21:
	leal	-536(%ebp), %eax
	addl	%ebx, %eax
	addl	$32, %ebx
.L8:
	pushl	%edx
	pushl	$32
	pushl	%eax
	pushl	%edi
	call	memcpy
	movb	-568(%ebp), %al
	addl	$16, %esp
	cmpb	$-27, %al
	je	.L9
	testb	%al, %al
	je	.L4
	pushl	%eax
	leal	-593(%ebp), %eax
	pushl	$8
	pushl	%edi
	pushl	%eax
	call	memcpy
	addl	$12, %esp
	leal	-560(%ebp), %eax
	leal	-580(%ebp), %edx
	movb	$0, -585(%ebp)
	pushl	$3
	pushl	%eax
	pushl	%edx
	call	memcpy
	movb	-557(%ebp), %al
	leal	-580(%ebp), %edx
	movb	%al, -572(%ebp)
	movw	-542(%ebp), %cx
	shrb	$4, %al
	movb	$0, -577(%ebp)
	andl	$1, %eax
	movw	%cx, -571(%ebp)
	movb	%al, -569(%ebp)
	movl	-540(%ebp), %eax
	pushl	%eax
	movl	%eax, -584(%ebp)
	pushl	%edx
	leal	-593(%ebp), %eax
	pushl	%eax
	movl	$0, -576(%ebp)
	pushl	$.LC0
	call	printk
	addl	$32, %esp
.L9:
	movl	8(%ebp), %eax
	incl	%esi
	cmpw	%si, 17(%eax)
	jbe	.L4
.L5:
	movb	$0, -593(%ebp)
	cmpl	$512, %ebx
	jne	.L21
	pushl	%ecx
	movl	-604(%ebp), %ebx
	pushl	%ecx
	pushl	$0
	pushl	%ebx
	call	floppyRead
	addl	$12, %esp
	leal	-536(%ebp), %eax
	pushl	$512
	pushl	$4096
	pushl	%eax
	call	memcpy
	movl	%ebx, %eax
	addl	$16, %esp
	incl	%eax
	movl	$32, %ebx
	movl	%eax, -604(%ebp)
	leal	-536(%ebp), %eax
	jmp	.L8
	.align 16
.L4:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	readRoot, .-readRoot
	.ident	"GCC: (GNU) 11.5.0"
