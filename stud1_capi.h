//------------------------------------------------------------------------------
//
// stud1_capi.h
//
// STUD-1 C Application Programming Interface Definition
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//      GLOBAL & EXTERNAL DECLARATIONS
//------------------------------------------------------------------------------

// Input samples. Defined in stud1_proc.asm.
extern int      proc_left_in;
extern int      proc_right_in;

// Output samples Defined in stud1_proc.asm.
extern int      proc_left_out;
extern int      proc_right_out;

// LCD output and delay functions. Defined in stud1_lcd.asm.
extern int      lcd_len;
extern int      lcd_col;
extern int      lcd_row;
extern void     lcd_init(void);
extern void     lcd_print(void);
extern void     wait_10ms(void);
extern void     wait_100us(void);
extern void     wait_250ns(void);

//------------------------------------------------------------------------------
//      CONSTANTS & MACROS
//------------------------------------------------------------------------------

#define DISPLAY_SIZE    16

//------------------------------------------------------------------------------
// LED controls
#define LED_1_ON    asm("AR=0x0002;"); asm("IO(0x002)=AR;"); asm("IO(0x003)=AR;");
#define LED_1_OFF   asm("AR=0x0002;"); asm("IO(0x002)=AR;");
#define LED_2_ON    asm("AR=0x0008;"); asm("IO(0x002)=AR;"); asm("IO(0x003)=AR;");
#define LED_2_OFF   asm("AR=0x0008;"); asm("IO(0x002)=AR;");
#define LED_3_ON    asm("AR=0x0001;"); asm("IO(0x002)=AR;"); asm("IO(0x003)=AR;");
#define LED_3_OFF   asm("AR=0x0001;"); asm("IO(0x002)=AR;");
#define LED_ALL_ON  asm("AR=0x000B;"); asm("IO(0x002)=AR;"); asm("IO(0x003)=AR;");
#define LED_ALL_OFF asm("AR=0x000B;"); asm("IO(0x002)=AR;");


//------------------------------------------------------------------------------
// LCD_SET_CURSOR
//  Macro which sets the cursor position on the LCD display.
//
// Usage:	
//  LCD_SET_CURSOR(row,column);
//    row    : [1,2]
//    column : [1,2,...,15,16]
//
#define LCD_SET_CURSOR(row,column) \
	lcd_row = row;                 \
	lcd_col = column;
	
//------------------------------------------------------------------------------
// LCD_PRINT
//  Macro which outputs a string of tokens on the LCD display. Writes 'length'
//  tokens from starting address 'string' on the current cursor position of
//  the LCD. Note that 'string' must be globally defined.
//
// Usage:	
//  LCD_PRINT(string,length);
//    length : [1,2,...,15,16]
//
#define LCD_PRINT(string,length)       \
	lcd_len = length;                  \
	asm("ENA M_MODE;");                \
    asm("DMPG1 = page(_"#string");");  \
    asm("I2 = _"#string";");           \
    lcd_print();
      
//------------------------------------------------------------------------------
// LCD_SET_CURSOR_PRINT
//  Macro which sets the cursor position on the LCD display and outputs a string
//  of tokens. Writes 'length' tokens from starting address 'string' on the 
//  'row' and 'column' of the LCD. Note that 'string' must be globally defined.
//
#define LCD_SET_CURSOR_PRINT(row,column,string,length) \
	lcd_len = length;                  \
	lcd_row = row;                     \
	lcd_col = column;                  \
	asm("ENA M_MODE;");                \
    asm("DMPG1 = page(_"#string");");  \
    asm("I2 = _"#string";");           \
    lcd_print();
    
//------------------------------------------------------------------------------
//		FUNCTION DECLARATIONS
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// prints()
//  Prints a NULL-terminated string on the LCD display.
//
void prints(const char *s);

//------------------------------------------------------------------------------
// print_hex()
//  Prints a hexadecimal digit on the LCD display.
//
void print_hex(const int h);
