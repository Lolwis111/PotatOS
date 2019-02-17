	.file	"test.c"
	.text
#APP
	.code16gcc

	pusha;call $0, $main;popa;xor %eax,%eax;xor %ebx,%ebx;int $0x21;
#NO_APP
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	movl	$753664, %eax
.L2:
	movb	$3, 1(%eax)
	leal	2(%eax), %edx
	cmpl	$755662, %eax
	je	.L5
	movl	%edx, %eax
	jmp	.L2
.L5:
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 8.2.1 20181127"
	.section	.note.GNU-stack,"",@progbits
