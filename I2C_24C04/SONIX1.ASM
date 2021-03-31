 /*
*****************************************************************************************
*											*
* 					Name:		Ear_four			*
*					Customer:					*
*					Chip: 		SN8P2977			*
*					Fcry: 		Internal 8MHz			*
*					Revision: 	2015/01/12 V1.0			*
*					Author:		Jocab				*
*					Email:		mengliang_tan@szsealight.com.cn	*
*											*
*					TEL:		15012712328			*
*											*
*****************************************************************************************		
|    Version	|     Date	|		   Description				|
*****************************************************************************************
|	V1.0	|  2019/08/31	|1,第一版本						|
|		|		|2,							|	
|		|		|3,						 	|
|		|		| 							|
|		|		|  							|
|		|		|V10:EPROM Check Sum is DA09.				|
|		|		|Security Check Sum is F49B				|
*****************************************************************************************
*/					
	VERSION		EQU	100204H	;H:百为表示与24C04对应为，如有改动24C04则变动， 十位、l个位表示程序版本
	ICE_MODE	EQU	0	;烧片子：将ICE_MODE置 0
	ENC_MODE	EQU	0	;IC加密，1，不加
  CHIP	SN8P2977A
//{{SONIX_CODE_OPTION
	.Code_Option	Low_Power	Enable
	.Code_Option	Watch_Dog	Disable
	.Code_Option	High_Clk	IHRC
	.Code_Option	High_Clk_DIV	Fhosc/4
	.Code_Option	Security	Enable
//}}SONIX_CODE_OPTION
.NOLIST
	INCLUDESTD	macro1.h
	INCLUDESTD	macro2.h
	INCLUDESTD	macro3.h
	INCLUDE		my.h
.list 
	include		equ.asm 
;;----------------------------------
	include		ram.asm
;;----------------------------------
.code 
reset0:
	org		00 
       	nop
  	b0mov		pflag,#00h		;pflag = x,x,x,x,x,c,dc,z
 	b0bset		f_power_on		;1-power on reset 
    	jmp		MAIN			;;复位
	org		08
	include		interrupt.asm		  
 	include		table.asm 
	include		table2.asm
	include		table3.asm  
	include		math.asm 
	include		main.asm 
	include		init.asm
	include		read_key.asm
	;include		buzzer.asm
	include		display.asm
	include		key_app.asm
	include		lcd.asm
        INCLUDE         I2C.ASM	
;;----------------------------------		
ENDP