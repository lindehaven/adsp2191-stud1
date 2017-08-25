//------------------------------------------------------------------------------
//
// stud1_main.asm
//
//------------------------------------------------------------------------------

#include 	"def2191.h"
#include 	"stud1_lcd.h"

//------------------------------------------------------------------------------
//		GLOBAL & EXTERNAL DECLARATIONS FOR THE USER APPLICATION
//------------------------------------------------------------------------------

// Application callback functions
.extern		_user_app_initialize;
.extern		_user_app_loop;
.extern		_user_app_handle_push1;
.extern		_user_app_handle_cw1;
.extern		_user_app_handle_ccw1;
.extern		_user_app_handle_cw2;
.extern		_user_app_handle_ccw2;

//------------------------------------------------------------------------------
//			CONSTANTS & MACROS
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//		GLOBAL & EXTERNAL DECLARATIONS
//------------------------------------------------------------------------------

// Global symbols that are required by the STUD-1 board support package
.global	 	Start;
.global     PUSH1;
.global     CW1;
.global     CCW1;
.global     CW2;
.global     CCW2;

// External symbol that is declared in the Linker Definition File (.ldf).
.extern		ldf_stack_base;

// External symbols that is declared in the STUD-1 board support package
.extern		Change_PLL_Multiplier;
.extern 	Codec_Reset;
.extern		Program_SPORT0_Registers;
.extern		Program_DMA_Controller;
.extern		AD1885_Codec_Initialization;
.extern		RX_Status;
.extern		Poll_Rotary_Encoder1;
.extern		Poll_Rotary_Encoder2;
.extern     Check_Rotary_Encoder1_Push;

	
//------------------------------------------------------------------------------
//			PM
//------------------------------------------------------------------------------
.SECTION/CODE program;

//------------------------------------------------------------------------------
// Program execution starts here after the STUD-1 board has been initialised
//------------------------------------------------------------------------------

Start:
	// Change the multiplier of the processor. External clock is only 16 MHz.
	call Change_PLL_Multiplier;
	// Reset the codec
	call Codec_Reset;
	// Initialize SPORT0 for codec communications 
	call Program_SPORT0_Registers;
	// Start Serial Port 0 tx and rx DMA Transfers 
	call Program_DMA_Controller;
	// Initialize & program AD1885
	call AD1885_Codec_Initialization;
   
	// Set direction of flagpins
	IOPG = General_Purpose_IO;
   	nop;
  	ar = 0xFC8B;
	IO(DIRS) = AR;

	// Initialize the LCD
	call _lcd_init;

    // Turn off all LED's on STUD-1 board
    AR = 0x000B;
    IO(FLAGC) = AR;	
	
	// Clear RX_Status flag indicating incoming RX data are audio data and
	// can be processed accordingly 
	ax0=0x0000;
	dm(RX_Status) = ax0;

	// Set stack pointer for C functions at the stack base that is located at the
	// highest address of the stack. The staclk grows towards lower addresses.
	I4 = ldf_stack_base;
	
	// Frame pointer for C functions (that can be read about somewhere...)
	I5 = ldf_stack_base;
	
	// Parameter address step for C functions. Always set to -1 for the cc219x
	// compiler that grows the stack from high addresses towards lower addresses.
	M5 = -1;
	
	// Initialise the user application
	call _user_app_initialize;
	
//------------------------------------------------------------------------------
// Go into an infinite program loop after initialisation...
//------------------------------------------------------------------------------
wait_forever:

	idle;						

	call	Poll_Rotary_Encoder1;
	call	Poll_Rotary_Encoder2;
	call	Check_Rotary_Encoder1_Push;	

	call	_user_app_loop;

	jump wait_forever;


//------------------------------------------------------------------------------
// Push button on RE 1 has been pressed, handle it here
//------------------------------------------------------------------------------
PUSH1:                        
	call _user_app_handle_push1;
    RTS;

//------------------------------------------------------------------------------
// RE 1 has been turned Clock-Wise, handle it here
//------------------------------------------------------------------------------
CW1:
	call _user_app_handle_cw1;
    RTS;
	
//------------------------------------------------------------------------------
// RE 1 has been turned Counter-Clock-Wise, handle it here
//------------------------------------------------------------------------------
CCW1:
	call _user_app_handle_ccw1;
    RTS;

//------------------------------------------------------------------------------
// RE 2 has been turned Clock-Wise, handle it here
//------------------------------------------------------------------------------
CW2:
	call _user_app_handle_cw2; 
	RTS;

//------------------------------------------------------------------------------
// RE 2 has been turned Counter-Clock-Wise, handle it here
//------------------------------------------------------------------------------
CCW2:
	call _user_app_handle_ccw2;
	RTS;

