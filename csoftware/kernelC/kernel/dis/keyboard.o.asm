	.file	"keyboard.c"
	.text
	.align 16
	.globl	keyboard_isr
	.type	keyboard_isr, @function
keyboard_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	pushl	$96
	cld
	call	inportb
	addl	$16, %esp
	testb	%al, %al
	js	.L3
	cmpb	$54, %al
	je	.L4
	movb	$32, %cl
	cmpb	$57, %al
	je	.L5
	cmpb	$42, %al
	je	.L4
	movl	shift, %edx
	andl	$255, %eax
	decl	%edx
	je	.L16
	movb	lowerCaseMap(%eax), %cl
.L5:
	movl	end, %eax
	movl	start, %ebx
	addl	$15, %eax
	movl	%eax, %edx
	sarl	$31, %edx
	shrl	$28, %edx
	addl	%edx, %eax
	andl	$15, %eax
	subl	%edx, %eax
	cmpl	%ebx, %eax
	je	.L3
	movl	start, %eax
	movb	%cl, kbBuffer(%eax)
	movl	start, %eax
	incl	%eax
	movl	%eax, %edx
	sarl	$31, %edx
	shrl	$28, %edx
	addl	%edx, %eax
	andl	$15, %eax
	subl	%edx, %eax
	movl	%eax, start
.L3:
	subl	$12, %esp
	pushl	$1
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-16(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%ebp
	iret
	.align 16
.L4:
	movl	$1, shift
	xorl	%ecx, %ecx
	jmp	.L5
	.align 16
.L16:
	movb	upperCaseMap(%eax), %cl
	jmp	.L5
	.size	keyboard_isr, .-keyboard_isr
	.align 16
	.globl	getch
	.type	getch, @function
getch:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	start, %edx
	movl	end, %eax
	cmpl	%eax, %edx
	jne	.L18
	.align 16
.L19:
	call	hlt
	movl	start, %edx
	movl	end, %eax
	cmpl	%eax, %edx
	je	.L19
.L18:
	movl	end, %eax
	movb	kbBuffer(%eax), %dl
	movl	end, %eax
	incl	%eax
	movl	%eax, %ecx
	sarl	$31, %ecx
	shrl	$28, %ecx
	addl	%ecx, %eax
	andl	$15, %eax
	subl	%ecx, %eax
	movl	%eax, end
	movl	%ebp, %esp
	movb	%dl, %al
	popl	%ebp
	ret
	.size	getch, .-getch
	.align 16
	.globl	initKeyboard
	.type	initKeyboard, @function
initKeyboard:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	$173
	call	sendPS2Command
	movl	$96, (%esp)
	call	inportb
	movl	$174, (%esp)
	call	sendPS2Command
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initKeyboard, .-initKeyboard
	.section	.rodata
	.align 32
	.type	upperCaseMap, @object
	.size	upperCaseMap, 256
upperCaseMap:
	.string	""
	.string	""
	.string	"!@#$%^&*()_+\b\tQWERTYUIOP{}\n"
	.string	"ASDFGHJKL:\"~"
	.string	"|ZXCVBNM<>?"
	.zero	201
	.align 32
	.type	lowerCaseMap, @object
	.size	lowerCaseMap, 256
lowerCaseMap:
	.string	""
	.string	""
	.string	"1234567890-=\b\tqwertyuiop[]\n"
	.string	"asdfghjkl;'`"
	.string	"\\zxcvbnm,./"
	.zero	201
	.local	shift
	.comm	shift,4,4
	.local	end
	.comm	end,4,4
	.local	start
	.comm	start,4,4
	.local	kbBuffer
	.comm	kbBuffer,16,4
	.ident	"GCC: (GNU) 11.5.0"
