#include "klib.h"

#define DISP_MAX_X  25
#define DISP_MAX_Y  80

void DispChar(INT8U x, INT8U y, INT8U c, INT8U color)
{
    INT16U off = (x * DISP_MAX_Y + y) * 2;
    asm volatile ("mov %%ax, %%gs:(%1)" :: "a" ((color << 8) | c), "D" (off));
}
