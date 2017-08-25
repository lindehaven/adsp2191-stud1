//------------------------------------------------------------------------------
//
// stud1_capi.c
//
// STUD-1 C Application Programming Interface Implementation
//
//------------------------------------------------------------------------------

#include "stud1_capi.h"

//------------------------------------------------------------------------------
char char_buffer[DISPLAY_SIZE];     // Must be globally defined for LCD_PRINT().
void prints(const char *string) {
    int i;
    for (i = 0; (i < DISPLAY_SIZE) && (i < strlen(string)); i++) {
        char_buffer[i] = string[i] & 0xFF;
    }
    LCD_PRINT(char_buffer,strlen(string));
}

//------------------------------------------------------------------------------
void print_hex(const int h) {
    switch (h & 0xF) {
        case  0: prints("0"); break;
        case  1: prints("1"); break;
        case  2: prints("2"); break;
        case  3: prints("3"); break;
        case  4: prints("4"); break;
        case  5: prints("5"); break;
        case  6: prints("6"); break;
        case  7: prints("7"); break;
        case  8: prints("8"); break;
        case  9: prints("9"); break;
        case 10: prints("A"); break;
        case 11: prints("B"); break;
        case 12: prints("C"); break;
        case 13: prints("D"); break;
        case 14: prints("E"); break;
        case 15: prints("F"); break;
        default: break;
    }
}

