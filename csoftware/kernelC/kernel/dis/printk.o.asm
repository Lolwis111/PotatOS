	.file	"printk.c"
	.text
	.align 16
	.type	itoa.part.0, @function
itoa.part.0:
	pushl	%ebp
	testl	%eax, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	%ecx, %edi
	pushl	%ebx
	pushl	%ebx
	movl	%edx, %ebx
	jns	.L11
	cmpl	$10, %ecx
	jne	.L11
	negl	%eax
	movl	$1, -16(%ebp)
.L2:
	xorl	%ecx, %ecx
	jmp	.L5
	.align 16
.L12:
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
	jne	.L12
	movl	%edx, %edi
	movl	%esi, %edx
	cmpl	$1, -16(%ebp)
	movl	%edi, %esi
	je	.L24
	testl	%ecx, %ecx
	je	.L9
	movl	%edx, %edi
	jmp	.L10
	.align 16
.L25:
	movzbl	(%ebx,%ecx), %edi
.L10:
	movb	(%ebx,%eax), %dl
	movb	%dl, -16(%ebp)
	movl	%edi, %edx
	movb	%dl, (%ebx,%eax)
	movb	-16(%ebp), %dl
	movb	%dl, (%ebx,%ecx)
	incl	%eax
	decl	%ecx
	cmpl	%eax, %ecx
	jg	.L25
.L9:
	movb	$0, (%ebx,%esi)
	popl	%eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L11:
	movl	$0, -16(%ebp)
	jmp	.L2
	.align 16
.L24:
	leal	2(%ecx), %edx
	movb	$45, (%ebx,%edi)
	movl	%edi, %ecx
	movl	%edx, %esi
	movl	$45, %edi
	jmp	.L10
	.size	itoa.part.0, .-itoa.part.0
	.align 16
	.globl	vsprintk
	.type	vsprintk, @function
vsprintk:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$48, %esp
	movl	8(%ebp), %esi
	movl	12(%ebp), %ecx
	movl	16(%ebp), %edx
	movb	$0, (%esi)
	movb	(%ecx), %al
	testb	%al, %al
	je	.L93
	xorl	%edi, %edi
	.align 16
.L76:
	cmpb	$37, %al
	je	.L147
	incl	%edi
	movb	%al, -44(%ebp)
	cmpb	$0, (%esi)
	movb	$0, -43(%ebp)
	movl	%esi, %ebx
	je	.L74
	.align 16
.L75:
	incl	%ebx
	cmpb	$0, (%ebx)
	jne	.L75
.L74:
	movb	%al, (%ebx)
	movb	$0, 1(%ebx)
	movl	%ecx, %ebx
.L33:
	movb	1(%ebx), %al
	leal	1(%ebx), %ecx
	testb	%al, %al
	jne	.L76
	addl	$48, %esp
	movl	%edi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L147:
	movb	1(%ecx), %al
	cmpb	$45, %al
	je	.L29
	leal	1(%ecx), %ebx
.L30:
	leal	-48(%eax), %ecx
	.align 16
.L31:
	cmpb	$9, %cl
	jbe	.L31
	cmpb	$37, %al
	je	.L32
	subl	$99, %eax
	cmpb	$21, %al
	ja	.L33
	andl	$255, %eax
	jmp	*.L35(,%eax,4)
	.section	.rodata
	.align 4
	.align 4
.L35:
	.long	.L40
	.long	.L39
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L39
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L38
	.long	.L37
	.long	.L33
	.long	.L33
	.long	.L36
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L33
	.long	.L34
	.text
	.align 16
.L29:
	leal	2(%ecx), %ebx
	movb	2(%ecx), %al
	jmp	.L30
.L39:
	leal	4(%edx), %eax
	movl	%eax, -48(%ebp)
	movl	(%edx), %eax
	testl	%eax, %eax
	je	.L148
	leal	-44(%ebp), %edx
	movl	$10, %ecx
	call	itoa.part.0
	movb	-44(%ebp), %dl
	testb	%dl, %dl
	je	.L43
	movb	-43(%ebp), %cl
	xorl	%eax, %eax
	jmp	.L44
	.align 16
.L149:
	movb	-43(%ebp,%eax), %cl
.L44:
	incl	%eax
	testb	%cl, %cl
	jne	.L149
