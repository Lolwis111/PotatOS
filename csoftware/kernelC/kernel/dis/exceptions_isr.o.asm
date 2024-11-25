	.file	"exceptions_isr.c"
	.text
	.align 16
	.globl	div_zero_exception
	.type	div_zero_exception, @function
div_zero_exception:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$48, 753666
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	div_zero_exception, .-div_zero_exception
	.align 16
	.globl	exception1_isr
	.type	exception1_isr, @function
exception1_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$49, 753666
/APP
/  30 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception1_isr, .-exception1_isr
	.align 16
	.globl	nmi_isr
	.type	nmi_isr, @function
nmi_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$50, 753666
/APP
/  43 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	nmi_isr, .-nmi_isr
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"eax: %x\r\nebx: %x\r\necx: %x\r\nedx: %x\r\nesi: %x\r\nedi: %x\r\n"
	.align 4
.LC1:
	.string	"\r\nPress any key to continue.\r\n"
	.text
	.align 16
	.globl	debugger_isr
	.type	debugger_isr, @function
debugger_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$72, %esp
/APP
/  49 "exceptions_isr.c" 1
	;
/  0 "" 2
/NO_APP
	movl	%eax, 52(%esp)
	leal	68(%esp), %eax
	movl	%edx, 44(%esp)
	movl	%ecx, 48(%esp)
	pushl	%eax
	leal	68(%esp), %eax
	pushl	%eax
	cld
	call	getCursorPosition
	addl	$16, %esp
	movl	$753664, %eax
	.align 16
.L9:
	movb	(%eax), %dl
	incl	%eax
	movb	%dl, -737281(%eax)
	cmpl	$757664, %eax
	jne	.L9
	call	clearScreen
	subl	$4, %esp
	pushl	%edi
	pushl	%esi
	pushl	48(%esp)
	pushl	56(%esp)
	pushl	%ebx
	pushl	68(%esp)
	pushl	$.LC0
	call	printk
	addl	$20, %esp
	pushl	$.LC1
	call	printk
	call	getch
	addl	$16, %esp
	movl	$16384, %eax
	.align 16
