	.file	"idt.c"
	.text
	.align 16
	.globl	idt_set_descriptor
	.type	idt_set_descriptor, @function
idt_set_descriptor:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	movb	8(%ebp), %al
	movl	12(%ebp), %edx
	movl	16(%ebp), %ecx
	popl	%ebp
	movw	%dx, idt(,%eax,8)
	movw	$8, idt+2(,%eax,8)
	shrl	$16, %edx
	movb	%cl, idt+5(,%eax,8)
	movw	%dx, idt+6(,%eax,8)
	movb	$0, idt+4(,%eax,8)
	ret
	.size	idt_set_descriptor, .-idt_set_descriptor
	.align 16
	.globl	idt_init
	.type	idt_init, @function
idt_init:
	movl	$div_zero_exception, %eax
	movl	$idt, idtr+2
	movw	%ax, idt
	movw	$2047, idtr
	shrl	$16, %eax
	movl	$-1912602616, idt+2
	movw	%ax, idt+6
	movl	$exception1_isr, %eax
	movw	%ax, idt+8
	movl	$-1912602616, idt+10
	shrl	$16, %eax
	movl	$-1912602616, idt+18
	movw	%ax, idt+14
	movl	$nmi_isr, %eax
	movw	%ax, idt+16
	movl	$-1895825400, idt+26
	shrl	$16, %eax
	movl	$-1912602616, idt+34
	movw	%ax, idt+22
	movl	$debugger_isr, %eax
	movw	%ax, idt+24
	movl	$-1912602616, idt+42
	shrl	$16, %eax
	movl	$-1912602616, idt+50
	movw	%ax, idt+30
	movl	$exception4_isr, %eax
	movw	%ax, idt+32
	movl	$-1912602616, idt+58
	shrl	$16, %eax
	movl	$-1912602616, idt+66
	movw	%ax, idt+38
	movl	$exception5_isr, %eax
	movw	%ax, idt+40
	movl	$-1912602616, idt+74
	shrl	$16, %eax
	movw	%ax, idt+46
	movl	$invalid_op_exception, %eax
	movw	%ax, idt+48
	shrl	$16, %eax
	movw	%ax, idt+54
	movl	$exception7_isr, %eax
	movw	%ax, idt+56
	shrl	$16, %eax
	movw	%ax, idt+62
	movl	$double_fault_exception, %eax
	movw	%ax, idt+64
	shrl	$16, %eax
	movw	%ax, idt+70
	movl	$exception9_isr, %eax
	movw	%ax, idt+72
	shrl	$16, %eax
	movw	%ax, idt+78
	movl	$exception10_isr, %eax
	movw	%ax, idt+80
	movl	$-1912602616, idt+82
	shrl	$16, %eax
	movl	$-1912602616, idt+90
	movw	%ax, idt+86
	movl	$exception11_isr, %eax
	movw	%ax, idt+88
	movw	$8, idt+98
	shrl	$16, %eax
	movb	$-114, idt+101
	movw	%ax, idt+94
	movl	$exception12_isr, %eax
	movw	%ax, idt+96
	movb	$0, idt+100
	shrl	$16, %eax
	movl	$-1912602616, idt+106
	movw	%ax, idt+102
	movl	$exception_gpf_isr, %eax
	movw	%ax, idt+104
	movl	$-1912602616, idt+114
	shrl	$16, %eax
	movl	$-1912602616, idt+122
	movw	%ax, idt+110
	movl	$exception14_isr, %eax
	movw	%ax, idt+112
	movl	$-1912602616, idt+130
	shrl	$16, %eax
	movl	$-1912602616, idt+138
	movw	%ax, idt+118
	movl	$exception15_isr, %eax
	movw	%ax, idt+120
	movl	$-1912602616, idt+146
	shrl	$16, %eax
	movl	$-1912602616, idt+154
	movw	%ax, idt+126
	movl	$exception16_isr, %eax
	movw	%ax, idt+128
	shrl	$16, %eax
	movw	%ax, idt+134
	movl	$exception17_isr, %eax
	movw	%ax, idt+136
	shrl	$16, %eax
	movw	%ax, idt+142
	movl	$exception18_isr, %eax
	movw	%ax, idt+144
	shrl	$16, %eax
	movw	%ax, idt+150
	movl	$exception19_isr, %eax
	movw	%ax, idt+152
	shrl	$16, %eax
	movw	%ax, idt+158
	movl	$exception20_isr, %eax
	movw	%ax, idt+160
	shrl	$16, %eax
	movw	%ax, idt+166
	movl	$exception21_isr, %eax
	movw	%ax, idt+168
	movl	$-1912602616, idt+162
	shrl	$16, %eax
	movl	$-1912602616, idt+170
	movw	%ax, idt+174
	movl	$exception22_isr, %eax
	movw	%ax, idt+176
	movl	$-1912602616, idt+178
	shrl	$16, %eax
	movl	$-1912602616, idt+186
	movw	%ax, idt+182
	movl	$exception23_isr, %eax
	movw	%ax, idt+184
	movl	$-1912602616, idt+194
	shrl	$16, %eax
	movw	$8, idt+202
	movw	%ax, idt+190
	movl	$exception24_isr, %eax
	movw	%ax, idt+192
	movb	$-114, idt+205
	shrl	$16, %eax
	movb	$0, idt+204
	movw	%ax, idt+198
	movl	$exception25_isr, %eax
	movw	%ax, idt+200
	movl	$-1912602616, idt+210
	shrl	$16, %eax
	movl	$-1912602616, idt+218
	movw	%ax, idt+206
	movl	$exception26_isr, %eax
	movw	%ax, idt+208
	movl	$-1912602616, idt+226
	shrl	$16, %eax
	movl	$-1912602616, idt+234
	movw	%ax, idt+214
	movl	$exception27_isr, %eax
	movw	%ax, idt+216
	shrl	$16, %eax
	movw	%ax, idt+222
	movl	$exception28_isr, %eax
	movw	%ax, idt+224
	shrl	$16, %eax
	movw	%ax, idt+230
	movl	$exception29_isr, %eax
	movw	%ax, idt+232
	shrl	$16, %eax
	movw	%ax, idt+238
	movl	$exception30_isr, %eax
	movw	%ax, idt+240
	shrl	$16, %eax
	movw	%ax, idt+246
	movl	$exception31_isr, %eax
	movl	$-1912602616, idt+242
	movw	%ax, idt+248
	shrl	$16, %eax
	movl	$-1912602616, idt+250
	movw	%ax, idt+254
/APP
/  75 "idt.c" 1
	lidt idtr
/  0 "" 2
/  76 "idt.c" 1
	sti
/  0 "" 2
/NO_APP
	ret
	.size	idt_init, .-idt_init
	.local	idtr
	.comm	idtr,6,4
	.local	idt
	.comm	idt,2048,16
	.ident	"GCC: (GNU) 11.5.0"
