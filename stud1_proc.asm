//------------------------------------------------------------------------------
//
// stud1_proc.asm
//
//------------------------------------------------------------------------------

#include 	"def2191.h"

//------------------------------------------------------------------------------
//		GLOBAL & EXTERNAL DECLARATIONS FOR THE USER APPLICATION
//------------------------------------------------------------------------------

// Application callback function
.extern		_user_app_process_sample;

// Global variables for use by the application
.global		_proc_left_in;
.global		_proc_right_in;
.global		_proc_left_out;
.global		_proc_right_out;


//------------------------------------------------------------------------------
//			CONSTANTS & MACROS
//------------------------------------------------------------------------------

// AD1885 TDM Timeslot Definitions
#define		TAG_PHASE				0
#define		COMMAND_ADDRESS_SLOT	1
#define		COMMAND_DATA_SLOT		2
#define		STATUS_ADDRESS_SLOT		1
#define		STATUS_DATA_SLOT		2
#define		LEFT					3
#define		RIGHT					4

// Left and Right ADC valid Bits used for testing of valid audio data in current TDM frame
#define		M_Left_ADC		12
#define		M_Right_ADC		11


//------------------------------------------------------------------------------
//		GLOBAL & EXTERNAL DECLARATIONS
//------------------------------------------------------------------------------

// Global symbols that is required by the STUD-1 board support package
.global		Process_AD1885_Audio_Samples;
.global		IOPG_TMP;

// External symbols that is declared in the STUD-1 board support package
.extern		tx_buf;
.extern		rx_buf;


//------------------------------------------------------------------------------
//			DM DATA
//------------------------------------------------------------------------------
.SECTION/DATA data1;

// AD1885 stereo-channel data holders for processing of audio data recieved from codec

// Input samples
.var 		_proc_left_in;
.var 		_proc_right_in;

// Output samples
.var 		_proc_left_out;
.var 		_proc_right_out;

.var 		IOPG_TMP;


//------------------------------------------------------------------------------
//			PM
//------------------------------------------------------------------------------
.SECTION/CODE program;


//------------------------------------------------------------------------------
// Interrupt routine for processing audio samples
//------------------------------------------------------------------------------

Process_AD1885_Audio_Samples: 	
	ax0 = 0x8000;               		// Clear all AC97 link Audio Output Frame slots
	dm(tx_buf + TAG_PHASE) = ax0;		// and set Valid Frame bit in SLOT '0' TAG phase
	ax0 = 0;
	dm(tx_buf + COMMAND_ADDRESS_SLOT) = ax0;
	dm(tx_buf + COMMAND_DATA_SLOT) = ax0;
	dm(tx_buf + LEFT) = ax0;
	dm(tx_buf + RIGHT) = ax0;

Check_ADCs_For_Valid_Data:
	ax0 = dm(rx_buf + TAG_PHASE);       // Get ADC valid bits from tag phase slot
	ax1 = 0x1800;                		// Mask other bits in tag
 	ar = ax0 and ax1;	

Set_TX_Slot_Valid_Bits:
	ay1 = dm(tx_buf + TAG_PHASE);		// Frame/Addr/Data valid bits
	ar = ar or ay1;            			// Set TX valid bits based on Recieve TAG info
	dm(tx_buf + TAG_PHASE) = ar;

Check_AD1885_ADC_Left:                         		
	AR = TSTBIT M_Left_ADC of ax0;		// Check Left ADC valid bit
	IF EQ JUMP Check_AD1885_ADC_Right;  // If valid data then save ADC sample
	ax1 = dm(rx_buf + LEFT);			// Get AD1885 Left channel input sample
	dm(_proc_left_in) = ax1;				// Save to data holder for processing


Check_AD1885_ADC_Right:                        				
	AR = TSTBIT M_Right_ADC of ax0;		// Check Right ADC valid bit
	IF EQ JUMP Valid_Frame;       		// If valid data then save ADC sample
  	ax1 = dm(rx_buf + RIGHT);			// Get AD1885 Right channel input sample
	dm(_proc_right_in) = ax1; 			// Save to data holder for processing


Playback_Audio_Data:

	// Output to tx_buf is set first to give the DMA transfers enough time.
	AR = DM(_proc_right_out); 			 
	DM(tx_buf + RIGHT) = AR;		// ...output Right data	
	AR = DM(_proc_left_out);
	DM(tx_buf + LEFT) = AR;			// ...output Left data 

//------------------------------------------------------------------------------
// 	The user application callback function that processes each sample.
//------------------------------------------------------------------------------
	CALL _user_app_process_sample;	

	
// Do some house keeping prior to the return from interrupt
Valid_Frame:
	ay1=3;							// Clear RX Interrupts 
  	io(SP0DR_IRQ)=ay1;
	AY1 = DM(IOPG_TMP);
	IOPG = ay1;
	DIS SEC_REG;					// Disable Secondary Registers 
	RTI;

Process_AD1885_Audio_Samples.END:
