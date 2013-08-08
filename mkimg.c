#include <stdio.h>
#include <string.h>

int main()
{
    int n, bytes, times;
    FILE *img = fopen("floppy.img", "wb+");
    FILE *sec1 = fopen("boot.bin", "rb");
    FILE *sec2 = fopen("setup.bin", "rb");
    FILE *sec3 = fopen("kernel.bin", "rb");

    char buf[512];
    memset(buf, 0, sizeof(buf));
    n = fread(buf, 1, sizeof(buf), sec1);
    printf("sec1 %d bytes\n", n);
    n = fwrite(buf, 1, 512, img);
    printf("write %d bytes\n", n);
    
    bytes = 0;
    times = 0;
    do {
        memset(buf, 0, sizeof(buf));
        n = fread(buf, 1, sizeof(buf), sec2);
        bytes += n;
        fwrite(buf, 1, 512, img);
        ++times;
    } while (n == sizeof(buf));
    printf("sec2 %d bytes, write %d times\n", bytes, times);
    
    bytes = 0;
    times = 0;
    do {
        memset(buf, 0, sizeof(buf));
        n = fread(buf, 1, sizeof(buf), sec3);
        bytes += n;
        fwrite(buf, 1, 512, img);
        ++times;
    } while (n == sizeof(buf));
    printf("sec3 %d bytes, write %d times\n", bytes, times);

    fclose(img);
    fclose(sec1);
    fclose(sec2);
    fclose(sec3);

    return 0;
}
