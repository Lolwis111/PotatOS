	.file	"print.c"
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
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	$753664, %edx
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
.L2:
	xorl	%eax, %eax
.L5:
	movb	$65, (%edx,%eax,2)
	movb	$3, 1(%edx,%eax,2)
	incl	%eax
	cmpl	$80, %eax
	jne	.L5
	addl	$160, %edx
	cmpl	$757664, %edx
	jne	.L2
#APP
# 25 "print.c" 1
	xor %ax,%ax;int $0x16;
# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits
