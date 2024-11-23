	.file	"floppy.c"
	.text
	.align 16
	.type	motorOn, @function
motorOn:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	cmpb	$2, %al
	je	.L2
	ja	.L3
	testb	%al, %al
	je	.L11
	pushl	%ecx
	pushl	%ecx
	pushl	$45
	pushl	$1010
	call	outportb
	addl	$16, %esp
.L1:
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L3:
	cmpb	$3, %al
	jne	.L1
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
.L2:
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
.L11:
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
	je	.L13
	ja	.L14
	testb	%al, %al
	je	.L21
	pushl	%ecx
	pushl	%ecx
	pushl	$13
	pushl	$1010
	call	outportb
	addl	$16, %esp
.L12:
	movl	%ebp, %esp
	popl	%ebp
	ret
	.align 16
.L14:
	cmpb	$3, %al
	jne	.L12
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
.L13:
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
.L21:
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
	.align 16
	.globl	floppyRecalibrate
	.type	floppyRecalibrate, @function
floppyRecalibrate:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	$256, %ebx
	subl	$44, %esp
	movb	$0, recievedIRQ
	movl	8(%ebp), %esi
	movl	%esi, %edi
	andl	$255, %edi
	movl	%edi, %eax
	call	motorOn
	jmp	.L25
	.align 16
.L23:
	decl	%ebx
	je	.L26
