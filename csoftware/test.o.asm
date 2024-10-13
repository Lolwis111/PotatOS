	.file	"test.c"
	.text
#APP
	.code16gcc

	call $0, $main; xor %eax,%eax;xor %ebx,%ebx;int $0x21;
#NO_APP
	.globl	print
	.type	print, @function
print:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	movl	8(%ebp), %edx
#APP
# 13 "test.c" 1
	mov $0x01, %ah;mov $0x07, %bl;int $0x21;
# 0 "" 2
#NO_APP
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	print, .-print
	.globl	charToHex
	.type	charToHex, @function
charToHex:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	12(%ebp), %edx
	movl	16(%ebp), %eax
	movb	decimals(%edx), %dl
	movb	%dl, (%eax)
	movl	8(%ebp), %edx
	movb	decimals(%edx), %dl
	movb	$0, 2(%eax)
	movb	%dl, 1(%eax)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	charToHex, .-charToHex
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\r\n"
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	pushl	%ebx
	.cfi_escape 0x10,0x3,0x2,0x75,0x7c
	xorl	%ebx, %ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
.L6:
	xorl	%ecx, %ecx
.L7:
	pushl	%eax
	pushl	$buffer
	pushl	%ecx
	incl	%ecx
	pushl	%ebx
	call	charToHex
	movl	$buffer, (%esp)
	call	print
	addl	$16, %esp
	cmpl	$16, %ecx
	jne	.L7
	subl	$12, %esp
	incl	%ebx
	pushl	$.LC0
	call	print
	addl	$16, %esp
	cmpl	$16, %ebx
	jne	.L6
	leal	-8(%ebp), %esp
	xorl	%eax, %eax
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.globl	decimals
	.data
	.align 4
	.type	decimals, @object
	.size	decimals, 17
decimals:
	.string	"0123456789ABCDEF"
	.globl	buffer
	.bss
	.align 4
	.type	buffer, @object
	.size	buffer, 8
buffer:
	.zero	8
	.ident	"GCC: (SUSE Linux) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
