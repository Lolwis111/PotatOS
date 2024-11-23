	.file	"ctype.c"
	.text
	.align 16
	.globl	isspace
	.type	isspace, @function
isspace:
	pushl	%ebp
	movl	%esp, %ebp
	cmpb	$32, 8(%ebp)
	je	.L3
	movb	8(%ebp), %al
	popl	%ebp
	subl	$9, %eax
	cmpb	$4, %al
	setbe	%al
	andl	$255, %eax
	ret
	.align 16
.L3:
	movl	$1, %eax
	popl	%ebp
	ret
	.size	isspace, .-isspace
	.align 16
	.globl	tolower
	.type	tolower, @function
tolower:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %eax
	leal	-65(%edx), %ecx
	andl	$255, %eax
	cmpb	$25, %cl
	jbe	.L10
	popl	%ebp
	ret
	.align 16
.L10:
	movb	%dl, %al
	popl	%ebp
	orl	$-128, %eax
	andl	$255, %eax
	ret
	.size	tolower, .-tolower
	.align 16
	.globl	toupper
	.type	toupper, @function
toupper:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %eax
	leal	-97(%edx), %ecx
	andl	$255, %eax
	cmpb	$25, %cl
	jbe	.L15
	popl	%ebp
	ret
	.align 16
.L15:
	leal	-128(%edx), %eax
	popl	%ebp
	andl	$255, %eax
	ret
	.size	toupper, .-toupper
	.ident	"GCC: (GNU) 11.5.0"
