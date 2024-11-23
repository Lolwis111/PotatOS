	.file	"serial.c"
	.text
	.align 16
	.globl	initSerial
	.type	initSerial, @function
initSerial:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$0
	pushl	$1017
	call	outportb
	popl	%edx
	popl	%ecx
	pushl	$128
	pushl	$1019
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$3
	pushl	$1016
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$0
	pushl	$1017
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$3
	pushl	$1019
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$199
	pushl	$1018
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$11
	pushl	$1020
	call	outportb
	popl	%ecx
	popl	%eax
	pushl	$30
	pushl	$1020
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$174
	pushl	$1016
	call	outportb
	movl	$1016, (%esp)
	call	inportb
	movb	%al, %dl
	addl	$16, %esp
	movl	$1, %eax
	cmpb	$-82, %dl
	je	.L7
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L7:
	pushl	%eax
	pushl	%eax
	pushl	$15
	pushl	$1020
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	xorl	%eax, %eax
	popl	%ebp
	ret
	.size	initSerial, .-initSerial
	.align 16
	.globl	is_transmit_empty
	.type	is_transmit_empty, @function
is_transmit_empty:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	$1021
	call	inportb
	movl	%ebp, %esp
	andl	$32, %eax
	popl	%ebp
	ret
	.size	is_transmit_empty, .-is_transmit_empty
	.align 16
	.globl	writeSerial
	.type	writeSerial, @function
writeSerial:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edx
	movl	8(%ebp), %ebx
	.align 16
.L11:
	subl	$12, %esp
	pushl	$1021
	call	inportb
	addl	$16, %esp
	testb	$32, %al
	je	.L11
	pushl	%eax
	andl	$255, %ebx
	pushl	%eax
	pushl	%ebx
	pushl	$1016
	call	outportb
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	writeSerial, .-writeSerial
	.ident	"GCC: (GNU) 11.5.0"
