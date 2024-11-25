	.file	"printk.c"
	.text
	.align 16
	.type	itoak.part.0, @function
itoak.part.0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	%ecx, %edi
	pushl	%ebx
	movl	%edx, %ebx
	subl	$12, %esp
	testl	%eax, %eax
	movl	8(%ebp), %esi
	movl	%esi, -24(%ebp)
	jns	.L13
	cmpl	$10, %ecx
	jne	.L13
	negl	%eax
	movl	$1, -20(%ebp)
.L2:
	xorl	%ecx, %ecx
	jmp	.L5
	.align 16
.L14:
	movl	%edx, %ecx
.L5:
	movl	%eax, %edx
	sarl	$31, %edx
	idivl	%edi
	cmpl	$9, %edx
	leal	48(%edx), %esi
	jle	.L4
	leal	87(%edx), %esi
.L4:
	movl	%esi, %edx
	testl	%eax, %eax
	movb	%dl, (%ebx,%ecx)
	leal	1(%ecx), %edx
	jne	.L14
	movl	%edx, %edi
	movl	%edx, -16(%ebp)
	addl	%ebx, %edi
	cmpl	$1, -20(%ebp)
	je	.L24
	movl	-24(%ebp), %edx
	testb	%dl, %dl
	jne	.L25
	movl	-16(%ebp), %edi
	testl	%ecx, %ecx
	je	.L10
	movl	%ecx, %edx
	jmp	.L11
	.align 16
.L26:
	movzbl	(%ebx,%edx), %esi
.L11:
	movb	(%ebx,%eax), %cl
	movb	%cl, -16(%ebp)
	movl	%esi, %ecx
	movb	%cl, (%ebx,%eax)
	movb	-16(%ebp), %cl
	movb	%cl, (%ebx,%edx)
	incl	%eax
	decl	%edx
	cmpl	%eax, %edx
	jg	.L26
.L10:
	movb	$0, (%ebx,%edi)
	addl	$12, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L13:
	movl	$0, -20(%ebp)
	jmp	.L2
	.align 16
.L25:
	movb	%dl, (%edi)
	movl	%edx, %esi
	leal	2(%ecx), %edi
	movl	-16(%ebp), %edx
	jmp	.L11
	.align 16
.L24:
	movb	$45, (%edi)
	movl	$45, %esi
	leal	2(%ecx), %edi
	jmp	.L11
	.size	itoak.part.0, .-itoak.part.0
	.align 16
	.globl	vsprintk
	.type	vsprintk, @function
vsprintk:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$76, %esp
	movl	8(%ebp), %esi
	movl	12(%ebp), %ebx
	testl	%esi, %esi
	je	.L28
	movl	8(%ebp), %eax
	movb	$0, (%eax)
.L28:
	movb	(%ebx), %al
	testb	%al, %al
	je	.L75
	movb	$0, -69(%ebp)
	movb	$32, -70(%ebp)
	movl	$0, -60(%ebp)
	jmp	.L71
	.align 16
.L109:
	pushl	%eax
	movl	%ebx, %esi
	pushl	%eax
	leal	-56(%ebp), %eax
	pushl	%eax
	leal	1(%ebx), %ebx
	movl	8(%ebp), %edx
	pushl	%edx
	call	strcat
	addl	$16, %esp
.L70:
	movb	1(%esi), %al
	testb	%al, %al
	je	.L107
.L71:
	cmpb	$37, %al
	je	.L108
	movl	-60(%ebp), %ecx
	movl	8(%ebp), %esi
	incl	%ecx
	movb	%al, -56(%ebp)
	movb	$0, -55(%ebp)
	movl	%ecx, -60(%ebp)
	testl	%esi, %esi
	jne	.L109
	movl	%ebx, %esi
	leal	1(%ebx), %ebx
	movb	1(%esi), %al
	testb	%al, %al
	jne	.L71
.L107:
	movl	-60(%ebp), %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L108:
	movb	1(%ebx), %al
	cmpb	$45, %al
	je	.L31
	leal	1(%ebx), %esi
	movl	$1, -76(%ebp)
	cmpb	$43, %al
	leal	1(%esi), %ebx
	je	.L33
.L112:
	cmpb	$48, %al
	je	.L34
	cmpb	$32, %al
	je	.L110
.L36:
	leal	-48(%eax), %edx
	cmpb	$9, %dl
	ja	.L37
.L113:
	xorl	%edi, %edi
	jmp	.L38
	.align 16
.L111:
	incl	%ebx
