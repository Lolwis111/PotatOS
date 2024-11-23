	.file	"pic.c"
	.text
	.align 16
	.globl	PIC_remap
	.type	PIC_remap, @function
PIC_remap:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$40, %esp
	movl	8(%ebp), %edi
	movl	12(%ebp), %esi
	pushl	$33
	call	inportb
	movl	$161, (%esp)
	movb	%al, -25(%ebp)
	call	inportb
	andl	$255, %edi
	movb	%al, %bl
	popl	%eax
	popl	%edx
	andl	$255, %esi
	pushl	$17
	pushl	$32
	call	outportb
	call	io_wait
	popl	%ecx
	popl	%eax
	pushl	$17
	pushl	$160
	call	outportb
	call	io_wait
	popl	%eax
	popl	%edx
	pushl	%edi
	pushl	$33
	call	outportb
	call	io_wait
	popl	%ecx
	popl	%edi
	pushl	%esi
	pushl	$161
	call	outportb
	call	io_wait
	popl	%eax
	popl	%edx
	pushl	$4
	pushl	$33
	call	outportb
	call	io_wait
	popl	%ecx
	popl	%esi
	pushl	$2
	pushl	$161
	call	outportb
	call	io_wait
	popl	%edi
	popl	%eax
	pushl	$1
	pushl	$33
	call	outportb
	call	io_wait
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$161
	call	outportb
	call	io_wait
	popl	%ecx
	movb	-25(%ebp), %dl
	popl	%esi
	andl	$255, %edx
	pushl	%edx
	pushl	$33
	call	outportb
	xorl	%eax, %eax
	movl	$161, 8(%ebp)
	movb	%bl, %al
	addl	$16, %esp
	movl	%eax, 12(%ebp)
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	outportb
	.size	PIC_remap, .-PIC_remap
	.align 16
	.globl	PIC_sendEOI
	.type	PIC_sendEOI, @function
PIC_sendEOI:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	cmpb	$7, 8(%ebp)
	ja	.L7
.L5:
	pushl	%eax
	pushl	%eax
	pushl	$32
	pushl	$32
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L7:
	pushl	%edx
	pushl	%edx
	pushl	$32
	pushl	$160
	call	outportb
	addl	$16, %esp
	jmp	.L5
	.size	PIC_sendEOI, .-PIC_sendEOI
	.align 16
	.globl	pic_disable
	.type	pic_disable, @function
pic_disable:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	pushl	$255
	pushl	$33
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$255
	pushl	$161
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	pic_disable, .-pic_disable
	.align 16
	.globl	IRQ_set_mask
	.type	IRQ_set_mask, @function
IRQ_set_mask:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %eax
	cmpb	$7, %al
	jbe	.L13
	leal	-8(%eax), %esi
	movl	$161, %ebx
.L11:
	subl	$12, %esp
	pushl	%ebx
	call	inportb
	popl	%edx
	movl	$1, %edx
	popl	%ecx
	movl	%esi, %ecx
	sall	%cl, %edx
	orl	%edx, %eax
	andl	$255, %eax
	pushl	%eax
	pushl	%ebx
	call	outportb
	addl	$16, %esp
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L13:
	movl	%eax, %esi
	movl	$33, %ebx
	jmp	.L11
	.size	IRQ_set_mask, .-IRQ_set_mask
	.align 16
	.globl	IRQ_clear_mask
	.type	IRQ_clear_mask, @function
IRQ_clear_mask:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %eax
	cmpb	$7, %al
	jbe	.L18
	leal	-8(%eax), %esi
	movl	$161, %ebx
.L16:
	subl	$12, %esp
	pushl	%ebx
	call	inportb
	movb	%al, %dl
	popl	%eax
	popl	%ecx
	movl	$-2, %eax
	movl	%esi, %ecx
	roll	%cl, %eax
	andl	%edx, %eax
	andl	$255, %eax
	pushl	%eax
	pushl	%ebx
	call	outportb
	addl	$16, %esp
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L18:
	movl	%eax, %esi
	movl	$33, %ebx
	jmp	.L16
	.size	IRQ_clear_mask, .-IRQ_clear_mask
	.ident	"GCC: (GNU) 11.5.0"
