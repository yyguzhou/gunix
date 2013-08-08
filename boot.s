STKSEG = 0x4000
INITSEG = 0x9000

	.text
	.code16

	.global _start
_start:	
	.org 0

	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	
	mov $STKSEG, %ax
	mov %ax, %ss
	xor %sp, %sp
	
	call Clear
	
	mov $hello, %si
	call PrintStr

	mov $INITSEG, %ax
	mov %ax, %es
	xor %bx, %bx
	mov $0x0201, %ax
	xor %dx, %dx
	mov $0x0002, %cx
	int $0x13

	ljmp $INITSEG, $0

Hung:	.long 0x00eb00eb
	jmp Hung

PrintStr:
	mov $0xe, %ah
	mov $0x7, %bx
1:	movb (%si), %al
	orb %al, %al
	jz 2f
	int $0x10
	inc %si
	jmp 1b
2:	ret

Clear:
	mov $0x0600, %ax
	movb $0x7, %bh
	xor %cx, %cx
	mov $0x184f, %dx
	int $0x10
	movb $0x2, %ah
	xorb %bh, %bh
	xor %dx, %dx
	int $0x10
	ret

hello:	.asciz "OS booting...\r\n"

	.org 510
	.word 0xaa55