.L38:
	subl	$48, %eax
	leal	(%edi,%edi,4), %edx
	movsbl	%al, %eax
	movl	%ebx, %esi
	leal	(%eax,%edx,2), %edi
	movb	(%ebx), %al
	leal	-48(%eax), %edx
	cmpb	$9, %dl
	jbe	.L111
	cmpb	$37, %al
	je	.L39
	subl	$88, %eax
	cmpb	$32, %al
	ja	.L40
	andl	$255, %eax
	jmp	*.L42(,%eax,4)
	.section	.rodata
	.align 4
	.align 4
.L42:
	.long	.L49
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L48
	.long	.L43
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L43
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L40
	.long	.L46
	.long	.L90
	.long	.L40
	.long	.L40
	.long	.L44
	.long	.L40
	.long	.L43
	.long	.L40
	.long	.L40
	.long	.L41
	.text
	.align 16
.L43:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L53:
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L103
	movsbl	-69(%ebp), %edx
	movl	$10, %ecx
	pushl	%edx
.L104:
	leal	-56(%ebp), %edx
	call	itoak.part.0
	movl	-68(%ebp), %eax
	popl	%ecx
	movl	%eax, 16(%ebp)
	leal	-56(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L50
	.align 16
.L31:
	leal	2(%ebx), %esi
	movb	2(%ebx), %al
	movl	$-1, -76(%ebp)
	cmpb	$43, %al
	leal	1(%esi), %ebx
	jne	.L112
.L33:
	movb	1(%esi), %al
	movb	$43, -69(%ebp)
	movl	%ebx, %esi
	leal	1(%ebx), %ebx
	leal	-48(%eax), %edx
	cmpb	$9, %dl
	jbe	.L113
.L37:
	cmpb	$37, %al
	je	.L78
	subl	$88, %eax
	cmpb	$32, %al
	ja	.L72
	andl	$255, %eax
	jmp	*.L74(,%eax,4)
	.section	.rodata
	.align 4
	.align 4
.L74:
	.long	.L79
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L80
	.long	.L84
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L84
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L72
	.long	.L82
	.long	.L45
	.long	.L72
	.long	.L72
	.long	.L83
	.long	.L72
	.long	.L84
	.long	.L72
	.long	.L72
	.long	.L85
	.text
	.align 16
.L110:
	movb	1(%esi), %al
	movb	$32, -69(%ebp)
	movl	%ebx, %esi
	leal	1(%ebx), %ebx
	jmp	.L36
	.align 16
.L34:
	movb	1(%esi), %al
	movb	$48, -70(%ebp)
	movl	%ebx, %esi
	leal	1(%ebx), %ebx
	jmp	.L36
	.align 16
.L40:
	leal	-56(%ebp), %eax
	movl	%edi, -64(%ebp)
	movl	%eax, -68(%ebp)
	incl	%ebx
	.align 16
.L50:
	subl	$12, %esp
	movl	-68(%ebp), %eax
	pushl	%eax
	call	strlen
	addl	$16, %esp
	cmpl	-64(%ebp), %eax
	jb	.L114
.L66:
	movl	-60(%ebp), %edx
	movl	8(%ebp), %ecx
	addl	%eax, %edx
	testl	%ecx, %ecx
	movl	%edx, -60(%ebp)
	je	.L70
	pushl	%edi
	pushl	%edi
	movl	-68(%ebp), %eax
	pushl	%eax
	movl	8(%ebp), %eax
	pushl	%eax
	call	strcat
	addl	$16, %esp
	jmp	.L70
	.align 16
.L103:
	movl	-68(%ebp), %eax
	movw	$48, -56(%ebp)
	movl	%eax, 16(%ebp)
	leal	-56(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L50
.L46:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L55:
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L103
	movsbl	-69(%ebp), %edx
	movl	$8, %ecx
	pushl	%edx
	jmp	.L104
.L44:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L63:
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, 16(%ebp)
	jmp	.L50
.L49:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L59:
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L115
	movsbl	-69(%ebp), %edx
	movl	$16, %ecx
	pushl	%edx
	leal	-56(%ebp), %edx
	call	itoak.part.0
	popl	%edx
	movsbl	-56(%ebp), %eax
	testb	%al, %al
	je	.L76
.L61:
	leal	-56(%ebp), %edx
	movl	%ebx, -80(%ebp)
	movl	%edx, %ebx
	.align 16
.L62:
	subl	$12, %esp
	incl	%ebx
	pushl	%eax
	call	toupper
	movb	%al, -1(%ebx)
	addl	$16, %esp
	movsbl	(%ebx), %eax
	testb	%al, %al
	jne	.L62
	movl	-68(%ebp), %eax
	movl	-80(%ebp), %ebx
	movl	%eax, 16(%ebp)
	leal	-56(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L50
.L48:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L64:
	movl	16(%ebp), %eax
	movb	$0, -55(%ebp)
	movl	(%eax), %eax
	movb	%al, -56(%ebp)
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, 16(%ebp)
	leal	-56(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L50
.L41:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L57:
	movl	16(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L103
	movsbl	-69(%ebp), %edx
	movl	$16, %ecx
	pushl	%edx
	jmp	.L104
.L90:
	incl	%ebx
.L45:
	movl	16(%ebp), %eax
	leal	4(%eax), %edi
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L116
	subl	$12, %esp
	movl	$16, %ecx
	leal	-56(%ebp), %edx
	pushl	$48
	call	itoak.part.0
	addl	$16, %esp
.L105:
	leal	-56(%ebp), %eax
	movl	%edi, 16(%ebp)
	movl	$8, -64(%ebp)
	movl	$8, %edi
	movl	%eax, -68(%ebp)
	movb	$48, -70(%ebp)
	jmp	.L50
	.align 16
.L114:
	movl	%eax, -88(%ebp)
	leal	16(%edi), %eax
	andl	$-16, %eax
	movl	%esp, -80(%ebp)
	subl	%eax, %esp
	movl	%esp, %ecx
	pushl	%eax
	movl	-64(%ebp), %eax
	pushl	%eax
	movsbl	-70(%ebp), %eax
	pushl	%eax
	pushl	%ecx
	movl	%ecx, -84(%ebp)
	call	memset
	movl	-84(%ebp), %ecx
	addl	$16, %esp
	movb	$0, (%ecx,%edi)
	cmpl	$-1, -76(%ebp)
	movl	-88(%ebp), %edx
	je	.L117
	pushl	%eax
	pushl	%eax
	movl	-68(%ebp), %eax
	pushl	%eax
	movl	-64(%ebp), %eax
	subl	%edx, %eax
	movl	%ecx, -68(%ebp)
	addl	%ecx, %eax
	pushl	%eax
	call	strcpy
	addl	$16, %esp
	movl	-68(%ebp), %ecx
.L68:
	movl	-60(%ebp), %eax
	movl	-64(%ebp), %edi
	addl	%edi, %eax
	movl	%eax, -60(%ebp)
	movl	8(%ebp), %eax
	testl	%eax, %eax
	je	.L69
	pushl	%edi
	pushl	%edi
	pushl	%ecx
	movl	8(%ebp), %eax
	pushl	%eax
	call	strcat
	addl	$16, %esp
.L69:
	movl	-80(%ebp), %esp
	jmp	.L70
	.align 16
.L117:
	pushl	%edx
	pushl	%edx
	movl	-68(%ebp), %edi
	pushl	%edi
	pushl	%ecx
	movl	%ecx, -68(%ebp)
	call	strcpy
	addl	$16, %esp
	movl	-68(%ebp), %ecx
	jmp	.L68
.L39:
	movl	%edi, -64(%ebp)
	incl	%ebx
.L73:
	leal	-56(%ebp), %eax
	movw	$37, -56(%ebp)
	movl	%eax, -68(%ebp)
	jmp	.L50
.L75:
	leal	-12(%ebp), %esp
	xorl	%eax, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L72:
	subl	$12, %esp
	leal	-56(%ebp), %eax
	pushl	%eax
	call	strlen
	leal	-56(%ebp), %ecx
	addl	$16, %esp
	movl	%ecx, -68(%ebp)
	jmp	.L66
.L84:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L53
.L83:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L63
.L82:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L55
.L85:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L57
.L80:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L64
.L79:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L59
.L116:
	movw	$48, -56(%ebp)
	jmp	.L105
.L115:
	movw	$48, -56(%ebp)
	movl	$48, %eax
	jmp	.L61
.L78:
	movl	$0, -64(%ebp)
	xorl	%edi, %edi
	jmp	.L73
.L76:
	movl	-68(%ebp), %eax
	movl	%eax, 16(%ebp)
	leal	-56(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L50
	.size	vsprintk, .-vsprintk
	.align 16
	.globl	printk
	.type	printk, @function
printk:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	leal	12(%ebp), %esi
	subl	$16, %esp
	movl	8(%ebp), %ebx
	pushl	%esi
	pushl	%ebx
	pushl	$0
	call	vsprintk
	addl	$16, %eax
	addl	$16, %esp
	andl	$-16, %eax
	subl	%eax, %esp
	movl	%esp, %edi
	pushl	%eax
	pushl	%esi
	pushl	%ebx
	pushl	%edi
	call	vsprintk
	movl	%edi, (%esp)
	movl	%eax, %ebx
	call	printstring
	leal	-12(%ebp), %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	printk, .-printk
	.ident	"GCC: (GNU) 11.5.0"
