	.file	"print.c"
	.text
#APP
	.code16gcc

	call main; xor %ax,%ax;xor %bx,%bx; int $0x21;
#NO_APP
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	movl	$753664, %edx
.L2:
	xorl	%eax, %eax
.L3:
	movb	$65, (%edx,%eax,2)
	movb	$3, 1(%edx,%eax,2)
	incl	%eax
	cmpl	$80, %eax
	jne	.L3
	addl	$160, %edx
	cmpl	$757664, %edx
	jne	.L2
#APP
# 25 "print.c" 1
	xor %ax,%ax;int $0x16;
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (SUSE Linux) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
