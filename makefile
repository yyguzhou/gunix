all: floppy.img

floppy.img: boot.bin setup.bin kernel.bin mkimg
	./mkimg

.s.o:
	as -o $@ $<

boot.bin: boot.o
	ld --oformat binary -Ttext=0x7c00 -o $@  $<

setup.bin: setup.o
	ld --oformat binary -Ttext=0 -o $@ $<

kernel.bin: kernel0.o kernel.o klib_a.o klib_c.o
	ld --oformat binary -Ttext=0 -o $@ kernel0.o kernel.o klib_a.o klib_c.o

.c.o:
	gcc -Wall -c -o $@ $<

mkimg: mkimg.c
	gcc -o $@ $<

clean:
	rm -f *.o *.bin floppy.img mkimg
