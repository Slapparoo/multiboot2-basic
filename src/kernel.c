#include "types.h"

#define CRT_VIDEO_MEMORY ((volatile PChar)0xB8000)
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

// PChar SCREEN = ((volatile PChar)0xB8000);

int crt_putChar(uchar c, u8 color, u32 x, u32 y) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT) {
        return 1; // Out of bounds check
    }

    uint index = (y * SCREEN_WIDTH + x) * 2;
    if (index < SCREEN_WIDTH * SCREEN_HEIGHT * 2) {
        CRT_VIDEO_MEMORY[index++] = c;
        CRT_VIDEO_MEMORY[index] = color;
        return 0;
    }
    return 1;
}

void crt_clear_screen(u8 color) {
    uint index = 0;
    for (uint y = 0; y < SCREEN_HEIGHT; ++y) {
        for (uint x = 0; x < SCREEN_WIDTH; ++x) {
            CRT_VIDEO_MEMORY[index++] = ' ';
            CRT_VIDEO_MEMORY[index++] = color;
        }
    }
}


void kernelMain() {
    crt_clear_screen(0);
    crt_putChar('a', 0xf, 10, 10);
}



