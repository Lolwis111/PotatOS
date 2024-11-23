	.file	"irq_isr.c"
	.text
	.align 16
	.globl	irq2_isr
	.type	irq2_isr, @function
irq2_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$67, 753668
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$99, %eax
	movb	%al, 753668
	pushl	$2
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq2_isr, .-irq2_isr
	.align 16
	.globl	irq3_isr
	.type	irq3_isr, @function
irq3_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$68, 753670
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$100, %eax
	movb	%al, 753670
	pushl	$3
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq3_isr, .-irq3_isr
	.align 16
	.globl	irq4_isr
	.type	irq4_isr, @function
irq4_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$69, 753672
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$101, %eax
	movb	%al, 753672
	pushl	$4
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq4_isr, .-irq4_isr
	.align 16
	.globl	irq5_isr
	.type	irq5_isr, @function
irq5_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$70, 753674
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$102, %eax
	movb	%al, 753674
	pushl	$5
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq5_isr, .-irq5_isr
	.align 16
	.globl	irq7_isr
	.type	irq7_isr, @function
irq7_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	movb	$104, 753678
	pushl	$7
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq7_isr, .-irq7_isr
	.align 16
	.globl	irq8_isr
	.type	irq8_isr, @function
irq8_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$73, 753680
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$105, %eax
	movb	%al, 753680
	pushl	$8
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq8_isr, .-irq8_isr
	.align 16
	.globl	irq9_isr
	.type	irq9_isr, @function
irq9_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$74, 753682
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$106, %eax
	movb	%al, 753682
	pushl	$9
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq9_isr, .-irq9_isr
	.align 16
	.globl	irq10_isr
	.type	irq10_isr, @function
irq10_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$75, 753684
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$107, %eax
	movb	%al, 753684
	pushl	$10
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq10_isr, .-irq10_isr
	.align 16
	.globl	irq11_isr
	.type	irq11_isr, @function
irq11_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$76, 753686
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$108, %eax
	movb	%al, 753686
	pushl	$11
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq11_isr, .-irq11_isr
	.align 16
	.globl	irq12_isr
	.type	irq12_isr, @function
irq12_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$77, 753688
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$109, %eax
	movb	%al, 753688
	pushl	$12
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq12_isr, .-irq12_isr
	.align 16
	.globl	irq13_isr
	.type	irq13_isr, @function
irq13_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$78, 753690
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$110, %eax
	movb	%al, 753690
	pushl	$13
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq13_isr, .-irq13_isr
	.align 16
	.globl	irq14_isr
	.type	irq14_isr, @function
irq14_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$79, 753692
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$111, %eax
	movb	%al, 753692
	pushl	$14
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq14_isr, .-irq14_isr
	.align 16
	.globl	irq15_isr
	.type	irq15_isr, @function
irq15_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	cmpb	$80, 753694
	sete	%al
	decl	%eax
	andl	$-32, %eax
	addl	$112, %eax
	movb	%al, 753694
	pushl	$15
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	irq15_isr, .-irq15_isr
	.ident	"GCC: (GNU) 11.5.0"
