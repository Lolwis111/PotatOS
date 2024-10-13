	.file	"ctest.c"
	.text
#APP
	.code16gcc

	call $0, $main; xor %eax,%eax;xor %ebx,%ebx;int $0x21;
#NO_APP
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
	pushl	%ebx
	.cfi_offset 3, -12
	movswl	8(%ebp), %eax
	movswl	12(%ebp), %ebx
	movb	16(%ebp), %dl
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
.LFB16:
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
.LFE16:
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
	movl	8(%ebp), %edx
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	movl	%edx, %eax
	negl	%eax
	cmovs	%edx, %eax
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
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
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
	movl	8(%ebp), %ecx
	pushl	%ebx
	.cfi_offset 3, -12
	movl	12(%ebp), %eax
	movb	16(%ebp), %dl
	testl	%ecx, %ecx
	js	.L16
	cmpl	$320, %ecx
	jle	.L14
	movl	$319, %ecx
	jmp	.L14
.L16:
	xorl	%ecx, %ecx
.L14:
	testl	%eax, %eax
	js	.L18
	cmpl	$200, %eax
	jle	.L15
	movl	$199, %eax
	jmp	.L15
.L18:
	xorl	%eax, %eax
.L15:
	imull	$320, %eax, %ebx
	movl	$-24576, %eax
	addl	%ecx, %ebx
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
	pushl	%ebx
	.cfi_offset 3, -12
	movb	8(%ebp), %dl
	xorl	%ebx, %ebx
.L23:
#APP
# 28 "ctest.c" 1
	mov %ax, %gs;movb %dl, %gs:(%bx);
# 0 "" 2
#NO_APP
	incl	%ebx
	cmpl	$64000, %ebx
	jne	.L23
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
	subl	$44, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	8(%ebp), %ebx
	movl	16(%ebp), %edi
	movl	12(%ebp), %eax
	movb	24(%ebp), %cl
	subl	%ebx, %edi
	movl	%edi, -28(%ebp)
	jns	.L27
	movl	%ebx, %esi
	subl	16(%ebp), %esi
	movl	%esi, -28(%ebp)
.L27:
	xorl	%edx, %edx
	cmpl	%ebx, 16(%ebp)
	setg	%dl
	movl	%edx, %edi
	leal	-1(%edi,%edi), %esi
	movl	20(%ebp), %edi
	movl	%esi, -36(%ebp)
	subl	%eax, %edi
	movl	%edi, -32(%ebp)
	jns	.L29
	movl	%eax, %esi
	subl	20(%ebp), %esi
	movl	%esi, -32(%ebp)
.L29:
	movl	-32(%ebp), %edi
	movl	-28(%ebp), %esi
	negl	%edi
	cmpl	%eax, 20(%ebp)
	movl	%edi, -40(%ebp)
	setg	%dl
	movzbl	%dl, %edi
	movl	-32(%ebp), %edx
	leal	-1(%edi,%edi), %edi
	subl	%edx, %esi
	movsbl	%cl, %edx
	movl	%edx, -44(%ebp)
.L31:
	pushl	%edx
	pushl	-44(%ebp)
	pushl	%eax
	movl	%eax, 12(%ebp)
	pushl	%ebx
	call	putPixel
	addl	$16, %esp
	movl	12(%ebp), %eax
	cmpl	16(%ebp), %ebx
	jne	.L38
	cmpl	20(%ebp), %eax
	je	.L26
.L38:
	leal	(%esi,%esi), %ecx
	cmpl	%ecx, -40(%ebp)
	jge	.L34
	movl	-32(%ebp), %edx
	subl	%edx, %esi
	movl	-36(%ebp), %edx
	addl	%edx, %ebx
.L34:
	cmpl	%ecx, -28(%ebp)
	jle	.L31
	movl	-28(%ebp), %ecx
	addl	%edi, %eax
	addl	%ecx, %esi
	jmp	.L31
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
	subl	$32, %esp
	movsbl	20(%ebp), %esi
.L44:
	movl	%ebx, -32(%ebp)
	fildl	-32(%ebp)
	fstps	-12(%ebp)