.L25:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -28(%ebp)
	addl	$16, %esp
	movb	-28(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L23
	pushl	%ecx
	pushl	%ecx
	pushl	$7
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L26:
	movl	$256, %ebx
	jmp	.L24
	.align 16
.L27:
	decl	%ebx
	je	.L29
.L24:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -29(%ebp)
	addl	$16, %esp
	movb	-29(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L27
	pushl	%edx
	pushl	%edx
	pushl	%edi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L29:
	movl	$5000, %ebx
	jmp	.L28
	.align 16
.L31:
	call	hlt
	decl	%ebx
	je	.L41
.L28:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L31
	movl	$256, %ebx
	jmp	.L34
	.align 16
.L32:
	decl	%ebx
	je	.L35
.L34:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -25(%ebp)
	addl	$16, %esp
	movb	-25(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L32
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L35:
	movl	$256, %ebx
	jmp	.L33
	.align 16
.L36:
	call	io_wait
	decl	%ebx
	je	.L49
.L33:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -26(%ebp)
	addl	$16, %esp
	movb	-26(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L36
	subl	$12, %esp
	pushl	$1013
	call	inportb
	movb	%al, %dl
	addl	$16, %esp
	andl	$255, %edx
	movl	%edx, -44(%ebp)
.L37:
	movl	$256, %ebx
	jmp	.L40
	.align 16
.L38:
	call	io_wait
	decl	%ebx
	je	.L39
.L40:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -27(%ebp)
	addl	$16, %esp
	movb	-27(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L38
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L39:
	orl	$32, %esi
	movl	$2, %eax
	andl	$255, %esi
	cmpl	-44(%ebp), %esi
	jne	.L22
	movl	%edi, %eax
	call	motorOff
	xorl	%eax, %eax
.L22:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L41:
	leal	-12(%ebp), %esp
	movl	$1, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L49:
	movl	$-1, -44(%ebp)
	jmp	.L37
	.size	floppyRecalibrate, .-floppyRecalibrate
	.align 16
	.globl	floppySeek
	.type	floppySeek, @function
floppySeek:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	$256, %ebx
	subl	$44, %esp
	movb	$0, recievedIRQ
	movl	12(%ebp), %eax
	movl	8(%ebp), %esi
	movl	%eax, -44(%ebp)
	jmp	.L53
	.align 16
.L51:
	decl	%ebx
	je	.L52
.L53:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -28(%ebp)
	addl	$16, %esp
	movb	-28(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L51
	pushl	%ebx
	pushl	%ebx
	pushl	$15
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L52:
	movzbl	-44(%ebp), %edi
	movl	$256, %ebx
	andl	$255, %edi
	jmp	.L56
	.align 16
.L54:
	decl	%ebx
	je	.L55
.L56:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -29(%ebp)
	addl	$16, %esp
	movb	-29(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L54
	pushl	%ecx
	pushl	%ecx
	pushl	%edi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L55:
	andl	$255, %esi
	movl	$256, %ebx
	jmp	.L59
	.align 16
.L57:
	decl	%ebx
	je	.L58
.L59:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -30(%ebp)
	addl	$16, %esp
	movb	-30(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L57
	pushl	%edx
	pushl	%edx
	pushl	%esi
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L58:
	movl	$1000, %ebx
	jmp	.L61
	.align 16
.L62:
	call	hlt
	decl	%ebx
	je	.L80
.L61:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L62
	movl	$256, %ebx
	jmp	.L65
	.align 16
.L63:
	decl	%ebx
	je	.L64
.L65:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -25(%ebp)
	addl	$16, %esp
	movb	-25(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L63
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L64:
	movl	$256, %ebx
	jmp	.L68
	.align 16
.L66:
	call	io_wait
	decl	%ebx
	je	.L81
.L68:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -26(%ebp)
	addl	$16, %esp
	movb	-26(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L66
	subl	$12, %esp
	pushl	$1013
	call	inportb
	movb	-44(%ebp), %dl
	addl	$16, %esp
	orl	$32, %edx
	cmpb	%al, %dl
	setne	%al
	andl	$255, %eax
	leal	(%eax,%eax), %esi
.L67:
	movl	$256, %ebx
	jmp	.L71
	.align 16
.L69:
	call	io_wait
	decl	%ebx
	je	.L50
.L71:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -27(%ebp)
	addl	$16, %esp
	movb	-27(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L69
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L50:
	leal	-12(%ebp), %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L80:
	leal	-12(%ebp), %esp
	movl	$1, %esi
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L81:
	movl	$2, %esi
	jmp	.L67
	.size	floppySeek, .-floppySeek
	.align 16
	.globl	resetController
	.type	resetController, @function
resetController:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$28, %esp
	movb	$0, recievedIRQ
	pushl	$0
	pushl	$1010
	call	outportb
	popl	%eax
	popl	%edx
	pushl	$0
	pushl	$1015
	call	outportb
	popl	%ecx
	popl	%ebx
	movl	$1000, %ebx
	pushl	$12
	pushl	$1010
	call	outportb
	addl	$16, %esp
	jmp	.L83
	.align 16
.L85:
	call	hlt
	decl	%ebx
	je	.L131
.L83:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L85
	movl	$256, %ebx
	jmp	.L88
	.align 16
.L86:
	decl	%ebx
	je	.L89
.L88:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -18(%ebp)
	addl	$16, %esp
	movb	-18(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L86
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L89:
	movl	$256, %ebx
	jmp	.L87
	.align 16
.L90:
	call	io_wait
	decl	%ebx
	je	.L92
.L87:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -19(%ebp)
	addl	$16, %esp
	movb	-19(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L90
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L92:
	movl	$256, %ebx
	jmp	.L91
	.align 16
.L93:
	call	io_wait
	decl	%ebx
	je	.L95
.L91:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -20(%ebp)
	addl	$16, %esp
	movb	-20(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L93
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L95:
	movl	$256, %ebx
	jmp	.L94
	.align 16
.L96:
	decl	%ebx
	je	.L98
.L94:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -15(%ebp)
	addl	$16, %esp
	movb	-15(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L96
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L98:
	movl	$256, %ebx
	jmp	.L97
	.align 16
.L99:
	call	io_wait
	decl	%ebx
	je	.L101
.L97:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -16(%ebp)
	addl	$16, %esp
	movb	-16(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L99
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L101:
	movl	$256, %ebx
	jmp	.L100
	.align 16
.L102:
	call	io_wait
	decl	%ebx
	je	.L104
.L100:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -17(%ebp)
	addl	$16, %esp
	movb	-17(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L102
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L104:
	movl	$256, %ebx
	jmp	.L103
	.align 16
.L105:
	decl	%ebx
	je	.L107
.L103:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -12(%ebp)
	addl	$16, %esp
	movb	-12(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L105
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L107:
	movl	$256, %ebx
	jmp	.L106
	.align 16
.L108:
	call	io_wait
	decl	%ebx
	je	.L110
.L106:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -13(%ebp)
	addl	$16, %esp
	movb	-13(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L108
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L110:
	movl	$256, %ebx
	jmp	.L109
	.align 16
.L111:
	call	io_wait
	decl	%ebx
	je	.L113
.L109:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -14(%ebp)
	addl	$16, %esp
	movb	-14(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L111
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L113:
	movl	$256, %ebx
	jmp	.L112
	.align 16
.L114:
	decl	%ebx
	je	.L116
.L112:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -9(%ebp)
	addl	$16, %esp
	movb	-9(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L114
	pushl	%eax
	pushl	%eax
	pushl	$8
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L116:
	movl	$256, %ebx
	jmp	.L115
	.align 16
.L117:
	call	io_wait
	decl	%ebx
	je	.L119
.L115:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -10(%ebp)
	addl	$16, %esp
	movb	-10(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L117
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L119:
	movl	$256, %ebx
	jmp	.L118
	.align 16
.L120:
	call	io_wait
	decl	%ebx
	je	.L122
.L118:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -11(%ebp)
	addl	$16, %esp
	movb	-11(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L120
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L122:
	movl	$256, %ebx
	jmp	.L121
	.align 16
.L123:
	decl	%ebx
	je	.L125
.L121:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -21(%ebp)
	addl	$16, %esp
	movb	-21(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L123
	pushl	%ebx
	pushl	%ebx
	pushl	$3
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L125:
	movl	$256, %ebx
	jmp	.L124
	.align 16
.L126:
	decl	%ebx
	je	.L128
.L124:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -22(%ebp)
	addl	$16, %esp
	movb	-22(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L126
	pushl	%ecx
	pushl	%ecx
	pushl	$128
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L128:
	movl	$256, %ebx
	jmp	.L127
	.align 16
.L129:
	decl	%ebx
	je	.L130
.L127:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -23(%ebp)
	addl	$16, %esp
	movb	-23(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L129
	pushl	%edx
	pushl	%edx
	pushl	$10
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L130:
	pushl	%eax
	pushl	%eax
	pushl	$0
	pushl	$1
	call	floppySeek
	movl	$0, (%esp)
	call	floppyRecalibrate
	movl	-4(%ebp), %ebx
	addl	$16, %esp
	movl	%ebp, %esp
	xorl	%eax, %eax
	popl	%ebp
	ret
	.align 16
.L131:
	movl	-4(%ebp), %ebx
	movl	%ebp, %esp
	movl	$1, %eax
	popl	%ebp
	ret
	.size	resetController, .-resetController
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
	jmp	.L151
	.align 16
.L149:
	decl	%ebx
	je	.L150
.L151:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -15(%ebp)
	addl	$16, %esp
	movb	-15(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L149
	pushl	%eax
	pushl	%eax
	pushl	$16
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L150:
	subl	$12, %esp
	movl	$1, %ebx
	pushl	$1013
	call	inportb
	addl	$16, %esp
	cmpb	$-112, %al
	je	.L182
.L148:
	leal	-8(%ebp), %esp
	movl	%ebx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L182:
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
	movb	%al, -9(%ebp)
	addl	$16, %esp
	movb	-9(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L153
	pushl	%eax
	pushl	%eax
	pushl	$19
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
	movb	%al, -10(%ebp)
	addl	$16, %esp
	movb	-10(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L156
	pushl	%ebx
	pushl	%ebx
	pushl	$0
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
	movb	%al, -11(%ebp)
	addl	$16, %esp
	movb	-11(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L159
	pushl	%ecx
	pushl	%ecx
	pushl	$15
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
	movb	%al, -12(%ebp)
	addl	$16, %esp
	movb	-12(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L162
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L163:
	movl	$256, %ebx
	jmp	.L167
	.align 16
.L165:
	decl	%ebx
	je	.L166
.L167:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -13(%ebp)
	addl	$16, %esp
	movb	-13(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L165
	pushl	%eax
	pushl	%eax
	pushl	$20
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L166:
	movl	$256, %ebx
	jmp	.L170
	.align 16
.L168:
	call	io_wait
	decl	%ebx
	je	.L169
.L170:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -14(%ebp)
	addl	$16, %esp
	movb	-14(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L168
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L169:
	call	resetController
	testl	%eax, %eax
	leal	10(%eax), %ebx
	jne	.L148
	andl	$255, %esi
	movl	%esi, %eax
	call	motorOn
	subl	$12, %esp
	pushl	$300
	call	sleep
	movl	%esi, (%esp)
	call	floppyRecalibrate
	addl	$16, %esp
	movl	%eax, %ebx
	testl	%eax, %eax
	je	.L172
	addl	$20, %ebx
	jmp	.L148
.L172:
	subl	$12, %esp
	pushl	$100
	call	sleep
	movl	%esi, %eax
	call	motorOff
	addl	$16, %esp
	jmp	.L148
	.size	floppyInit, .-floppyInit
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
	subl	$76, %esp
	mull	8(%ebp)
	movl	%edx, %ebx
	movl	12(%ebp), %edi
	shrl	$3, %ebx
	leal	(%ebx,%ebx,8), %eax
	movl	8(%ebp), %ebx
	sall	$2, %eax
	subl	%eax, %ebx
	movl	%ebx, %edx
	movl	%ebx, %eax
	sarl	$31, %edx
	idivl	%esi
	movl	%edi, %eax
	andl	$255, %eax
	leal	1(%edx), %esi
	movl	%eax, -60(%ebp)
	call	motorOn
	movl	%ebx, %eax
	movl	$954437177, %ecx
	mull	%ecx
	movl	%edx, %ebx
	movl	%edx, %eax
	andl	$1073741820, %ebx
	movl	$3, -64(%ebp)
	shrl	$2, %eax
	orl	%ebx, %edi
	movl	%eax, -68(%ebp)
	movl	%edi, %eax
	andl	$255, %eax
	movl	%eax, -72(%ebp)
	movl	%ecx, %eax
	mull	8(%ebp)
	shrl	$3, %edx
	movl	%esi, %eax
	andl	$255, %edx
	andl	$65535, %eax
	movl	%edx, -76(%ebp)
	movl	%eax, -80(%ebp)
.L220:
	movb	$0, recievedIRQ
	movl	$256, %ebx
	jmp	.L186
	.align 16
.L184:
	decl	%ebx
	je	.L185
.L186:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -33(%ebp)
	addl	$16, %esp
	movb	-33(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L184
	pushl	%ebx
	pushl	%ebx
	pushl	$6
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L185:
	movl	$256, %ebx
	jmp	.L189
	.align 16
.L187:
	decl	%ebx
	je	.L188
.L189:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -34(%ebp)
	addl	$16, %esp
	movb	-34(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L187
	pushl	%edx
	movl	-72(%ebp), %ecx
	pushl	%edx
	pushl	%ecx
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L188:
	movl	$256, %ebx
	jmp	.L192
	.align 16
.L190:
	decl	%ebx
	je	.L193
.L192:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -35(%ebp)
	addl	$16, %esp
	movb	-35(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L190
	pushl	%eax
	pushl	%eax
	movl	-76(%ebp), %eax
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L193:
	movl	$256, %ebx
	jmp	.L191
	.align 16
.L194:
	decl	%ebx
	je	.L196
.L191:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -36(%ebp)
	addl	$16, %esp
	movb	-36(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L194
	pushl	%eax
	pushl	%eax
	movl	-68(%ebp), %eax
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L196:
	movl	$256, %ebx
	jmp	.L195
	.align 16
.L197:
	decl	%ebx
	je	.L199
.L195:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -37(%ebp)
	addl	$16, %esp
	movb	-37(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L197
	pushl	%edi
	movl	-80(%ebp), %eax
	pushl	%edi
	pushl	%eax
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L199:
	movl	$256, %ebx
	jmp	.L198
	.align 16
.L200:
	decl	%ebx
	je	.L202
.L198:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -38(%ebp)
	addl	$16, %esp
	movb	-38(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L200
	pushl	%esi
	pushl	%esi
	pushl	$2
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L202:
	movl	$256, %ebx
	jmp	.L201
	.align 16
.L203:
	decl	%ebx
	je	.L205
.L201:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -39(%ebp)
	addl	$16, %esp
	movb	-39(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L203
	pushl	%ebx
	pushl	%ebx
	pushl	$18
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L205:
	movl	$256, %ebx
	jmp	.L204
	.align 16
.L206:
	decl	%ebx
	je	.L208
.L204:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -40(%ebp)
	addl	$16, %esp
	movb	-40(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L206
	pushl	%ecx
	pushl	%ecx
	pushl	$27
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L208:
	movl	$256, %ebx
	jmp	.L207
	.align 16
.L209:
	decl	%ebx
	je	.L211
.L207:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -41(%ebp)
	addl	$16, %esp
	movb	-41(%ebp), %al
	andl	$-64, %eax
	cmpb	$-128, %al
	jne	.L209
	pushl	%edx
	pushl	%edx
	pushl	$255
	pushl	$1013
	call	outportb
	addl	$16, %esp
.L211:
	movl	$1000, %ebx
	jmp	.L210
	.align 16
.L234:
	call	hlt
	decl	%ebx
	je	.L213
.L210:
	movb	recievedIRQ, %al
	testb	%al, %al
	je	.L234
.L213:
	leal	-31(%ebp), %esi
	leal	-24(%ebp), %edi
	.align 16
.L212:
	movl	$256, %ebx
	jmp	.L217
	.align 16
.L215:
	call	io_wait
	decl	%ebx
	je	.L237
.L217:
	subl	$12, %esp
	pushl	$1012
	call	inportb
	movb	%al, -32(%ebp)
	addl	$16, %esp
	movb	-32(%ebp), %al
	andl	$-48, %eax
	cmpb	$-48, %al
	jne	.L215
	subl	$12, %esp
	pushl	$1013
	call	inportb
	addl	$16, %esp
.L216:
	movb	%al, (%esi)
	incl	%esi
	call	io_wait
	cmpl	%edi, %esi
	jne	.L212
	testb	$-64, -31(%ebp)
	je	.L221
	subl	$12, %esp
	movl	-60(%ebp), %eax
	pushl	%eax
	call	floppyRecalibrate
	addl	$16, %esp
	decl	-64(%ebp)
	jne	.L220
.L221:
	movl	-60(%ebp), %eax
	call	motorOff
	leal	-12(%ebp), %esp
	popl	%ebx
	xorl	%eax, %eax
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L237:
	movb	$-1, %al
	jmp	.L216
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
	.local	recievedIRQ
	.comm	recievedIRQ,1,1
	.ident	"GCC: (GNU) 11.5.0"
