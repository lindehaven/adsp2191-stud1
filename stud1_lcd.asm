/*****************************************************************************

	stud1_lcd.asm

	Routines for handling the 2-line, 16-char LCD (L1672) on the STUD-1 board
	
*****************************************************************************/

#include "def2191.h"
#include "stud1_lcd.h"

// D7-4 PF10-13
// E 	PF14    
// RS	PF15    

#define		e_flagnr		0x4000 //
#define		rs_flagnr		0x8000 //

// Global symbols
.global		_lcd_print;
.global 	_lcd_init;
.global 	_lcd_clear;
.global		_wait_10ms;
.global		_wait_100us;
.global		_wait_250ns;

.global		_lcd_len;
.global		_lcd_row;
.global		_lcd_col;
.global		lcd_putchar;
.global		lcd_token;

.global		Set_RS;
.global		Clear_RS;


// External symbols

/******************** Data Memory Variables ***********************************/
.SECTION/DATA data1;

.var		_lcd_len = 0;
.var		_lcd_row = 1;
.var		_lcd_col = 1;
.var 		lcd_token;

/******************** Program Code *********************************************/
.SECTION/CODE program;

// ****************************************************************************					
// Print LCD tokens pointed to with I2.
// ****************************************************************************	   
_lcd_print:
	L2 = 0;
	M2 = 1;
	CALL Clear_RS;
	AR = DM(_lcd_row);
	AR = AR -1;
	MX0 = AR;
	MY0 = 0x0040;
	MR = MX0 * MY0 (SS);
	AX0 = MR0;
	DIS M_MODE;
	AR = DM(_lcd_col);
	AR = AR - 1;
	AY0 = AR;
	AR = AX0 + AY0;
	AX0 = AR;
	AY0 = 0x0080;
	AR = AX0 OR AY0;
	AX1 = AR;
	CALL lcd_putchar;
	CALL Set_RS;
	AR = DM(_lcd_len);
	CNTR = AR;
	DO sendtokensloop UNTIL CE;
		AX1 = DM(I2+=M2);
		CALL lcd_putchar;
		sendtokensloop: nop;
	RTS;

// ****************************************************************************			
// Set data length to 4 bits and clear display (reset LCD module) 
// ****************************************************************************	
_lcd_init:
	
	IOPG = General_Purpose_IO;
   	
	AX1 = e_flagnr;
    IO(FLAGC) = AX1;					    // Make sure E=0
	
	CALL Clear_RS;							// Make sure RS=0
	
	// ******* Reset sequence ******************
	CALL _wait_10ms;
	CALL _wait_10ms;
	CALL _wait_10ms;
				
	AX1 = 0x33;
	CALL lcd_putchar;
	CALL _wait_10ms;
	
	AX1 = 0x32;
	CALL lcd_putchar;
	CALL _wait_10ms;
	// *****************************************		

	// ******* Instr. set: DL = 4 bits *********
	AX1 = FUNCTION_SET_4_BITS;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************

	// ******* Entry mode set ******************
	AX1 = ENTRY_MODE_INC_NO_SHIFT;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************

	// ******* Display on **********************
	AX1 = DISPLAY_ON_CURSOR_OFF_BLINK_OFF;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************

// ****************************************************************************
// Clear LCD display		
// ****************************************************************************			
_lcd_clear:
	// ******* Clear display *******************
	AX1 = DISPLAY_CLEAR;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************
	
	// ******* Cursor home *********************
	AX1 = CURSOR_HOME;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************
	
	// ******* Cursor set  *********************
	AX1 = 0xC0;
	CALL lcd_putchar;
	CALL _wait_100us;
	// *****************************************

	CALL _wait_10ms;
	CALL _wait_10ms;
	CALL _wait_10ms;
	
	RTS;

	
// ****************************************************************************			
// Clear RS bit 
// ****************************************************************************			
Clear_RS:	
	AX1 = rs_flagnr;
    IO(FLAGC) = AX1;	
	CALL _wait_250ns;		
	RTS;
	
// ****************************************************************************			
// Set RS bit 
// ****************************************************************************			
Set_RS:
	AX1 = rs_flagnr;
    IO(FLAGS) = AX1;	
	CALL _wait_250ns;		
	RTS;

	          
// ****************************************************************************					
// Send LCD token stored in AX1
// ****************************************************************************					
lcd_putchar:
	
	ax0 = 0x3C00;
	IO(FLAGC) = ax0;		// Clear data bits
	
	DM(lcd_token) = AX1;	
	ay0 = 0x00F0;
	ar = ax1 and ay0;
	si = ar;
	sr = lshift si by 6 (LO);
	ax0 = sr0;
	ay0 = IO(FLAGS);
	ar = ax0 or ay0;
	IO(FLAGS) = ar;		
		
	//////// E cycle	
	AX1 = e_flagnr;
    IO(FLAGS) = AX1;	
	CALL _wait_250ns;
	AX1 = e_flagnr;
    IO(FLAGC) = AX1;					
	CALL _wait_250ns;
  	   	
	
	ax0 = 0x3C00;
	IO(FLAGC) = ax0;		// Clear data bits
	
	AX1 = DM(lcd_token);	
	ay0 = 0x000F;
	ar = ax1 and ay0;
	si = ar;
	sr = lshift si by 10 (LO);
	ax0 = sr0;
	ay0 = IO(FLAGS);
	ar = ax0 or ay0;
	IO(FLAGS) = ar;		
		
	
	//////// E cycle
	AX1 = e_flagnr;
    IO(FLAGS) = AX1;								// Toggle Enable pin
    CALL _wait_250ns;	
	AX1 = e_flagnr;
    IO(FLAGC) = AX1;
	CALL _wait_250ns;
	CALL _wait_250ns;
	CALL _wait_250ns;
	RTS;

	
// ****************************************************************************	
// Delay (at least) 10 ms
// ****************************************************************************	
_wait_10ms:	
	CNTR = 150;
	DO tenmsloop UNTIL CE;
		CALL _wait_100us;
		tenmsloop: nop;
	RTS;
	
// ****************************************************************************	
// Delay (at least) 100 us
// ****************************************************************************	
_wait_100us:	
	CNTR = 8000;
	DO hundredusloop UNTIL CE;
		nop; 
		hundredusloop: nop;
	RTS;
	
// ****************************************************************************	
// Delay (at least) 250 ns
// ****************************************************************************	
_wait_250ns:
	CNTR = 3000;  // 20 org
	DO loop_1 UNTIL CE;
		nop;
		loop_1: nop;
	RTS;
	