.L42:
	addl	%eax, %edi
	cmpb	$0, (%esi)
	je	.L150
.L77:
	movl	%esi, %eax
	.align 16
.L45:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L45
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L146
.L78:
	xorl	%ecx, %ecx
	leal	-44(%ebp), %edx
	movl	%ebx, -52(%ebp)
	.align 16
.L46:
	incl	%ecx
	movb	(%edx,%ecx), %bl
	movb	%bl, (%eax,%ecx)
	testb	%bl, %bl
	jne	.L46
.L143:
	movl	-52(%ebp), %ebx
	movl	-48(%ebp), %edx
	jmp	.L33
.L38:
	leal	4(%edx), %eax
	movl	%eax, -48(%ebp)
	movl	(%edx), %eax
	testl	%eax, %eax
	je	.L151
	leal	-44(%ebp), %edx
	movl	$8, %ecx
	call	itoa.part.0
	movb	-44(%ebp), %dl
	testb	%dl, %dl
	je	.L49
	movb	-43(%ebp), %cl
	xorl	%eax, %eax
	jmp	.L50
	.align 16
.L152:
	movb	-43(%ebp,%eax), %cl
.L50:
	incl	%eax
	testb	%cl, %cl
	jne	.L152
.L48:
	addl	%eax, %edi
	cmpb	$0, (%esi)
	je	.L153
.L80:
	movl	%esi, %eax
	.align 16
.L51:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L51
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L146
.L81:
	xorl	%ecx, %ecx
	leal	-44(%ebp), %edx
	movl	%ebx, -52(%ebp)
	.align 16
.L52:
	incl	%ecx
	movb	(%edx,%ecx), %bl
	movb	%bl, (%eax,%ecx)
	testb	%bl, %bl
	jne	.L52
	jmp	.L143
.L37:
	leal	4(%edx), %eax
	movl	%eax, -52(%ebp)
	movl	(%edx), %eax
	movl	%eax, -48(%ebp)
	testl	%eax, %eax
	je	.L154
	leal	-44(%ebp), %edx
	movl	-48(%ebp), %eax
	movl	$16, %ecx
	movl	%edx, -60(%ebp)
	call	itoa.part.0
	movb	-44(%ebp), %al
	movb	%al, -56(%ebp)
	testb	%al, %al
	movl	-60(%ebp), %edx
	je	.L67
	movb	-43(%ebp), %cl
	xorl	%eax, %eax
	jmp	.L69
	.align 16
.L155:
	movb	-43(%ebp,%eax), %cl
.L69:
	incl	%eax
	testb	%cl, %cl
	jne	.L155
	addl	%eax, %edi
	movl	-48(%ebp), %eax
	cmpb	$0, (%eax)
	je	.L156
.L139:
	movl	-48(%ebp), %eax
	.align 16
.L70:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L70
	movl	%eax, %ecx
	movl	%eax, -48(%ebp)
	movb	-56(%ebp), %al
	movb	%al, (%ecx)
	testb	%al, %al
	je	.L144
.L91:
	xorl	%eax, %eax
	movl	%ebx, -56(%ebp)
	movl	-48(%ebp), %ecx
	.align 16
.L71:
	incl	%eax
	movb	(%edx,%eax), %bl
	movb	%bl, (%ecx,%eax)
	testb	%bl, %bl
	jne	.L71
.L141:
	movl	-56(%ebp), %ebx
.L144:
	movl	-52(%ebp), %edx
	jmp	.L33
.L36:
	leal	4(%edx), %eax
	movb	(%esi), %cl
	movl	%eax, -52(%ebp)
	movl	(%edx), %eax
	movl	%eax, -48(%ebp)
	movb	(%eax), %dl
	testb	%dl, %dl
	je	.L59
	movl	%ebx, -56(%ebp)
	xorl	%eax, %eax
	movl	-48(%ebp), %ebx
	.align 16
.L60:
	incl	%eax
	cmpb	$0, (%ebx,%eax)
	jne	.L60
	addl	%eax, %edi
	movl	-56(%ebp), %ebx
	testb	%cl, %cl
	je	.L157
.L83:
	movl	%esi, %eax
	.align 16
