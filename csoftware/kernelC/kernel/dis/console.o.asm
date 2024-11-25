	.file	"console.c"
	.text
	.align 16
	.globl	setColor
	.type	setColor, @function
setColor:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	movb	%al, global_color
	ret
	.size	setColor, .-setColor
	.align 16
	.globl	clearScreenC
	.type	clearScreenC, @function
clearScreenC:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	subl	$12, %esp
	movl	8(%ebp), %eax
	movb	%al, global_color
	sall	$8, %eax
	orl	$32, %eax
	movl	%eax, %edx
/APP
/  22 "console.c" 1
	cld;movw %dx, %ax;
movl $2000, %ecx;
movl $0xB8000,%edi;
rep stosw;

/  0 "" 2
/NO_APP
	pushl	$15
	movb	$0, screenX
	pushl	$980
	movb	$0, screenY
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$981
	call	outportb
	popl	%ecx
	popl	%edi
	pushl	$14
	pushl	$980
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$981
	call	outportb
	movl	-4(%ebp), %edi
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	clearScreenC, .-clearScreenC
	.align 16
	.globl	clearScreen
	.type	clearScreen, @function
clearScreen:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	subl	$12, %esp
	movsbl	global_color, %edx
	sall	$8, %edx
	orl	$32, %edx
/APP
/  22 "console.c" 1
	cld;movw %dx, %ax;
movl $2000, %ecx;
movl $0xB8000,%edi;
rep stosw;

/  0 "" 2
/NO_APP
	pushl	$15
	movb	$0, screenX
	pushl	$980
	movb	$0, screenY
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$981
	call	outportb
	popl	%ecx
	popl	%edi
	pushl	$14
	pushl	$980
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$981
	call	outportb
	movl	-4(%ebp), %edi
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	clearScreen, .-clearScreen
	.align 16
	.globl	getCursorPosition
	.type	getCursorPosition, @function
getCursorPosition:
	pushl	%ebp
	xorl	%edx, %edx
	movl	%esp, %ebp
	movb	screenX, %dl
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	xorl	%edx, %edx
	movb	screenY, %dl
	movl	%edx, (%eax)
	popl	%ebp
	ret
	.size	getCursorPosition, .-getCursorPosition
	.align 16
	.globl	setCursorPosition
	.type	setCursorPosition, @function
setCursorPosition:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	cmpl	$79, %edx
	jle	.L11
	movl	$79, %edx
	cmpl	$24, %eax
	jle	.L13
.L16:
	movl	$24, %eax
.L14:
	movb	%al, screenY
	leal	(%eax,%eax,4), %eax
	sall	$4, %eax
	movb	%dl, screenX
	leal	(%eax,%edx), %ebx
	pushl	%eax
	pushl	%eax
	pushl	$15
	pushl	$980
	call	outportb
	popl	%edx
	xorl	%eax, %eax
	popl	%ecx
	movb	%bl, %al
	shrw	$8, %bx
	pushl	%eax
	pushl	$981
	call	outportb
	popl	%eax
	andl	$65535, %ebx
	popl	%edx
	pushl	$14
	pushl	$980
	call	outportb
	movl	%ebx, 12(%ebp)
	movl	$981, 8(%ebp)
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	jmp	outportb
	.align 16
.L11:
	movl	%edx, %ecx
	xorl	$-1, %ecx
	sarl	$31, %ecx
	andl	%ecx, %edx
	cmpl	$24, %eax
	jg	.L16
.L13:
	movl	%eax, %ecx
	xorl	$-1, %ecx
	sarl	$31, %ecx
	andl	%ecx, %eax
	jmp	.L14
	.size	setCursorPosition, .-setCursorPosition
	.align 16
	.globl	putchar
	.type	putchar, @function
putchar:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %esi
	movb	screenY, %al
	movb	screenX, %cl
	cmpb	$10, %dl
	je	.L18
	cmpb	$13, %dl
	jne	.L19
	movb	$0, screenX
.L20:
	cmpb	$23, %al
	ja	.L24
.L17:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L18:
	incl	%eax
	movb	%al, screenY
.L21:
	cmpb	$80, %cl
	jne	.L20
	incl	%eax
	movb	$0, screenX
	movb	%al, screenY
	cmpb	$23, %al
	jbe	.L17
.L24:
	pushl	%eax
	pushl	%eax
	xorl	%eax, %eax
	pushl	$23
	movb	screenX, %al
	pushl	%eax
	call	setCursorPosition
/APP
/  60 "console.c" 1
	cld;movl $1920, %ecx;
movl $753824,%esi;
movl $753664,%edi;
rep movsd;

/  0 "" 2
/NO_APP
	movsbl	global_color, %edx
	sall	$8, %edx
	orl	$32, %edx
/APP
/  75 "console.c" 1
	cld;movw %dx, %ax;
movl $80, %ecx;
movl $757504,%edi;
rep stosw;

/  0 "" 2
/NO_APP
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L19:
	xorl	%ebx, %ebx
	movl	%ecx, %edi
	movb	%al, %bl
	andl	$255, %edi
	incl	%ecx
	leal	(%ebx,%ebx,4), %ebx
	movb	%cl, screenX
	sall	$4, %ebx
	addl	%edi, %ebx
	addl	%ebx, %ebx
	movb	%dl, 753664(%ebx)
	movl	%esi, %edx
	movb	%dl, 753665(%ebx)
	jmp	.L21
	.size	putchar, .-putchar
	.align 16
	.globl	printstring
	.type	printstring, @function
printstring:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	xorl	%esi, %esi
	movl	8(%ebp), %ebx
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L26
	.align 16
.L27:
	pushl	%edx
	incl	%esi
	pushl	%edx
	xorl	%edx, %edx
	movb	global_color, %dl
	pushl	%edx
	pushl	%eax
	call	putchar
	movsbl	(%ebx,%esi), %eax
	addl	$16, %esp
	testb	%al, %al
	jne	.L27
.L26:
	pushl	%eax
	pushl	%eax
	xorl	%eax, %eax
	movb	screenY, %al
	pushl	%eax
	xorl	%eax, %eax
	movb	screenX, %al
	pushl	%eax
	call	setCursorPosition
	leal	-8(%ebp), %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	printstring, .-printstring
	.data
	.type	global_color, @object
	.size	global_color, 1
global_color:
	.byte	7
	.local	screenY
	.comm	screenY,1,1
	.local	screenX
	.comm	screenX,1,1
	.ident	"GCC: (GNU) 11.5.0"