.L10:
	movb	(%eax), %cl
	incl	%eax
	movb	%cl, 737279(%eax)
	cmpl	$20384, %eax
	jne	.L10
	subl	$8, %esp
	pushl	68(%esp)
	pushl	68(%esp)
	call	setCursorPosition
	addl	$16, %esp
	leal	-24(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	iret
	.size	debugger_isr, .-debugger_isr
	.align 16
	.globl	exception4_isr
	.type	exception4_isr, @function
exception4_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$52, 753666
/APP
/  102 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception4_isr, .-exception4_isr
	.align 16
	.globl	exception5_isr
	.type	exception5_isr, @function
exception5_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$53, 753666
/APP
/  115 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception5_isr, .-exception5_isr
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"Invalid Instruction"
	.text
	.align 16
	.globl	invalid_op_exception
	.type	invalid_op_exception, @function
invalid_op_exception:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$16, %esp
	cld
	call	clearScreen
	subl	$12, %esp
	pushl	$.LC2
	call	panic
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	invalid_op_exception, .-invalid_op_exception
	.align 16
	.globl	exception7_isr
	.type	exception7_isr, @function
exception7_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$55, 753666
/APP
/  135 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception7_isr, .-exception7_isr
	.section	.rodata.str1.4
	.align 4
.LC3:
	.string	"Exception during an exception."
	.text
	.align 16
	.globl	double_fault_exception
	.type	double_fault_exception, @function
double_fault_exception:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$16, %esp
	cld
	call	clearScreen
	subl	$12, %esp
	pushl	$.LC3
	call	panic
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	double_fault_exception, .-double_fault_exception
	.align 16
	.globl	exception9_isr
	.type	exception9_isr, @function
exception9_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$57, 753666
/APP
/  155 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception9_isr, .-exception9_isr
	.align 16
	.globl	exception10_isr
	.type	exception10_isr, @function
exception10_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$97, 753666
/APP
/  168 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception10_isr, .-exception10_isr
	.align 16
	.globl	exception11_isr
	.type	exception11_isr, @function
exception11_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$98, 753666
/APP
/  181 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception11_isr, .-exception11_isr
	.align 16
	.globl	exception12_isr
	.type	exception12_isr, @function
exception12_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$99, 753666
/APP
/  194 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception12_isr, .-exception12_isr
	.align 16
	.globl	exception_gpf_isr
	.type	exception_gpf_isr, @function
exception_gpf_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	pop
	movl	%eax, %ebx
	call	clearScreen
	movl	%ebx, %eax
	movb	$69, 753664
	shrl	$13, %eax
	movb	$100, 753666
	addl	$48, %eax
	movb	$32, 753670
	movb	%al, 753668
	movl	%ebx, %eax
	shrl	$4, %eax
	orl	$15, %ebx
	orl	$1, %eax
	addl	$48, %ebx
	addl	$48, %eax
	movb	%bl, 753674
	movb	%al, 753672
/APP
/  225 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-16(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%ebp
	iret
	.size	exception_gpf_isr, .-exception_gpf_isr
	.align 16
	.globl	exception14_isr
	.type	exception14_isr, @function
exception14_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$101, 753666
/APP
/  238 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception14_isr, .-exception14_isr
	.align 16
	.globl	exception15_isr
	.type	exception15_isr, @function
exception15_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$102, 753666
/APP
/  251 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception15_isr, .-exception15_isr
	.align 16
	.globl	exception16_isr
	.type	exception16_isr, @function
exception16_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$103, 753666
/APP
/  264 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception16_isr, .-exception16_isr
	.align 16
	.globl	exception17_isr
	.type	exception17_isr, @function
exception17_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$104, 753666
/APP
/  277 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception17_isr, .-exception17_isr
	.align 16
	.globl	exception18_isr
	.type	exception18_isr, @function
exception18_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$105, 753666
/APP
/  290 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception18_isr, .-exception18_isr
	.align 16
	.globl	exception19_isr
	.type	exception19_isr, @function
exception19_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$106, 753666
/APP
/  303 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception19_isr, .-exception19_isr
	.align 16
	.globl	exception20_isr
	.type	exception20_isr, @function
exception20_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$107, 753666
/APP
/  316 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception20_isr, .-exception20_isr
	.align 16
	.globl	exception21_isr
	.type	exception21_isr, @function
exception21_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$108, 753666
/APP
/  329 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception21_isr, .-exception21_isr
	.align 16
	.globl	exception22_isr
	.type	exception22_isr, @function
exception22_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$109, 753666
/APP
/  342 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception22_isr, .-exception22_isr
	.align 16
	.globl	exception23_isr
	.type	exception23_isr, @function
exception23_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$110, 753666
/APP
/  355 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception23_isr, .-exception23_isr
	.align 16
	.globl	exception24_isr
	.type	exception24_isr, @function
exception24_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$111, 753666
/APP
/  368 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception24_isr, .-exception24_isr
	.align 16
	.globl	exception25_isr
	.type	exception25_isr, @function
exception25_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$112, 753666
/APP
/  381 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception25_isr, .-exception25_isr
	.align 16
	.globl	exception26_isr
	.type	exception26_isr, @function
exception26_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$113, 753666
/APP
/  394 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception26_isr, .-exception26_isr
	.align 16
	.globl	exception27_isr
	.type	exception27_isr, @function
exception27_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$114, 753666
/APP
/  407 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception27_isr, .-exception27_isr
	.align 16
	.globl	exception28_isr
	.type	exception28_isr, @function
exception28_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$115, 753666
/APP
/  420 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception28_isr, .-exception28_isr
	.align 16
	.globl	exception29_isr
	.type	exception29_isr, @function
exception29_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$116, 753666
/APP
/  433 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception29_isr, .-exception29_isr
	.align 16
	.globl	exception30_isr
	.type	exception30_isr, @function
exception30_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$117, 753666
/APP
/  446 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception30_isr, .-exception30_isr
	.align 16
	.globl	exception31_isr
	.type	exception31_isr, @function
exception31_isr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	cld
	call	clearScreen
	movb	$69, 753664
	movb	$118, 753666
/APP
/  459 "exceptions_isr.c" 1
	cli; hlt;
/  0 "" 2
/NO_APP
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	exception31_isr, .-exception31_isr
	.ident	"GCC: (GNU) 11.5.0"
