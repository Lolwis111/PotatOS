	.file	"kernel.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC9:
	.string	" - Floppy drive 0: %s\r\n"
.LC10:
	.string	" - Floppy drive 1: %s\r\n"
.LC0:
	.string	"none"
.LC1:
	.string	"360kB 5.25\""
.LC2:
	.string	"1.2MB 5.25\""
.LC3:
	.string	"720kB 3.5\""
.LC4:
	.string	"1.44MB 3.5\""
.LC5:
	.string	"2.88MB 3.5\""
.LC6:
	.string	"unknown type"
	.section	.rodata
	.align 32
.LC8:
	.long	.LC0
	.long	.LC1
	.long	.LC2
	.long	.LC3
	.long	.LC4
	.long	.LC5
	.long	.LC6
	.long	.LC6
	.text
	.align 16
	.globl	floppy_detect_drives
	.type	floppy_detect_drives, @function
floppy_detect_drives:
	pushl	%ebp
	movl	$8, %ecx
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	$.LC8, %esi
	pushl	%ebx
	leal	-56(%ebp), %edi
	subl	$52, %esp
	rep movsl
	pushl	$16
	pushl	$112
	call	outportb
	movl	$113, (%esp)
	call	inportb
	movb	%al, %bl
	popl	%eax
	movb	%bl, %al
	popl	%edx
	shrb	$4, %al
	andl	$15, %ebx
	andl	$255, %eax
	movl	-56(%ebp,%eax,4), %ecx
	pushl	%ecx
	pushl	$.LC9
	call	printk
	popl	%esi
	movl	-56(%ebp,%ebx,4), %eax
	popl	%edi
	pushl	%eax
	pushl	$.LC10
	call	printk
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	floppy_detect_drives, .-floppy_detect_drives
	.align 16
	.globl	clearscreen
	.type	clearscreen, @function
clearscreen:
	pushl	%ebp
	movl	$753664, %eax
	movl	%esp, %ebp
	subl	$8, %esp
	.align 16
.L5:
	movl	%eax, %edx
	movw	$1824, (%eax)
	addl	$2, %eax
	cmpl	$757662, %edx
	jne	.L5
	pushl	%eax
	pushl	%eax
	pushl	$0
	pushl	$0
	call	setCursorPosition
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	clearscreen, .-clearscreen
	.align 16
	.globl	initIDT
	.type	initIDT, @function
initIDT:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	idt_init
	pushl	%edx
	pushl	$142
	pushl	$timer_isr
	pushl	$32
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$keyboard_isr
	pushl	$33
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq2_isr
	pushl	$34
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq3_isr
	pushl	$35
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq4_isr
	pushl	$36
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq5_isr
	pushl	$37
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$floppy_irq_handler
	pushl	$38
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq7_isr
	pushl	$39
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq8_isr
	pushl	$112
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq9_isr
	pushl	$113
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq10_isr
	pushl	$114
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq11_isr
	pushl	$115
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq12_isr
	pushl	$116
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq13_isr
	pushl	$117
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq14_isr
	pushl	$118
	call	idt_set_descriptor
	addl	$12, %esp
	pushl	$142
	pushl	$irq15_isr
	pushl	$119
	call	idt_set_descriptor
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initIDT, .-initIDT
	.section	.rodata.str1.1
.LC11:
	.string	"success"
.LC12:
	.string	"error"
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC13:
	.string	"Welcome to TomatOS. The PotatOS fork written in C\r\n\n\n"
	.align 4
.LC14:
	.string	"Initiating floppy drive (might take a few seconds)\r\n"
	.section	.rodata.str1.1
.LC15:
	.string	"Result: %d (%s)\r\n"
.LC16:
	.string	"%s\r\n"
.LC17:
	.string	"%c"
	.section	.text.startup,"ax",@progbits
	.align 16
	.globl	main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	subl	$24, %esp
	call	clearscreen
	call	initKeyboard
	call	initSerial
	subl	$12, %esp
	pushl	$100
	call	setTimer
	popl	%edi
	popl	%eax
	pushl	$112
	pushl	$32
	call	PIC_remap
	call	initIDT
	movl	$.LC13, (%esp)
	call	printk
	call	initalizeFloppyDMA
	call	floppy_detect_drives
	movl	$.LC14, (%esp)
	call	printk
	movl	$0, (%esp)
	call	floppyInit
	addl	$16, %esp
	movl	$.LC12, %edx
	testl	%eax, %eax
	jne	.L11
	movl	$.LC11, %edx
.L11:
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	pushl	$.LC15
	call	printk
	popl	%ebx
	popl	%esi
	pushl	$0
	pushl	$0
	call	floppyRead
	addl	$16, %esp
	movl	$4128, %ecx
	movl	%esp, -28(%ebp)
	subl	$48, %esp
	movl	%esp, %edi
	movl	%esp, %esi
	movb	$0, 32(%esp)
	movl	%edi, -32(%ebp)
	.align 16
.L12:
	leal	-32(%ecx), %ebx
	.align 16
.L14:
	movb	(%ebx), %al
	cmpb	$31, %al
	ja	.L13
	movb	$46, %al
.L13:
	movb	%al, -4096(%edi,%ebx)
	incl	%ebx
	cmpl	%ecx, %ebx
	jne	.L14
	pushl	%eax
	subl	$32, %edi
	pushl	%eax
	pushl	%esi
	pushl	$.LC16
	call	printk
	addl	$16, %esp
	leal	32(%ebx), %ecx
	cmpl	$4608, %ebx
	jne	.L12
	movl	%esi, %edx
	movl	-32(%ebp), %edi
	leal	32(%esi), %eax
	.align 16
.L16:
	movb	$32, (%edi)
	incl	%edi
	cmpl	%edi, %eax
	jne	.L16
	pushl	%ecx
	pushl	%ecx
	pushl	%edx
	pushl	$.LC16
	call	printk
	movl	-28(%ebp), %esp
	.align 16
.L17:
	call	getch
	pushl	%edx
	pushl	%edx
	movsbl	%al, %eax
	pushl	%eax
	pushl	$.LC17
	call	printk
	addl	$16, %esp
	jmp	.L17
	.size	main, .-main
	.ident	"GCC: (GNU) 11.5.0"
