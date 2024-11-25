	.file	"string.c"
	.text
	.align 16
	.globl	strcmp
	.type	strcmp, @function
strcmp:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %ecx
	movl	12(%ebp), %edx
	movb	(%ecx), %al
	testb	%al, %al
	jne	.L2
	jmp	.L5
	.align 16
.L4:
	movb	1(%ecx), %al
	incl	%ecx
	incl	%edx
	testb	%al, %al
	je	.L5
.L2:
	cmpb	%al, (%edx)
	je	.L4
	xorl	%ecx, %ecx
	andl	$255, %eax
	movb	(%edx), %cl
	popl	%ebp
	movl	%ecx, %edx
	subl	%edx, %eax
	ret
	.align 16
.L5:
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	movb	(%edx), %cl
	popl	%ebp
	movl	%ecx, %edx
	subl	%edx, %eax
	ret
	.size	strcmp, .-strcmp
	.align 16
	.globl	strncmp
	.type	strncmp, @function
strncmp:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	16(%ebp), %eax
	movl	12(%ebp), %edx
	movl	8(%ebp), %ebx
	testl	%eax, %eax
	leal	(%edx,%eax), %esi
	jne	.L10
	jmp	.L9
	.align 16
.L21:
	cmpb	%cl, %al
	jne	.L12
	incl	%edx
	incl	%ebx
	cmpl	%esi, %edx
	je	.L15
.L10:
	movb	(%ebx), %al
	movb	(%edx), %cl
	testb	%al, %al
	jne	.L21
.L12:
	andl	$255, %eax
	andl	$255, %ecx
	subl	%ecx, %eax
.L9:
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L15:
	popl	%ebx
	xorl	%eax, %eax
	popl	%esi
	popl	%ebp
	ret
	.size	strncmp, .-strncmp
	.align 16
	.globl	strlen
	.type	strlen, @function
strlen:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	cmpb	$0, (%edx)
	je	.L22
	.align 16
.L24:
	incl	%eax
	cmpb	$0, (%edx,%eax)
	jne	.L24
.L22:
	popl	%ebp
	ret
	.size	strlen, .-strlen
	.align 16
	.globl	strcpy
	.type	strcpy, @function
strcpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	12(%ebp), %ebx
	movl	8(%ebp), %ecx
	movb	(%ebx), %al
	movb	%al, (%ecx)
	testb	%al, %al
	je	.L29
	xorl	%eax, %eax
	.align 16
.L30:
	incl	%eax
	movb	(%ebx,%eax), %dl
	movb	%dl, (%ecx,%eax)
	testb	%dl, %dl
	jne	.L30
.L29:
	popl	%ebx
	movl	%ecx, %eax
	popl	%ebp
	ret
	.size	strcpy, .-strcpy
	.align 16
	.globl	strcat
	.type	strcat, @function
strcat:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %esi
	movl	12(%ebp), %ebx
	movl	%esi, %eax
	cmpb	$0, (%esi)
	je	.L37
	.align 16
.L38:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L38
.L37:
	movb	(%ebx), %dl
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L39
	xorl	%edx, %edx
	.align 16
.L40:
	incl	%edx
	movb	(%ebx,%edx), %cl
	movb	%cl, (%eax,%edx)
	testb	%cl, %cl
	jne	.L40
.L39:
	popl	%ebx
	movl	%esi, %eax
	popl	%esi
	popl	%ebp
	ret
	.size	strcat, .-strcat
	.align 16
	.globl	memcmp
	.type	memcmp, @function
memcmp:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	16(%ebp), %ecx
	testl	%ecx, %ecx
	je	.L51
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	addl	%eax, %ecx
	jmp	.L50
	.align 16
.L56:
	ja	.L53
	incl	%eax
	incl	%edx
	cmpl	%ecx, %eax
	je	.L51
.L50:
	movb	(%edx), %bl
	cmpb	%bl, (%eax)
	jnb	.L56
	popl	%ebx
	orl	$-1, %eax
	popl	%ebp
	ret
	.align 16
.L51:
	popl	%ebx
	xorl	%eax, %eax
	popl	%ebp
	ret
	.align 16
.L53:
	popl	%ebx
	movl	$1, %eax
	popl	%ebp
	ret
	.size	memcmp, .-memcmp
	.align 16
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	16(%ebp), %ebx
	movl	8(%ebp), %esi
	testl	%ebx, %ebx
	je	.L58
	movl	12(%ebp), %edx
	movl	%esi, %ecx
	addl	%edx, %ebx
	.align 16
.L59:
	movb	(%edx), %al
	incl	%edx
	movb	%al, (%ecx)
	incl	%ecx
	cmpl	%ebx, %edx
	jne	.L59
.L58:
	popl	%ebx
	movl	%esi, %eax
	popl	%esi
	popl	%ebp
	ret
	.size	memcpy, .-memcpy
	.align 16
	.globl	memmove
	.type	memmove, @function
memmove:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	12(%ebp), %edx
	movl	8(%ebp), %ebx
	movl	16(%ebp), %eax
	cmpl	%ebx, %edx
	ja	.L66
	testl	%eax, %eax
	je	.L68
	.align 16
.L67:
	decl	%eax
	movb	(%edx,%eax), %cl
	movb	%cl, (%ebx,%eax)
	jne	.L67
.L68:
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L66:
	testl	%eax, %eax
	je	.L68
	movl	%ebx, %ecx
	leal	(%eax,%edx), %esi
	.align 16
.L69:
	movb	(%edx), %al
	incl	%edx
	movb	%al, (%ecx)
	incl	%ecx
	cmpl	%esi, %edx
	jne	.L69
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	memmove, .-memmove
	.align 16
	.globl	memset
	.type	memset, @function
memset:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	16(%ebp), %edx
	movl	8(%ebp), %ebx
	movb	12(%ebp), %cl
	testl	%edx, %edx
	je	.L78
	movl	%ebx, %eax
	addl	%ebx, %edx
	.align 16
.L79:
	movb	%cl, (%eax)
	incl	%eax
	cmpl	%edx, %eax
	jne	.L79
.L78:
	movl	%ebx, %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	memset, .-memset
	.ident	"GCC: (GNU) 11.5.0"
