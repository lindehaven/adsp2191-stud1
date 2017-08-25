rem Build

rem Compile C code and make intermediate assembler code
cc219x -c .\stud1_capi.c -save-temps -path-output .\Build -proc ADSP-2191 -o .\Build\stud1_capi.doj -MM
cc219x -c .\stud1_user_app.c -save-temps -path-output .\Build -proc ADSP-2191 -o .\Build\stud1_user_app.doj -MM


rem Make object files from assembler code
easm219x -proc ADSP-2191 -i. stud1_capi.s     -o .\Build\stud1_capi.doj
easm219x -proc ADSP-2191 -i. stud1_user_app.s -o .\Build\stud1_user_app.doj
easm219x -proc ADSP-2191 -i. stud1_init.asm   -o .\Build\stud1_init.doj
easm219x -proc ADSP-2191 -i. stud1_isr.asm    -o .\Build\stud1_isr.doj
easm219x -proc ADSP-2191 -i. stud1_lcd.asm    -o .\Build\stud1_lcd.doj
easm219x -proc ADSP-2191 -i. stud1_main.asm   -o .\Build\stud1_main.doj
easm219x -proc ADSP-2191 -i. stud1_proc.asm   -o .\Build\stud1_proc.doj
easm219x -proc ADSP-2191 -i. stud1_re.asm     -o .\Build\stud1_re.doj

rem Link all object files into on .dxe file
linker -DADSP-2191 -t -T stud1.ldf -o .\Build\stud1.dxe .\Build\stud1_init.doj .\Build\stud1_isr.doj .\Build\stud1_lcd.doj .\Build\stud1_main.doj .\Build\stud1_proc.doj .\Build\stud1_re.doj .\Build\stud1_capi.doj .\Build\stud1_user_app.doj -Map .\Build\stud1_map.xml

rem Make a loadable .bin file
elfloader .\Build\stud1.dxe -b SPI -f BINARY -width 8 -proc ADSP-2191 -o .\Build\stud1.bin
