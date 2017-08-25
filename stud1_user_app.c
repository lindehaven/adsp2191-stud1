//------------------------------------------------------------------------------
//
// stud1_user_app.c
//
// STUD-1 User Application
//
//------------------------------------------------------------------------------

#include "stud1_capi.h"


//------------------------------------------------------------------------------
// user_app_initialize(void)
//
// This function is called from stud1_main.asm when the STUD-1 board has been
// initialized and is ready for processing.
//------------------------------------------------------------------------------
void user_app_initialize(void) {
    
    LCD_SET_CURSOR(1,1)
    prints("[ STUD-1 C API ]");
    LCD_SET_CURSOR(2,1)
    prints("[ 13 Mar 2007  ]");
    LED_ALL_OFF;
    
}


//------------------------------------------------------------------------------
// user_app_loop(void)
//
// This function is called repeatedly from the main loop in stud1_main.asm.
// The main loop polls the rotary encoders, calls this function and then idles
// until an ADC interrupt occurs. The function is intended for performing tasks
// that are not time critical.
//------------------------------------------------------------------------------
void user_app_loop(void) {
    //
}


//------------------------------------------------------------------------------
// user_app_process_sample(void)
//
// This function is called from stud1_proc.asm each time an ADC interrupt
// occurs. The function needs to be fast enough to process and return before
// next interrupt occurs. The function is intended for processing the input
// samples from the ADC and send the processed output to the DAC.
//------------------------------------------------------------------------------
void user_app_process_sample(void) {
    
    // Just pass input signals through.
    proc_left_out  = proc_left_in;
    proc_right_out = proc_right_in;

}

//------------------------------------------------------------------------------
// user_app_handle_push1(void)
//
// This function is called from stud1_main.asm when rotary encoder 1 has been
// pushed.
//------------------------------------------------------------------------------
void user_app_handle_push1(void) {
    //
}

//------------------------------------------------------------------------------
// user_app_handle_cw1(void)
//
// This function is called from stud1_main.asm when rotary encoder 1 has been
// turned clockwise.
//------------------------------------------------------------------------------
void user_app_handle_cw1(void) {
    //
}

//------------------------------------------------------------------------------
// user_app_handle_ccw1(void)
//
// This function is called from stud1_main.asm when rotary encoder 1 has been
// turned counter-clockwise.
//------------------------------------------------------------------------------
void user_app_handle_ccw1(void) {
    //
}

//------------------------------------------------------------------------------
// user_app_handle_cw2(void)
//
// This function is called from stud1_main.asm when rotary encoder 2 has been
// turned clockwise.
//------------------------------------------------------------------------------
void user_app_handle_cw2(void) {
    //
}

//------------------------------------------------------------------------------
// user_app_handle_ccw2(void)
//
// This function is called from stud1_main.asm when rotary encoder 2 has been
// turned counter-clockwise.
//------------------------------------------------------------------------------
void user_app_handle_ccw2(void) {
    //
}


