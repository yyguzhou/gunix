INITSEG = 0x9000
KERNSEG	= 0xffff
KERNOFF	= 0x0010

	.arch i386
	.text
	.code16

	.global _start
_start:
	mov $INITSEG, %ax
	mov %ax, %ds
	
	mov $hello, %si
	call PrintStr
	
# enable A20
	call Empty8042
	movb $0xd1, %al
	outb %al, $0x64
	call Empty8042
	movb $0xdf, %al
	outb %al, $0x60
	call Empty8042
	
# load kernel to 0x100000
	mov $KERNSEG, %ax
	mov %ax, %es
	mov $KERNOFF, %bx
	mov $0x0202, %ax
	xor %dx, %dx
	mov $0x0003, %cx
	int $0x13
	
	cli

	lgdt gdt_seg

	movl %cr0, %edx
	orl $1, %edx
	movl %edx, %cr0
	
	mov $gdt_video, %ax
	mov %ax, %gs
	mov $gdt_stack, %ax
	mov %ax, %ss
	movl $0x0800, %esp

	ljmp $8, $0

Hung:	.long 0x00eb00eb
	jmp  Hung

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

Empty8042:
	.long 0x00eb00eb
	inb $0x64, %al
	testb $2, %al
	jnz Empty8042
	ret
	
hello:	.asciz "OS initing...\r\n"

gdt_seg:
	.word gdt_end-gdt-1
	.long INITSEG*16+gdt
gdt:	.long 0
	.long 0
	gdt_code = .-gdt
	.long 0x000007ff
	.long 0x00cf9a10
	gdt_data = .-gdt
	.long 0x000007ff
	.long 0x00cf9210
	gdt_video = .-gdt
	.long 0x800007ff
	.long 0x0000920b
	gdt_stack = .-gdt
	.long 0x000007ff
	.long 0x00cf9290
gdt_end:
