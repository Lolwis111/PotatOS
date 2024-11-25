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
	pushl	$mouse_irq
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
	addl	$12, %esp
	pushl	$238
	pushl	$syscall
	pushl	$128
	call	idt_set_descriptor
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	initIDT, .-initIDT
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC11:
	.string	"Welcome to TomatOS. The PotatOS fork written in C\r\n\n\n"
	.align 4
.LC12:
	.string	"Initiating floppy drive (might take a few seconds)\r\n"
	.section	.rodata.str1.1
.LC13:
	.string	"Bytes Per Sector:    %6d\r\n"
.LC14:
	.string	"Sectors Per Cluster: %6d\r\n"
.LC15:
	.string	"Number Of FATS:      %6d\r\n"
.LC16:
	.string	"Root Entries:        %6d\r\n"
.LC17:
	.string	"Sectors Per FAT:     %6d\r\n"
.LC18:
	.string	"Sectors Per Track:   %6d\r\n"
.LC19:
	.string	"Heads Per Cylinder:  %6d\r\n"
.LC20:
	.string	"Root sector:         %6d\r\n"
.LC21:
	.string	"%d "
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
	pushl	%ebx
	pushl	%ecx
	subl	$60, %esp
	pushl	$7
	call	clearScreen
	call	initGDT
	call	initKeyboard
	call	initMouse
	call	initSerial
	movl	$100, (%esp)
	call	setTimer
	popl	%ecx
	popl	%ebx
	leal	-44(%ebp), %ebx
	pushl	$112
	pushl	$32
	call	PIC_remap
	call	initIDT
	movl	$.LC11, (%esp)
	call	printk
	call	initalizeFloppyDMA
	movl	$.LC12, (%esp)
	call	printk
	movl	$0, (%esp)
	call	floppyInit
	movl	%ebx, (%esp)
	call	readFileSystem
	popl	%eax
	xorl	%eax, %eax
	popl	%edx
	movw	-33(%ebp), %ax
	pushl	%eax
	pushl	$.LC13
	call	printk
	popl	%ecx
	popl	%eax
	xorl	%eax, %eax
	movb	-31(%ebp), %al
	pushl	%eax
	pushl	$.LC14
	call	printk
	popl	%eax
	xorl	%eax, %eax
	popl	%edx
	movb	-28(%ebp), %al
	pushl	%eax
	pushl	$.LC15
	call	printk
	popl	%ecx
	popl	%eax
	xorl	%eax, %eax
	movw	-27(%ebp), %ax
	pushl	%eax
	pushl	$.LC16
	call	printk
	popl	%eax
	xorl	%eax, %eax
	popl	%edx
	movw	-22(%ebp), %ax
	pushl	%eax
	pushl	$.LC17
	call	printk
	popl	%ecx
	popl	%eax
	xorl	%eax, %eax
	movw	-20(%ebp), %ax
	pushl	%eax
	pushl	$.LC18
	call	printk
	popl	%eax
	xorl	%eax, %eax
	popl	%edx
	movw	-18(%ebp), %ax
	pushl	%eax
	pushl	$.LC19
	call	printk
	popl	%ecx
	xorl	%edx, %edx
	popl	%eax
	xorl	%eax, %eax
	movw	-22(%ebp), %dx
	movb	-28(%ebp), %al
	imull	%edx, %eax
	xorl	%edx, %edx
	movw	-30(%ebp), %dx
	addl	%edx, %eax
	pushl	%eax
	pushl	$.LC20
	call	printk
	movl	%ebx, (%esp)
	call	readRoot
	addl	$16, %esp
	.align 16
.L7:
	call	getch
	pushl	%edx
	pushl	%edx
	movsbl	%al, %eax
	pushl	%eax
	pushl	$.LC21
	call	printk
	addl	$16, %esp
	jmp	.L7
	.size	main, .-main
	.ident	"GCC: (GNU) 11.5.0"
