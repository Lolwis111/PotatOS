	.file	"console.c"
	.text
	.align 16
	.globl	getCursorPosition
	.type	getCursorPosition, @function
getCursorPosition:
	pushl	%ebp
	xorl	%edx, %edx
	movl	%esp, %ebp
	movb	screenX, %dl
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	xorl	%edx, %edx
	movb	screenY, %dl
	movl	%edx, (%eax)
	popl	%ebp
	ret
	.size	getCursorPosition, .-getCursorPosition
	.align 16
	.globl	setCursorPosition
	.type	setCursorPosition, @function
setCursorPosition:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	cmpl	$79, %edx
	jle	.L5
	movl	$79, %edx
	cmpl	$24, %eax
	jle	.L7
.L10:
	movl	$24, %eax
.L8:
	movb	%al, screenY
	leal	(%eax,%eax,4), %eax
	sall	$4, %eax
	movb	%dl, screenX
	leal	(%eax,%edx), %ebx
	pushl	%eax
	pushl	%eax
	pushl	$15
	pushl	$980
	call	outportb
	popl	%edx
	xorl	%eax, %eax
	popl	%ecx
	movb	%bl, %al
	shrw	$8, %bx
	pushl	%eax
	pushl	$981
	call	outportb
	popl	%eax
	andl	$65535, %ebx
	popl	%edx
	pushl	$14
	pushl	$980
	call	outportb
	movl	%ebx, 12(%ebp)
	movl	$981, 8(%ebp)
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	jmp	outportb
	.align 16
.L5:
	movl	%edx, %ecx
	xorl	$-1, %ecx
	sarl	$31, %ecx
	andl	%ecx, %edx
	cmpl	$24, %eax
	jg	.L10
.L7:
	movl	%eax, %ecx
	xorl	$-1, %ecx
	sarl	$31, %ecx
	andl	%ecx, %eax
	jmp	.L8
	.size	setCursorPosition, .-setCursorPosition
	.align 16
	.globl	putchar
	.type	putchar, @function
putchar:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %esi
	movb	screenY, %al
	movb	screenX, %cl
	cmpb	$10, %dl
	je	.L12
	cmpb	$13, %dl
	jne	.L13
	movb	$0, screenX
.L14:
	cmpb	$23, %al
	ja	.L23
.L11:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L12:
	incl	%eax
	movb	%al, screenY
.L15:
	cmpb	$80, %cl
	jne	.L14
	incl	%eax
	movb	$0, screenX
	movb	%al, screenY
	cmpb	$23, %al
	jbe	.L11
.L23:
	pushl	%eax
	pushl	%eax
	xorl	%eax, %eax
	pushl	$23
	movb	screenX, %al
	pushl	%eax
	call	setCursorPosition
	addl	$16, %esp
	movl	$753824, %eax
	.align 16
.L17:
	movb	(%eax), %cl
	incl	%eax
	movb	%cl, -161(%eax)
	cmpl	$757664, %eax
	jne	.L17
	movl	$757504, %eax
	.align 16
.L18:
	movl	%eax, %edx
	movw	$1824, (%eax)
	addl	$2, %eax
	cmpl	$757662, %edx
	jne	.L18
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L13:
	xorl	%ebx, %ebx
	movl	%ecx, %edi
	movb	%al, %bl
	andl	$255, %edi
	incl	%ecx
	leal	(%ebx,%ebx,4), %ebx
	movb	%cl, screenX
	sall	$4, %ebx
	addl	%edi, %ebx
	addl	%ebx, %ebx
	movb	%dl, 753664(%ebx)
	movl	%esi, %edx
	movb	%dl, 753665(%ebx)
	jmp	.L15
	.size	putchar, .-putchar
	.align 16
	.globl	printstring
	.type	printstring, @function
printstring:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	xorl	%esi, %esi
	movl	8(%ebp), %ebx
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L25
	.align 16
.L26:
	pushl	%edx
	incl	%esi
	pushl	%edx
	pushl	$7
	pushl	%eax
	call	putchar
	movsbl	(%ebx,%esi), %eax
	addl	$16, %esp
	testb	%al, %al
	jne	.L26
.L25:
	pushl	%eax
	pushl	%eax
	xorl	%eax, %eax
	movb	screenY, %al
	pushl	%eax
	xorl	%eax, %eax
	movb	screenX, %al
	pushl	%eax
	call	setCursorPosition
	leal	-8(%ebp), %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	printstring, .-printstring
	.local	screenY
	.comm	screenY,1,1
	.local	screenX
	.comm	screenX,1,1
	.ident	"GCC: (GNU) 11.5.0"
