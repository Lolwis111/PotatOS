	.file	"floppy.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Floppy result byte: timeout"
	.text
	.align 16
	.type	readResultByte, @function
readResultByte:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	$256, %ebx
	jmp	.L4
	.align 16
.L2:
	decl	%ebx
	je	.L8
.L4:
	subl	$12, %esp
	pushl	$5
	call	sleep
	movl	$1012, (%esp)
	call	inportb
	movb	%al, -9(%ebp)
	addl	$16, %esp
	movb	-9(%ebp), %al
	testb	%al, %al
	jns	.L2
	subl	$12, %esp
	pushl	$1013
	call	inportb
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	andl	$255, %eax
	popl	%ebp
	ret
	.align 16
.L8:
	subl	$12, %esp
	pushl	$.LC0
	call	panic
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	movl	$1, %eax
	popl	%ebp
	ret
	.size	readResultByte, .-readResultByte
	.align 16
	.type	motorOn, @function
motorOn:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	cmpb	$2, %al
	je	.L10
	ja	.L11
	testb	%al, %al
	je	.L18
	pushl	%ecx
	pushl	%ecx
	pushl	$45
	pushl	$1010
	call	outportb
	addl	$16, %esp
.L9:
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L11:
	cmpb	$3, %al
	jne	.L9
	pushl	%eax
	pushl	%eax
	pushl	$143
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L10:
	pushl	%edx
	pushl	%edx
	pushl	$78
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L18:
	pushl	%eax
	pushl	%eax
	pushl	$28
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	motorOn, .-motorOn
	.align 16
	.type	motorOff, @function
motorOff:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	cmpb	$2, %al
	je	.L20
	ja	.L21
	testb	%al, %al
	je	.L28
	pushl	%ecx
	pushl	%ecx
	pushl	$13
	pushl	$1010
	call	outportb
	addl	$16, %esp
.L19:
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L21:
	cmpb	$3, %al
	jne	.L19
	pushl	%eax
	pushl	%eax
	pushl	$15
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L20:
	pushl	%edx
	pushl	%edx
	pushl	$14
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L28:
	pushl	%eax
	pushl	%eax
	pushl	$12
	pushl	$1010
	call	outportb
	addl	$16, %esp
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	motorOff, .-motorOff
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC1:
	.string	"floppyRecalibrate: status = %s\n"
	.section	.rodata.str1.1
.LC2:
	.string	"Floppy calibrate: timeout"
	.text
	.align 16
	.globl	floppyRecalibrate
	.type	floppyRecalibrate, @function
floppyRecalibrate:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	$10, %esi
	pushl	%ebx
	subl	$44, %esp
	movzbl	8(%ebp), %edi
	andl	$255, %edi
	movl	%edi, %eax
	call	motorOn
	subl	$12, %esp
	pushl	$300
	call	sleep
	addl	$16, %esp
	.align 16
.L45:
	movb	$0, recievedIRQ
	movl	$256, %ebx
	jmp	.L32
	.align 16
.L30:
	decl	%ebx
	je	.L33
