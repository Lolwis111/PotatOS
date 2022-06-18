	.file	"ctest.c"
#APP
	.code16gcc

	call $0, $main; xor %eax,%eax;xor %ebx,%ebx;int $0x21;
#NO_APP
	.text
	.globl	farWrite_byte
	.type	farWrite_byte, @function
farWrite_byte:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	16(%ebp), %edx
	pushl	%ebx
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	12(%ebp), %ebx
#APP
# 28 "ctest.c" 1
	mov %ax, %gs;movb %dl, %gs:(%bx);
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
	.size	farWrite_byte, .-farWrite_byte
	.globl	degreeToRadians
	.type	degreeToRadians, @function
degreeToRadians:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	flds	.LC0
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	fmuls	8(%ebp)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	degreeToRadians, .-degreeToRadians
	.globl	radianToDegree
	.type	radianToDegree, @function
radianToDegree:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	flds	.LC0
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	fmuls	8(%ebp)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	radianToDegree, .-radianToDegree
	.globl	abs
	.type	abs, @function
abs:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	cltd
	xorl	%edx, %eax
	subl	%edx, %eax
	ret
	.cfi_endproc
.LFE3:
	.size	abs, .-abs
	.globl	sleep
	.type	sleep, @function
sleep:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	movl	8(%ebp), %ebx
#APP
# 56 "ctest.c" 1
	mov $0x19, %ah;int $0x21;
# 0 "" 2
#NO_APP
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	sleep, .-sleep
	.globl	fsincos
	.type	fsincos, @function
fsincos:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	16(%ebp), %edx
	movl	12(%ebp), %eax
#APP
# 64 "ctest.c" 1
	FLD 8(%ebp);FSINCOS;FSTP (%eax);FSTP (%edx)
# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	fsincos, .-fsincos
	.globl	putPixel
	.type	putPixel, @function
putPixel:
.LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	pushl	%ebx
	.cfi_offset 3, -12
	movl	16(%ebp), %edx
	movl	12(%ebp), %ebx
	testl	%eax, %eax
	js	.L16
	cmpl	$321, %eax
	movl	$319, %ecx
	cmovge	%ecx, %eax
	jmp	.L14
.L16:
	xorl	%eax, %eax
.L14:
	testl	%ebx, %ebx
	js	.L18
	cmpl	$201, %ebx
	movl	$199, %ecx
	cmovge	%ecx, %ebx
	jmp	.L15
.L18:
	xorl	%ebx, %ebx
.L15:
	imull	$320, %ebx, %ebx
	addl	%eax, %ebx
	movl	$-24576, %eax
#APP
# 28 "ctest.c" 1
	mov %ax, %gs;movb %dl, %gs:(%bx);
# 0 "" 2
#NO_APP
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	putPixel, .-putPixel
	.globl	cls
	.type	cls, @function
cls:
.LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	$-24576, %eax
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movb	8(%ebp), %dl
	pushl	%ebx
	.cfi_offset 3, -12
	xorl	%ebx, %ebx
.L24:
#APP
# 28 "ctest.c" 1
	mov %ax, %gs;movb %dl, %gs:(%bx);
# 0 "" 2
#NO_APP
	incl	%ebx
	cmpl	$64000, %ebx
	jne	.L24
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	cls, .-cls
	.globl	drawLine
	.type	drawLine, @function
drawLine:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	16(%ebp), %edx
	subl	8(%ebp), %edx
	movl	20(%ebp), %esi
	movl	%edx, %eax
	movl	%edx, %ecx
	sarl	$31, %eax
	xorl	%eax, %ecx
	subl	%eax, %ecx
	movl	16(%ebp), %eax
	cmpl	%eax, 8(%ebp)
	setl	%al
	xorl	%ebx, %ebx
	subl	12(%ebp), %esi
	movzbl	%al, %eax
	leal	-1(%eax,%eax), %eax
	movl	%esi, %edx
	sarl	$31, %edx
	xorl	%edx, %esi
	subl	%edx, %esi
	movsbl	24(%ebp), %edx
	movl	%esi, %edi
	negl	%edi
	movl	%edi, -16(%ebp)
	movl	20(%ebp), %edi
	cmpl	%edi, 12(%ebp)
	movl	%edx, -20(%ebp)
	setl	%bl
	movl	%ebx, %edi
	movl	%ecx, %ebx
	leal	-1(%edi,%edi), %edi
	subl	%esi, %ebx
