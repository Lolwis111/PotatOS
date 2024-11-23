	.file	"asm.c"
	.text
	.align 16
	.globl	inportb
	.type	inportb, @function
inportb:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
/APP
/  6 "asm.c" 1
	inb %dx, %al
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	inportb, .-inportb
	.align 16
	.globl	outportb
	.type	outportb, @function
outportb:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movb	12(%ebp), %al
/APP
/  12 "asm.c" 1
	outb %al, %dx
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	outportb, .-outportb
	.align 16
	.globl	io_wait
	.type	io_wait, @function
io_wait:
	xorl	%eax, %eax
/APP
/  12 "asm.c" 1
	outb %al, $128
/  0 "" 2
/NO_APP
	ret
	.size	io_wait, .-io_wait
	.align 16
	.globl	cli
	.type	cli, @function
cli:
/APP
/  22 "asm.c" 1
	cli;
/  0 "" 2
/NO_APP
	ret
	.size	cli, .-cli
	.align 16
	.globl	sti
	.type	sti, @function
sti:
/APP
/  27 "asm.c" 1
	sti;
/  0 "" 2
/NO_APP
	ret
	.size	sti, .-sti
	.align 16
	.globl	hlt
	.type	hlt, @function
hlt:
/APP
/  32 "asm.c" 1
	hlt;
/  0 "" 2
/NO_APP
	ret
	.size	hlt, .-hlt
	.align 16
	.globl	int3
	.type	int3, @function
int3:
/APP
/  37 "asm.c" 1
	int3;
/  0 "" 2
/NO_APP
	ret
	.size	int3, .-int3
	.ident	"GCC: (GNU) 11.5.0"