.L62:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L62
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L144
.L84:
	movl	%ebx, -56(%ebp)
	xorl	%edx, %edx
	movl	-48(%ebp), %ebx
	.align 16
.L63:
	incl	%edx
	movb	(%ebx,%edx), %cl
	movb	%cl, (%eax,%edx)
	testb	%cl, %cl
	jne	.L63
	jmp	.L141
.L34:
	leal	4(%edx), %eax
	movl	%eax, -48(%ebp)
	movl	(%edx), %eax
	testl	%eax, %eax
	je	.L158
	leal	-44(%ebp), %edx
	movl	$16, %ecx
	call	itoa.part.0
	movb	-44(%ebp), %dl
	testb	%dl, %dl
	je	.L55
	movb	-43(%ebp), %cl
	xorl	%eax, %eax
	jmp	.L56
	.align 16
.L159:
	movb	-43(%ebp,%eax), %cl
.L56:
	incl	%eax
	testb	%cl, %cl
	jne	.L159
.L54:
	addl	%eax, %edi
	cmpb	$0, (%esi)
	je	.L160
.L87:
	movl	%esi, %eax
	.align 16
.L57:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L57
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L146
.L86:
	xorl	%ecx, %ecx
	leal	-44(%ebp), %edx
	movl	%ebx, -52(%ebp)
	.align 16
.L58:
	incl	%ecx
	movb	(%edx,%ecx), %bl
	movb	%bl, (%eax,%ecx)
	testb	%bl, %bl
	jne	.L58
	jmp	.L143
.L40:
	leal	4(%edx), %ecx
	movl	(%edx), %edx
	incl	%edi
	movb	%dl, -44(%ebp)
	cmpb	$0, (%esi)
	movb	$0, -43(%ebp)
	movl	%esi, %eax
	je	.L64
	.align 16
.L65:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L65
.L64:
	movb	%dl, (%eax)
	testb	%dl, %dl
	je	.L103
	movb	$0, 1(%eax)
	movl	%ecx, %edx
	jmp	.L33
.L32:
	cmpb	$0, (%esi)
	movw	$37, -44(%ebp)
	movl	%esi, %eax
	je	.L72
	.align 16
.L73:
	incl	%eax
	cmpb	$0, (%eax)
	jne	.L73
.L72:
	incl	%edi
	movw	$37, (%eax)
	jmp	.L33
.L93:
	addl	$48, %esp
	xorl	%eax, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L151:
	movw	$48, -44(%ebp)
	movb	$48, %dl
	movl	$1, %eax
	jmp	.L48
.L148:
	movw	$48, -44(%ebp)
	movb	$48, %dl
	movl	$1, %eax
	jmp	.L42
.L158:
	movw	$48, -44(%ebp)
	movb	$48, %dl
	movl	$1, %eax
	jmp	.L54
.L154:
	movw	$48, -44(%ebp)
	incl	%edi
	movl	-52(%ebp), %edx
	jmp	.L33
.L160:
	movb	%dl, (%esi)
	movl	%esi, %eax
	jmp	.L86
.L157:
	movb	%dl, (%esi)
	movl	%esi, %eax
	jmp	.L84
.L153:
	movb	%dl, (%esi)
	movl	%esi, %eax
	jmp	.L81
.L150:
	movb	%dl, (%esi)
	movl	%esi, %eax
	jmp	.L78
.L55:
	cmpb	$0, (%esi)
	jne	.L87
.L146:
	movl	-48(%ebp), %edx
	jmp	.L33
.L49:
	cmpb	$0, (%esi)
	jne	.L80
	jmp	.L146
.L43:
	cmpb	$0, (%esi)
	jne	.L77
	jmp	.L146
.L59:
	testb	%cl, %cl
	jne	.L83
	jmp	.L144
.L67:
	movl	-48(%ebp), %eax
	cmpb	$0, (%eax)
	jne	.L139
	jmp	.L144
.L103:
	movl	%ecx, %edx
	jmp	.L33
.L156:
	movl	-48(%ebp), %ecx
	movb	-56(%ebp), %al
	movb	%al, (%ecx)
	jmp	.L91
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
	subl	$12, %esp
	movl	8(%ebp), %ebx
	pushl	%esi
	pushl	%ebx
	pushl	$0
	call	vsprintk
	addl	$16, %eax
	addl	$12, %esp
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