.L29:
	pushl	-20(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	movl	%ecx, -28(%ebp)
	movl	%eax, -24(%ebp)
	call	putPixel
	movl	20(%ebp), %eax
	addl	$12, %esp
	cmpl	%eax, 12(%ebp)
	movl	-28(%ebp), %ecx
	movl	-24(%ebp), %eax
	jne	.L36
	movl	16(%ebp), %edx
	cmpl	%edx, 8(%ebp)
	je	.L26
.L36:
	leal	(%ebx,%ebx), %edx
	cmpl	-16(%ebp), %edx
	jle	.L32
	addl	%eax, 8(%ebp)
	subl	%esi, %ebx
.L32:
	cmpl	%ecx, %edx
	jge	.L29
	addl	%ecx, %ebx
	addl	%edi, 12(%ebp)
	jmp	.L29
.L26:
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	drawLine, .-drawLine
	.globl	drawCircle
	.type	drawCircle, @function
drawCircle:
.LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	xorl	%ebx, %ebx
	subl	$24, %esp
	movsbl	20(%ebp), %esi
.L43:
	movl	%ebx, -28(%ebp)
	fildl	-28(%ebp)
	fstps	-12(%ebp)
#APP
# 64 "ctest.c" 1
	FLD -12(%ebp);FSINCOS;FSTP -20(%ebp);FSTP -16(%ebp)
# 0 "" 2
#NO_APP
	fnstcw	-30(%ebp)
	flds	16(%ebp)
	incl	%ebx
	fmuls	-20(%ebp)
	pushl	%esi
	movw	-30(%ebp), %ax
	orb	$12, %ah
	movw	%ax, -32(%ebp)
	fldcw	-32(%ebp)
	fistpl	-28(%ebp)
	fldcw	-30(%ebp)
	movl	-28(%ebp), %eax
	addl	12(%ebp), %eax
	flds	16(%ebp)
	fmuls	-16(%ebp)
	pushl	%eax
	fldcw	-32(%ebp)
	fistpl	-28(%ebp)
	fldcw	-30(%ebp)
	movl	-28(%ebp), %eax
	addl	8(%ebp), %eax
	pushl	%eax
	call	putPixel
	addl	$12, %esp
	cmpl	$360, %ebx
	jne	.L43
	leal	-8(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE9:
	.size	drawCircle, .-drawCircle
	.globl	graphicsMode
	.type	graphicsMode, @function
graphicsMode:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
#APP
# 149 "ctest.c" 1
	mov $0x0013, %ax;int $0x10;
# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE10:
	.size	graphicsMode, .-graphicsMode
	.globl	textMode
	.type	textMode, @function
textMode:
.LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
#APP
# 157 "ctest.c" 1
	mov $0x0003, %ax;int $0x10;
# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE11:
	.size	textMode, .-textMode
	.globl	readchar
	.type	readchar, @function
readchar:
.LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
#APP
# 166 "ctest.c" 1
	mov $1, %ah;int $0x16;
# 0 "" 2
#NO_APP
	testb	%al, %al
	je	.L50
#APP
# 175 "ctest.c" 1
	xor %ax, %ax;int $0x16;
# 0 "" 2
#NO_APP
.L50:
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE12:
	.size	readchar, .-readchar
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
.LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	xorl	%esi, %esi
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -20
	call	graphicsMode
.L56:
	call	readchar
	testb	%al, %al
	je	.L65
	pushl	$0
	movl	%esi, %ebx
	call	cls
	xorl	%edx, %edx
	popl	%eax
	leal	5(%esi), %eax
	movl	%eax, -44(%ebp)
.L57:
	cmpl	%ebx, -44(%ebp)
	jl	.L60
	leal	359(%ebx), %eax
	movl	%ebx, %edi
	movl	%eax, -40(%ebp)
.L61:
	cmpl	%edi, -40(%ebp)
	jl	.L66
	movl	%edi, -36(%ebp)
	fildl	-36(%ebp)
	fstps	-16(%ebp)
#APP
# 64 "ctest.c" 1
	FLD -16(%ebp);FSINCOS;FSTP -24(%ebp);FSTP -20(%ebp)
# 0 "" 2
#NO_APP
	xorl	%ecx, %ecx
	cmpl	$5, %edx
	ja	.L58
	movsbl	CSWTCH.20(%edx), %ecx
.L58:
	fnstcw	-30(%ebp)
	flds	.LC2
	addl	$6, %edi
	pushl	%ecx
	flds	-24(%ebp)
	fmul	%st(1), %st
	movw	-30(%ebp), %cx
	movl	%edx, -48(%ebp)
	orb	$12, %ch
	movw	%cx, -32(%ebp)
	fldcw	-32(%ebp)
	fistpl	-36(%ebp)
	fldcw	-30(%ebp)
	movl	-36(%ebp), %ecx
	fmuls	-20(%ebp)
	addl	$100, %ecx
	pushl	%ecx
	fldcw	-32(%ebp)
	fistpl	-36(%ebp)
	fldcw	-30(%ebp)
	movl	-36(%ebp), %ecx
	addl	$160, %ecx
	pushl	%ecx
	pushl	$100
	pushl	$160
	call	drawLine
	addl	$20, %esp
	movl	-48(%ebp), %edx
	jmp	.L61
.L66:
	incl	%edx
	incl	%ebx
	jmp	.L57
.L60:
	pushl	$4
	incl	%esi
	pushl	$0x41c80000
	pushl	$100
	pushl	$160
	call	drawCircle
	pushl	$2
	pushl	$0x42480000
	pushl	$100
	pushl	$160
	call	drawCircle
	addl	$32, %esp
	pushl	$14
	pushl	$0x42c80000
	pushl	$100
	pushl	$160
	call	drawCircle
	pushl	$10
	call	sleep
	addl	$20, %esp
	jmp	.L56
.L65:
	call	textMode
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE13:
	.size	main, .-main
	.section	.rodata
	.align 4
	.type	CSWTCH.20, @object
	.size	CSWTCH.20, 6
CSWTCH.20:
	.byte	4
	.byte	14
	.byte	7
	.byte	2
	.byte	1
	.byte	3
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.long	1113927392
	.align 4
.LC2:
	.long	1128792064
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits
