	.file	"ctest.c"
	.text
#APP
	.code16gcc

	jmp $0, $main
#NO_APP
	.globl	degreeToRadians
	.type	degreeToRadians, @function
degreeToRadians:
.LFB0:
	.cfi_startproc
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	flds	.LC0@GOTOFF(%eax)
	fmuls	8(%ebp)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	degreeToRadians, .-degreeToRadians
	.globl	radianToDegree
	.type	radianToDegree, @function
radianToDegree:
.LFB11:
	.cfi_startproc
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	flds	.LC0@GOTOFF(%eax)
	fmuls	8(%ebp)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE11:
	.size	radianToDegree, .-radianToDegree
	.globl	abs
	.type	abs, @function
abs:
.LFB2:
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
.LFE2:
	.size	abs, .-abs
	.globl	sleep
	.type	sleep, @function
sleep:
.LFB3:
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
# 45 "ctest.c" 1
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
.LFE3:
	.size	sleep, .-sleep
	.globl	fsincos
	.type	fsincos, @function
fsincos:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
#APP
# 53 "ctest.c" 1
	FLD 8(%ebp);FSINCOS;FSTP (%eax);FSTP (%edx)
# 0 "" 2
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	fsincos, .-fsincos
	.globl	putPixel
	.type	putPixel, @function
putPixel:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movb	16(%ebp), %cl
	testl	%edx, %edx
	js	.L14
	cmpl	$320, %edx
	jle	.L12
	movl	$319, %edx
	jmp	.L12
.L14:
	xorl	%edx, %edx
.L12:
	testl	%eax, %eax
	js	.L15
	cmpl	$200, %eax
	jle	.L13
	movl	$199, %eax
	jmp	.L13
.L15:
	xorl	%eax, %eax
.L13:
	imull	$320, %eax, %eax
	movb	%cl, 655360(%edx,%eax)
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	putPixel, .-putPixel
	.globl	cls
	.type	cls, @function
cls:
.LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	$655360, %eax
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movb	8(%ebp), %dl
.L19:
	movb	%dl, (%eax)
	incl	%eax
	cmpl	$719360, %eax
	jne	.L19
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	cls, .-cls
	.globl	drawLine
	.type	drawLine, @function
drawLine:
.LFB7:
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
	movsbl	24(%ebp), %eax
	subl	%ebx, %edi
	movl	%edi, -28(%ebp)
	jns	.L23
	movl	%ebx, %esi
	subl	16(%ebp), %esi
	movl	%esi, -28(%ebp)
.L23:
	xorl	%edx, %edx
	movl	20(%ebp), %ecx
	cmpl	%ebx, 16(%ebp)
	setg	%dl
	subl	12(%ebp), %ecx
	leal	-1(%edx,%edx), %edx
	movl	%ecx, -32(%ebp)
	jns	.L25
	movl	12(%ebp), %edi
	subl	20(%ebp), %edi
	movl	%edi, -32(%ebp)
.L25:
	movl	-32(%ebp), %esi
	movl	12(%ebp), %ecx
	negl	%esi
	cmpl	%ecx, 20(%ebp)
	movl	%esi, -36(%ebp)
	movl	-28(%ebp), %esi
	setg	%cl
	subl	-32(%ebp), %esi
	movzbl	%cl, %edi
	leal	-1(%edi,%edi), %edi
.L27:
	movl	%edx, -44(%ebp)
	pushl	%edx
	pushl	%eax
	pushl	12(%ebp)
	movl	%eax, -40(%ebp)
	pushl	%ebx
	call	putPixel
	addl	$16, %esp
	movl	-40(%ebp), %eax
	cmpl	16(%ebp), %ebx
	movl	-44(%ebp), %edx
	jne	.L34
	movl	20(%ebp), %ecx
	cmpl	%ecx, 12(%ebp)
	je	.L22
.L34:
	leal	(%esi,%esi), %ecx
	cmpl	%ecx, -36(%ebp)
	jge	.L30
	subl	-32(%ebp), %esi
	addl	%edx, %ebx
.L30:
	cmpl	%ecx, -28(%ebp)
	jle	.L27
	addl	-28(%ebp), %esi
	addl	%edi, 12(%ebp)
	jmp	.L27
.L22:
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
.LFE7:
	.size	drawLine, .-drawLine
	.globl	drawCircle
	.type	drawCircle, @function
drawCircle:
.LFB8:
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
.L40:
	movl	%ebx, -36(%ebp)
	incl	%ebx
	fnstcw	-26(%ebp)
	fildl	-36(%ebp)
	pushl	%eax
	pushl	%esi
	movw	-26(%ebp), %ax
	fstps	-12(%ebp)
	flds	16(%ebp)
#APP
# 53 "ctest.c" 1
	FLD -12(%ebp);FSINCOS;FSTP -20(%ebp);FSTP -16(%ebp)
# 0 "" 2
#NO_APP
	fmuls	-20(%ebp)
	orb	$12, %ah
	movw	%ax, -28(%ebp)
	fldcw	-28(%ebp)
	fistpl	-32(%ebp)
	fldcw	-26(%ebp)
	flds	16(%ebp)
	fmuls	-16(%ebp)
	movl	-32(%ebp), %eax
	addl	12(%ebp), %eax
	fldcw	-28(%ebp)
	fistpl	-32(%ebp)
	fldcw	-26(%ebp)
	pushl	%eax
	movl	-32(%ebp), %eax
	addl	8(%ebp), %eax
	pushl	%eax
	call	putPixel
	addl	$16, %esp
	cmpl	$360, %ebx
	jne	.L40
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
.LFE8:
	.size	drawCircle, .-drawCircle
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$56, %esp
#APP
# 138 "ctest.c" 1
	mov $0x0013, %ax; int $0x10;
# 0 "" 2
#NO_APP
	xorl	%esi, %esi
.L47:
	subl	$12, %esp
	xorl	%edi, %edi
	pushl	$0
	call	cls
	leal	360(%esi), %edx
	addl	$16, %esp
	leal	CSWTCH.6@GOTOFF(%ebx), %ecx
.L44:
	leal	(%edi,%esi), %eax
	cmpl	$6, %edi
	movl	%eax, -52(%ebp)
	je	.L50
.L46:
	cmpl	%edx, -52(%ebp)
	je	.L51
	fildl	-52(%ebp)
	subl	$12, %esp
	movl	%edx, -60(%ebp)
	movsbl	(%ecx), %eax
	fnstcw	-42(%ebp)
	movl	%ecx, -56(%ebp)
	pushl	%eax
	fstps	-28(%ebp)
	movw	-42(%ebp), %ax
	flds	.LC1@GOTOFF(%ebx)
#APP
# 53 "ctest.c" 1
	FLD -28(%ebp);FSINCOS;FSTP -36(%ebp);FSTP -32(%ebp)
# 0 "" 2
#NO_APP
	flds	-36(%ebp)
	fmul	%st(1), %st
	orb	$12, %ah
	movw	%ax, -44(%ebp)
	fldcw	-44(%ebp)
	fistpl	-48(%ebp)
	fldcw	-42(%ebp)
	fmuls	-32(%ebp)
	movl	-48(%ebp), %eax
	fldcw	-44(%ebp)
	fistpl	-48(%ebp)
	fldcw	-42(%ebp)
	addl	$100, %eax
	pushl	%eax
	movl	-48(%ebp), %eax
	addl	$160, %eax
	pushl	%eax
	pushl	$100
	pushl	$160
	call	drawLine
	addl	$32, %esp
	movl	-60(%ebp), %edx
	addl	$6, -52(%ebp)
	movl	-56(%ebp), %ecx
	jmp	.L46
.L51:
	incl	%edi
	incl	%edx
	incl	%ecx
	jmp	.L44
.L50:
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
	movl	$20, (%esp)
	call	sleep
	addl	$16, %esp
	jmp	.L47
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.section	.rodata
	.align 4
	.type	CSWTCH.6, @object
	.size	CSWTCH.6, 6
CSWTCH.6:
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
.LC1:
	.long	1128792064
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB13:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE13:
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB14:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE14:
	.ident	"GCC: (GNU) 8.2.1 20181127"
	.section	.note.GNU-stack,"",@progbits
