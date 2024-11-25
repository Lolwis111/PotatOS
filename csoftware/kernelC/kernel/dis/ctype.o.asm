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
	subl	$65, %edx
	andl	$255, %eax
	cmpb	$25, %dl
	jbe	.L9
	popl	%ebp
	ret
	.align 16
.L9:
	addl	$32, %eax
	popl	%ebp
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
	subl	$97, %edx
	andl	$255, %eax
	cmpb	$25, %dl
	jbe	.L13
	popl	%ebp
	ret
	.align 16
.L13:
	subl	$32, %eax
	popl	%ebp
	ret
	.size	toupper, .-toupper
	.ident	"GCC: (GNU) 11.5.0"
