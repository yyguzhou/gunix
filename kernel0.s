KERNSEG	= 0x100000
SELECTOR = 8

	.arch i386
	.text
	.code32

	.global _start
_start:
	mov $SELECTOR, %ax
	mov %ax, %ds
	mov %ax, %es

	call Init8259a
	lidtl idt_seg
	sti

	mov $0x0741, %dx
	call kmain

Hung:	.long 0x00eb00eb
	jmp Hung
	
Init8259a:
	movb $0x11, %al
	outb %al, $0x20
	.long 0x00eb00eb
	movb $0x20, %al
	outb %al, $0x21
	.long 0x00eb00eb
	movb $0x04, %al
	outb %al, $0x21
	.long 0x00eb00eb
	movb $0x01, %al
	outb %al, $0x21
	.long 0x00eb00eb
	movb $0b11111110, %al
	outb %al, $0x21
	.long 0x00eb00eb
	retl

TimerISR:
	cli
	movw %dx, %gs:320
	incb %dl
	movb $0x20, %al
	outb %al, $0x20
	sti
	iretl
	
DummyISR:
	iretl

hello:	.asciz "OS starting...\r\n"

idt_seg:
	.word idt_end-idt-1
	.long KERNSEG+idt
idt:	.rept 0x20
	.word DummyISR
	.word SELECTOR
	.word 0xee00
	.word 0
	.endr
	.word TimerISR
	.word SELECTOR
	.word 0xee00
	.word 0
idt_end:
