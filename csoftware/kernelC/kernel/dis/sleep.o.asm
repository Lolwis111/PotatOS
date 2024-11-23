	.file	"sleep.c"
	.text
	.align 16
	.globl	timer_isr
	.type	timer_isr, @function
timer_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$16, %esp
	movl	sleepCounter, %eax
	testl	%eax, %eax
	jle	.L2
	movl	sleepCounter, %eax
	decl	%eax
	movl	%eax, sleepCounter
.L2:
	subl	$12, %esp
	pushl	$0
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	timer_isr, .-timer_isr
	.align 16
	.globl	setTimer
	.type	setTimer, @function
setTimer:
	pushl	%ebp
	movl	$1193180, %eax
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	movl	%eax, %edx
	sarl	$31, %edx
	pushl	$52
	idivl	8(%ebp)
	pushl	$67
	movl	%eax, %ebx
	call	outportb
	call	io_wait
	popl	%eax
	movl	%ebx, %eax
	popl	%edx
	andl	$255, %eax
	pushl	%eax
	pushl	$64
	call	outportb
	call	io_wait
	popl	%ecx
	popl	%eax
	movzbl	%bh, %ebx
	pushl	%ebx
	pushl	$64
	call	outportb
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	setTimer, .-setTimer
	.align 16
	.globl	sleep
	.type	sleep, @function
sleep:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, sleepCounter
	movl	sleepCounter, %eax
	testl	%eax, %eax
	jle	.L7
	.align 16
.L9:
	call	hlt
	movl	sleepCounter, %eax
	testl	%eax, %eax
	jg	.L9
.L7:
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	sleep, .-sleep
	.local	sleepCounter
	.comm	sleepCounter,4,4
	.ident	"GCC: (GNU) 11.5.0"
