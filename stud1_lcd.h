//------------------------------------------------------------------------------
//
// stud1.h
//
//  Common definitions for the ADSP-2191 Signal Processing board STUD-1.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//			CONSTANTS
//------------------------------------------------------------------------------

#define DISPLAY_SIZE                    16              // Number of characters on a row
#define DISPLAY_CLEAR                   0x0001			// Clear display, cursor home
#define CURSOR_HOME                     0x0002			// Cursor home
#define DISPLAY_ON_CURSOR_OFF_BLINK_OFF 0x000C			// Display ON, cursor and blink OFF
#define FUNCTION_SET_4_BITS             0x0028			// 4 bit data length
#define ENTRY_MODE_INC_NO_SHIFT         0x0006			// Increment, no display shift

//#define DISPLAY_OFF_CURSOR_OFF_BLINK_OFF	0x0008		// Display, cursor and blink OFF
//#define FUNCTION_SET_8_BITS			0x0038			// 8 bit data length

#define	DD_RAM_ADDRESS_SET_40			0x00C0			// Set DDRAM address to 0x40
#define	DD_RAM_ADDRESS_SET_00			0x0080			// Set DDRAM address to 0x00
//#define	DD_RAM_ADDRESS_SET		    0x0080			// Set DDRAM address to 0x00
//#define DISPLAY_SHIFT_RIGHT			0x001C			// Shift display to the right


//------------------------------------------------------------------------------
//		GLOBAL & EXTERNAL DECLARATIONS
//------------------------------------------------------------------------------

.extern     _lcd_str;
.extern     _lcd_len;
.extern     _lcd_col;
.extern     _lcd_row;


.extern     _lcd_init;
.extern     _lcd_clear;
.extern     _lcd_print;
.extern		_wait_10ms;
.extern		_wait_100us;
.extern		_wait_250ns;

//------------------------------------------------------------------------------
//		MACROS
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// LCD_PRINT
//  Macro which outputs a  string of tokens on the 2-line, 16-char LCD display 
//  on the ADSP-2191 Signal Processing board.
//
// Usage:	
//  LCD_PRINT(char_buffer,num_of_chars,linenr,linepos);
//    num_of_chars: 1-16
//    linenr:       1 - 2
//    linepos:      1 - 16
//
//  Writes 'num_of_chars' characters from starting address
//  'char_buffer' on line 'linenr', position 'linepos' on LCD.
//------------------------------------------------------------------------------

#define LCD_PRINT(char_buffer,num_of_chars,linenr,linepos) \
	ENA M_MODE;                \
	DMPG1 = page(char_buffer); \
	I2 = char_buffer;          \
	AX1 = num_of_chars;        \
	DM(_lcd_len) = AX1;        \
	AX1 = linepos;             \
	DM(_lcd_col) = AX1;        \
	AX1 = linenr;              \
	DM(_lcd_row) = AX1;        \
    CALL _lcd_print;