.L32:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -26(%ebp)
	addl	$16, %esp
	movb	-26(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L30
	pushl	%eax
	pushl	%eax
	pushl	$7
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L33:
	movl	$256, %ebx
	jmp	.L31
	.align 16
.L34:
	decl	%ebx
	je	.L36
.L31:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -27(%ebp)
	addl	$16, %esp
	movb	-27(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L34
	pushl	%ebx
	pushl	%ebx
	pushl	%edi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L36:
	movl	$5000, %ebx
	jmp	.L35
	.align 16
.L38:
	call	hlt
	decl	%ebx
	je	.L43
.L35:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L38
	movl	$256, %ebx
	jmp	.L41
	.align 16
.L39:
	decl	%ebx
	je	.L40
.L41:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -25(%ebp)
	addl	$16, %esp
	movb	-25(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L39
	pushl	%ecx
	pushl	%ecx
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L40:
	call	readResultByte
	movl	%eax, %ebx
	call	readResultByte
	testb	$-64, %bl
	jne	.L54
	testl	%eax, %eax
	je	.L55
.L43:
	decl	%esi
	jne	.L45
	movl	%edi, %eax
	call	motorOff
	subl	$12, %esp
	pushl	$.LC2
	call	panic
	addl	$16, %esp
	leal	-12(%ebp), %esp
	movl	$1, %edx
	popl	%ebx
	movl	%edx, %eax
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L54:
	sarl	$6, %ebx
	pushl	%eax
	pushl	%eax
	movl	statusMessages(,%ebx,4), %edx
	pushl	%edx
	pushl	$.LC1
	call	printk
	addl	$16, %esp
	jmp	.L43
.L55:
	movl	%eax, -44(%ebp)
	movl	%edi, %eax
	call	motorOff
	movl	-44(%ebp), %edx
	leal	-12(%ebp), %esp
	movl	%edx, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	floppyRecalibrate, .-floppyRecalibrate
	.align 16
	.globl	resetController
	.type	resetController, @function
resetController:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$28, %esp
	movb	$0, recievedIRQ
	movl	$1000, %ebx
	pushl	$0
	pushl	$1010
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$12
	pushl	$1010
	call	outportb
	addl	$16, %esp
	jmp	.L57
	.align 16
.L59:
	call	hlt
	decl	%ebx
	je	.L72
.L57:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L59
	movl	$256, %ebx
	jmp	.L62
	.align 16
.L60:
	decl	%ebx
	je	.L61
.L62:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -9(%ebp)
	addl	$16, %esp
	movb	-9(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L60
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L61:
	call	readResultByte
	call	readResultByte
	pushl	%ebx
	pushl	%ebx
	movl	$256, %ebx
	pushl	$0
	pushl	$1015
	call	outportb
	addl	$16, %esp
	jmp	.L65
	.align 16
.L63:
	decl	%ebx
	je	.L66
.L65:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -10(%ebp)
	addl	$16, %esp
	movb	-10(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L63
	pushl	%ecx
	pushl	%ecx
	pushl	$3
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L66:
	movl	$256, %ebx
	jmp	.L64
	.align 16
.L67:
	decl	%ebx
	je	.L69
.L64:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -11(%ebp)
	addl	$16, %esp
	movb	-11(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L67
	pushl	%edx
	pushl	%edx
	pushl	$223
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L69:
	movl	$256, %ebx
	jmp	.L68
	.align 16
.L70:
	decl	%ebx
	je	.L71
.L68:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -12(%ebp)
	addl	$16, %esp
	movb	-12(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L70
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L71:
	subl	$12, %esp
	pushl	$0
	call	floppyRecalibrate
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	xorl	%eax, %eax
	popl	%ebp
	ret
	.align 16
.L72:
	movl	-4(%ebp), %ebx
	movl	%ebp, %esp
	movl	$1, %eax
	popl	%ebp
	ret
	.size	resetController, .-resetController
	.section	.rodata.str1.1
.LC3:
	.string	"floppyReset fail"
	.text
	.align 16
	.globl	floppyInit
	.type	floppyInit, @function
floppyInit:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	$256, %ebx
	subl	$16, %esp
	movl	8(%ebp), %esi
	jmp	.L81
	.align 16
.L79:
	decl	%ebx
	je	.L80
.L81:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -14(%ebp)
	addl	$16, %esp
	movb	-14(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L79
	pushl	%eax
	pushl	%eax
	pushl	$16
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L80:
	subl	$12, %esp
	movl	$1, %ebx
	pushl	$1013
	call	inportb
	addl	$16, %esp
	cmpb	$-112, %al
	je	.L107
	leal	-8(%ebp), %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L107:
	movl	$256, %ebx
	jmp	.L85
	.align 16
.L83:
	decl	%ebx
	je	.L84
.L85:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -9(%ebp)
	addl	$16, %esp
	movb	-9(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L83
	pushl	%eax
	pushl	%eax
	pushl	$19
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L84:
	movl	$256, %ebx
	jmp	.L88
	.align 16
.L86:
	decl	%ebx
	je	.L87
.L88:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -10(%ebp)
	addl	$16, %esp
	movb	-10(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L86
	pushl	%ebx
	pushl	%ebx
	pushl	$0
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L87:
	movl	$256, %ebx
	jmp	.L91
	.align 16
.L89:
	decl	%ebx
	je	.L90
.L91:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -11(%ebp)
	addl	$16, %esp
	movb	-11(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L89
	pushl	%ecx
	pushl	%ecx
	pushl	$15
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L90:
	movl	$256, %ebx
	jmp	.L94
	.align 16
.L92:
	decl	%ebx
	je	.L93
.L94:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -12(%ebp)
	addl	$16, %esp
	movb	-12(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L92
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L93:
	movl	$256, %ebx
	jmp	.L97
	.align 16
.L95:
	decl	%ebx
	je	.L96
.L97:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -13(%ebp)
	addl	$16, %esp
	movb	-13(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L95
	pushl	%eax
	pushl	%eax
	pushl	$20
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L96:
	call	readResultByte
	call	resetController
	movl	%eax, %ebx
	testl	%eax, %eax
	jne	.L108
	andl	$255, %esi
	movl	%esi, %eax
	call	motorOn
	subl	$12, %esp
	pushl	$300
	call	sleep
	movl	%esi, (%esp)
	call	floppyRecalibrate
	movl	$100, (%esp)
	call	sleep
	movl	%esi, %eax
	call	motorOff
	addl	$16, %esp
	leal	-8(%ebp), %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
.L108:
	subl	$12, %esp
	movl	$1, %ebx
	pushl	$.LC3
	call	printk
	addl	$16, %esp
	leal	-8(%ebp), %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	floppyInit, .-floppyInit
	.section	.rodata.str1.1
.LC4:
	.string	"floppy_seek: status = %s\n"
.LC5:
	.string	"Floppy seek: timeout"
	.text
	.align 16
	.globl	floppySeek
	.type	floppySeek, @function
floppySeek:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	$10, %esi
	pushl	%ebx
	subl	$44, %esp
	movb	12(%ebp), %al
	movl	8(%ebp), %edi
	movl	%eax, -44(%ebp)
	call	motorOn
	andl	$255, %edi
	.align 16
.L127:
	movb	$0, recievedIRQ
	movl	$256, %ebx
	jmp	.L112
	.align 16
.L110:
	decl	%ebx
	je	.L113
.L112:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -26(%ebp)
	addl	$16, %esp
	movb	-26(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L110
	pushl	%eax
	pushl	%eax
	pushl	$15
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L113:
	movl	$256, %ebx
	jmp	.L111
	.align 16
.L114:
	decl	%ebx
	je	.L115
.L111:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -27(%ebp)
	addl	$16, %esp
	movb	-27(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L114
	pushl	%eax
	pushl	%eax
	movl	-44(%ebp), %eax
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L115:
	movl	$256, %ebx
	jmp	.L118
	.align 16
.L116:
	decl	%ebx
	je	.L119
.L118:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -28(%ebp)
	addl	$16, %esp
	movb	-28(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L116
	pushl	%ebx
	pushl	%ebx
	pushl	%edi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L119:
	movl	$1000, %ebx
	jmp	.L117
	.align 16
.L121:
	call	hlt
	decl	%ebx
	je	.L128
.L117:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L121
	movl	$256, %ebx
	jmp	.L124
	.align 16
.L122:
	decl	%ebx
	je	.L123
.L124:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -25(%ebp)
	addl	$16, %esp
	movb	-25(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L122
	pushl	%ecx
	pushl	%ecx
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L123:
	call	readResultByte
	movl	%eax, %ebx
	call	readResultByte
	movl	%ebx, %edx
	andl	$192, %edx
	jne	.L135
	cmpl	%edi, %eax
	je	.L136
.L126:
	decl	%esi
	jne	.L127
	subl	$12, %esp
	pushl	$.LC5
	call	panic
	addl	$16, %esp
	movl	$1, %edx
.L109:
	leal	-12(%ebp), %esp
	movl	%edx, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L128:
	leal	-12(%ebp), %esp
	movl	$1, %edx
	movl	%edx, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L135:
	sarl	$6, %ebx
	pushl	%eax
	pushl	%eax
	movl	statusMessages(,%ebx,4), %edx
	pushl	%edx
	pushl	$.LC4
	call	printk
	addl	$16, %esp
	jmp	.L126
.L136:
	movl	-44(%ebp), %eax
	movl	%edx, -48(%ebp)
	call	motorOff
	movl	-48(%ebp), %edx
	jmp	.L109
	.size	floppySeek, .-floppySeek
	.section	.rodata.str1.1
.LC6:
	.string	"floppyRead: status = %s\n"
.LC7:
	.string	"floppyRead: end of cylinder\n"
.LC8:
	.string	"floppyRead: drive not ready\n"
.LC9:
	.string	"floppyRead: CRC error\n"
	.section	.rodata.str1.4
	.align 4
.LC10:
	.string	"floppyRead: controller timeout\n"
	.section	.rodata.str1.1
.LC11:
	.string	"floppyRead: no data found\n"
	.section	.rodata.str1.4
	.align 4
.LC12:
	.string	"floppyRead: no address mark found\n"
	.align 4
.LC13:
	.string	"floppyRead: deleted address mark\n"
	.align 4
.LC14:
	.string	"floppyRead: CRC error in data\n"
	.section	.rodata.str1.1
.LC15:
	.string	"floppyRead: wrong cylinder\n"
	.section	.rodata.str1.4
	.align 4
.LC16:
	.string	"floppyRead: uPD765 sector not found\n"
	.section	.rodata.str1.1
.LC17:
	.string	"floppyRead: bad cylinder\n"
	.section	.rodata.str1.4
	.align 4
.LC18:
	.string	"floppyRead: wanted 512B/sector, got %d"
	.text
	.align 16
	.globl	floppyRead
	.type	floppyRead, @function
floppyRead:
	pushl	%ebp
	movl	$954437177, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	$18, %esi
	pushl	%ebx
	subl	$68, %esp
	mull	8(%ebp)
	movl	%edx, %ecx
	movl	12(%ebp), %ebx
	shrl	$3, %ecx
	movl	%ebx, %edi
	pushl	$0
	andl	$255, %edi
	leal	(%ecx,%ecx,8), %eax
	movl	8(%ebp), %ecx
	sall	$2, %eax
	pushl	$1015
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%ecx, %eax
	sarl	$31, %edx
	movl	%ecx, -44(%ebp)
	idivl	%esi
	leal	1(%edx), %esi
	call	outportb
	movl	%edi, %eax
	call	motorOn
	movl	$500, (%esp)
	call	sleep
	movl	$954437177, %eax
	mull	8(%ebp)
	shrl	$3, %edx
	popl	%eax
	popl	%ecx
	andl	$255, %edx
	pushl	%edi
	movl	%edx, -56(%ebp)
	pushl	%edx
	call	floppySeek
	movl	$954437177, %eax
	movl	-44(%ebp), %ecx
	mull	%ecx
	movl	%edx, %eax
	andl	$1073741820, %edx
	shrl	$2, %eax
	orl	%edx, %ebx
	movl	%eax, -60(%ebp)
	movb	%bl, %al
	andl	$255, %eax
	addl	$16, %esp
	movl	%eax, -64(%ebp)
	movl	%esi, %eax
	andl	$65535, %eax
	movl	$10, -52(%ebp)
	movl	%eax, -68(%ebp)
	movl	%edi, -48(%ebp)
	.align 16
.L186:
	movl	-48(%ebp), %eax
	movl	$256, %ebx
	call	motorOn
	movb	$0, recievedIRQ
	jmp	.L140
	.align 16
.L138:
	decl	%ebx
	je	.L139
.L140:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -25(%ebp)
	addl	$16, %esp
	movb	-25(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L138
	pushl	%edi
	pushl	%edi
	pushl	$198
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L139:
	movl	$256, %ebx
	jmp	.L143
	.align 16
.L141:
	decl	%ebx
	je	.L142
.L143:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -26(%ebp)
	addl	$16, %esp
	movb	-26(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L141
	pushl	%ebx
	movl	-64(%ebp), %esi
	pushl	%ebx
	pushl	%esi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L142:
	movl	$256, %ebx
	jmp	.L146
	.align 16
.L144:
	decl	%ebx
	je	.L145
.L146:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -27(%ebp)
	addl	$16, %esp
	movb	-27(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L144
	pushl	%edx
	movl	-56(%ebp), %ecx
	pushl	%edx
	pushl	%ecx
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L145:
	movl	$256, %ebx
	jmp	.L149
	.align 16
.L147:
	decl	%ebx
	je	.L148
.L149:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -28(%ebp)
	addl	$16, %esp
	movb	-28(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L147
	pushl	%eax
	pushl	%eax
	movl	-60(%ebp), %eax
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L148:
	movl	$256, %ebx
	jmp	.L152
	.align 16
.L150:
	decl	%ebx
	je	.L151
.L152:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -29(%ebp)
	addl	$16, %esp
	movb	-29(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L150
	pushl	%eax
	pushl	%eax
	movl	-68(%ebp), %eax
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L151:
	movl	$256, %ebx
	jmp	.L155
	.align 16
.L153:
	decl	%ebx
	je	.L154
.L155:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -30(%ebp)
	addl	$16, %esp
	movb	-30(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L153
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L154:
	movl	$256, %ebx
	jmp	.L158
	.align 16
.L156:
	decl	%ebx
	je	.L157
.L158:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -31(%ebp)
	addl	$16, %esp
	movb	-31(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L156
	pushl	%edi
	pushl	%edi
	pushl	$18
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L157:
	movl	$256, %ebx
	jmp	.L161
	.align 16
.L159:
	decl	%ebx
	je	.L160
.L161:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -32(%ebp)
	addl	$16, %esp
	movb	-32(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L159
	pushl	%esi
	pushl	%esi
	pushl	$27
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L160:
	movl	$256, %ebx
	jmp	.L164
	.align 16
.L162:
	decl	%ebx
	je	.L163
.L164:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -33(%ebp)
	addl	$16, %esp
	movb	-33(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L162
	pushl	%ebx
	pushl	%ebx
	pushl	$255
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L163:
	movl	$1000, %ebx
	jmp	.L165
	.align 16
.L222:
	call	hlt
	decl	%ebx
	je	.L168
.L165:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L222
.L168:
	call	readResultByte
	movl	%eax, %edi
	call	readResultByte
	movl	%eax, %ebx
	call	readResultByte
	movl	%eax, %esi
	call	readResultByte
	call	readResultByte
	call	readResultByte
	call	readResultByte
	testl	$192, %edi
	movl	%eax, -44(%ebp)
	jne	.L166
	xorl	%eax, %eax
	testb	%bl, %bl
	js	.L224
.L170:
	andl	$8, %edi
	jne	.L225
.L171:
	testb	$32, %bl
	jne	.L226
.L172:
	testb	$16, %bl
	jne	.L227
.L173:
	testb	$4, %bl
	jne	.L228
.L174:
	orl	%esi, %ebx
	andl	$1, %ebx
	jne	.L229
.L175:
	testl	$64, %esi
	jne	.L230
.L176:
	testl	$32, %esi
	jne	.L231
.L177:
	testl	$16, %esi
	jne	.L232
.L178:
	movl	%esi, %ebx
	andl	$2, %ebx
	andl	$4, %esi
	jne	.L233
	testb	%bl, %bl
	jne	.L184
	cmpb	$2, -44(%ebp)
	jne	.L181
	testl	%eax, %eax
	je	.L234
	.align 16
.L183:
	decl	-52(%ebp)
	jne	.L186
	movl	-48(%ebp), %eax
	call	motorOff
	subl	$12, %esp
	pushl	$300
	call	sleep
	addl	$16, %esp
	leal	-12(%ebp), %esp
	xorl	%eax, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L184:
	subl	$12, %esp
	pushl	$.LC17
	call	printk
	addl	$16, %esp
	cmpb	$2, -44(%ebp)
	je	.L183
.L181:
	movb	-44(%ebp), %cl
	pushl	%eax
	pushl	%eax
	addl	$7, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	pushl	%eax
	pushl	$.LC18
	call	printk
	addl	$16, %esp
	jmp	.L183
	.align 16
.L233:
	subl	$12, %esp
	pushl	$.LC16
	call	printk
	addl	$16, %esp
	testb	%bl, %bl
	jne	.L184
	cmpb	$2, -44(%ebp)
	je	.L183
	jmp	.L181
	.align 16
.L232:
	subl	$12, %esp
	pushl	$.LC15
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L178
	.align 16
.L231:
	subl	$12, %esp
	pushl	$.LC14
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L177
	.align 16
.L230:
	subl	$12, %esp
	pushl	$.LC13
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L176
	.align 16
.L229:
	subl	$12, %esp
	pushl	$.LC12
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L175
	.align 16
.L228:
	subl	$12, %esp
	pushl	$.LC11
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L174
	.align 16
.L227:
	subl	$12, %esp
	pushl	$.LC10
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L173
	.align 16
.L226:
	subl	$12, %esp
	pushl	$.LC9
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L172
	.align 16
.L225:
	subl	$12, %esp
	pushl	$.LC8
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L171
	.align 16
.L166:
	movl	%edi, %eax
	pushl	%edx
	shrb	$6, %al
	pushl	%edx
	andl	$255, %eax
	movl	statusMessages(,%eax,4), %ecx
	pushl	%ecx
	pushl	$.LC6
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	testb	%bl, %bl
	jns	.L170
.L224:
	subl	$12, %esp
	pushl	$.LC7
	call	printk
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L170
.L234:
	movl	-48(%ebp), %eax
	call	motorOff
	leal	-12(%ebp), %esp
	popl	%ebx
	xorl	%eax, %eax
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	floppyRead, .-floppyRead
	.align 16
	.globl	floppy_irq_handler
	.type	floppy_irq_handler, @function
floppy_irq_handler:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	andl	$-16, %esp
	subl	$28, %esp
	movb	$1, recievedIRQ
	pushl	$6
	cld
	call	PIC_sendEOI
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%eax
	popl	%edx
	popl	%ecx
	popl	%ebp
	iret
	.size	floppy_irq_handler, .-floppy_irq_handler
	.section	.rodata.str1.1
.LC19:
	.string	"error"
.LC20:
	.string	"invalid"
.LC21:
	.string	"drive"
	.section	.rodata
	.align 4
	.type	statusMessages, @object
	.size	statusMessages, 16
statusMessages:
	.long	0
	.long	.LC19
	.long	.LC20
	.long	.LC21
	.local	recievedIRQ
	.comm	recievedIRQ,1,1
	.ident	"GCC: (GNU) 11.5.0"