#APP
# 64 "ctest.c" 1
	FLD -12(%ebp);FSINCOS;FSTP -20(%ebp);FSTP -16(%ebp)
# 0 "" 2
#NO_APP
	pushl	%eax
	incl	%ebx
	pushl	%esi
	flds	16(%ebp)
	fnstcw	-26(%ebp)
	fmuls	-20(%ebp)
	movw	-26(%ebp), %ax
	orb	$12, %ah
	movw	%ax, -28(%ebp)
	fldcw	-28(%ebp)
	fistpl	-32(%ebp)
	fldcw	-26(%ebp)
	flds	16(%ebp)
	movl	-32(%ebp), %eax
	fmuls	-16(%ebp)
	addl	12(%ebp), %eax
	pushl	%eax
	fldcw	-28(%ebp)
	fistpl	-32(%ebp)
	fldcw	-26(%ebp)
	movl	-32(%ebp), %eax
	addl	8(%ebp), %eax
	pushl	%eax
	call	putPixel
	addl	$16, %esp
	cmpl	$360, %ebx
	jne	.L44
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
#APP
# 149 "ctest.c" 1
	mov $0x0013, %ax;int $0x10;
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE10:
	.size	graphicsMode, .-graphicsMode
	.globl	textMode
	.type	textMode, @function
textMode:
.LFB11:
	.cfi_startproc
#APP
# 157 "ctest.c" 1
	mov $0x0003, %ax;int $0x10;
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE11:
	.size	textMode, .-textMode
	.globl	readchar
	.type	readchar, @function
readchar:
.LFB12:
	.cfi_startproc
#APP
# 166 "ctest.c" 1
	mov $1, %ah;int $0x16;
# 0 "" 2
#NO_APP
	testb	%al, %al
	je	.L49
#APP
# 175 "ctest.c" 1
	xor %ax, %ax;int $0x16;
# 0 "" 2
#NO_APP
.L49:
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
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	pushl	%edi
	pushl	%esi
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	xorl	%esi, %esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	subl	$40, %esp
	call	graphicsMode
.L55:
	call	readchar
	testb	%al, %al
	je	.L64
	subl	$12, %esp
	movl	%esi, %ebx
	pushl	$0
	call	cls
	addl	$16, %esp
	xorl	%edx, %edx
.L56:
	movl	%ebx, %edi
.L58:
	movl	%edi, -48(%ebp)
	fildl	-48(%ebp)
	fstps	-28(%ebp)
#APP
# 64 "ctest.c" 1
	FLD -28(%ebp);FSINCOS;FSTP -36(%ebp);FSTP -32(%ebp)
# 0 "" 2
#NO_APP
	xorl	%eax, %eax
	cmpl	$5, %edx
	jg	.L57
	movsbl	CSWTCH.20(%edx), %eax
.L57:
	subl	$12, %esp
	flds	.LC2
	addl	$6, %edi
	movl	%edx, -52(%ebp)
	pushl	%eax
	fnstcw	-42(%ebp)
	flds	-36(%ebp)
	fmul	%st(1), %st
	movw	-42(%ebp), %ax
	orb	$12, %ah
	movw	%ax, -44(%ebp)
	fldcw	-44(%ebp)
	fistpl	-48(%ebp)
	fldcw	-42(%ebp)
	movl	-48(%ebp), %eax
	addl	$100, %eax
	pushl	%eax
	fmuls	-32(%ebp)
	fldcw	-44(%ebp)
	fistpl	-48(%ebp)
	fldcw	-42(%ebp)
	movl	-48(%ebp), %eax
	addl	$160, %eax
	pushl	%eax
	pushl	$100
	pushl	$160
	call	drawLine
	leal	359(%ebx), %eax
	addl	$32, %esp
	cmpl	%eax, %edi
	movl	-52(%ebp), %edx
	jle	.L58
	incl	%ebx
	incl	%edx
	leal	5(%esi), %eax
	cmpl	%ebx, %eax
	jge	.L56
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
	movl	$10, (%esp)
	call	sleep
	addl	$16, %esp
	jmp	.L55
.L64:
	call	textMode
	leal	-16(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
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
	.ident	"GCC: (SUSE Linux) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
