;*****************************************************************
;NAME:			cpu_init
;INPUT:			
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		
;*****************************************************************
cpu_init:
clr_writedata00:
        B0MOV   H,#WRITEDATA$M
        B0MOV   L,#WRITEDATA$L
        MOV     A,L
        ADD     A,#0FH
        MOV     N01,A
clr_writedata01:
        CLR     @HL
        INCMS   L
        CJBE_   L,N01,clr_writedata01
clr_receivedata00:
        B0MOV   H,#RECEIVEDATA$M
        B0MOV   L,#RECEIVEDATA$L
        MOV     A,L
        ADD     A,#0FH
        MOV     N01,A
clr_receivedata01:
        CLR     @HL
        INCMS   L
        CJBE_   L,N01,clr_receivedata01
    ;    CJNE	
;;I/O初始
	mov	a,#11011000b
	b0mov	p0m,a           ;设置p0.3 和p0.4和p0.6和p0.7为输出口 	

	mov	a,#00000010b    ;设置p1.1为输出口
	b0mov	p1m,a			
;===============================================================
cpu_init10:
	MOV	A,#00000010b
	b0mov	LCDM2,a			;;2.8V驱动
 ;	mov	A,#0C1H
	mov	A,#049H
	b0mov	LCDM1,a			;;电容式驱动
;===============================================================
cpu_init12:
;;tc0设定
  	mov 	a,#11110000b;    #0E0h ;#11110000B  110为4分频	;Fhosc/4   11110000 2分频    11010000 8分频；改变可控制速度                    
	b0mov 	tc0m,a 			; to set t0 clock = fcpu / 64                                                
	mov	a,#T_10MS                                         
	b0mov	time_10ms,a                                    
               
        mov	a,#080h           ;#01000000B                                     
	b0mov	TC0C,a   ;设TC0的初值
	b0mov	TC0R,a   ;设TCO的预置值
;	b0bset	FTC0ENB    ;使能TCO，允许TC0累加
	B0BSET	FTC0IEN   
;===============================================================
LBT_init:                        
;低电设置
;	MOV	A,#11000011b
;	AND	LBTM,A
	;MOV	A,#00000000b	; LBT < 2.2V
;	MOV	A,#00000100b	; LBT < 2.4V
	;MOV	A,#00001000b	; LBT < 2.6V
	;MOV	A,#00001100b	; LBT < 2.8V
	;MOV	A,#00010000b	; LBT < 3.0V
	;MOV	A,#00010100b	; LBT < 3.2V
	;MOV	A,#00011000b	; LBT < 3.4V
;	MOV	A,#00011100b	; LBT < 3.6V
;	MOV	A,#01100000b	; LBT :P10 Input,P11 connect to GND @FP11IO=1
;	OR	LBTM,A	
;	mov	a,#0A0h 
	mov	a,#085h  ;a=#01000101B
	b0mov	LBTM,A
;===============================================================
UART_Init:   
;	mov	A,#0xDD		;UART Baud Rate=115200	
	mov	A,#0xE6		;UART Baud Rate=9600		
	b0mov	URCR,A
	mov	A,#00000100b	;Fuart=Fhosc/1=8MHz
;	mov	A,#00000000b	;Fuart=Fhosc/1=8MHz
	MOV	URRX,A

;	b0bclr	FUTXIRQ		;UART transmit interrupt request
;	b0bset	FUTXIEN		;Enable UART transmit interrupt function
;	b0bclr	FUTXIEN		;Disable UART transmit interrupt function.
//	b0bset	FUTXEN		;Enable UART TX. UTX pin exchanges from GPIO mode to UART TX mode and idle high status
 

	b0bclr	FURXIRQ		;UART receive interrupt request
;	b0bset	FURXIEN		;Enable UART receive interrupt function
	b0bset	FURXIEN		;Disable UART receive interrupt function
	b0bset	FURXEN		;Enable UART RX. URX pin exchanges from GPIO mode to UART RX mode
;;***************************************
cpu_init13:
	call	init_cpr		;;初始化cpr
	call	init_TS	 
;;******************************************
cpu_init14:
	b0bset	fgie
;================================================================
cpu_init20:
	mov	a,#0fh
	call	fill_lcd_ram	 	;;全显示
 	call	enable_grn_led
;================================================================
cpu_init30:
	b0bts1	key_on_off
	jmp	cpu_init30
	call	update_timer	
sys_init90:
	ret		
;---------------------------------------------------------------
;Voltage Charge Pump / Regulator (CPR) INIT
;---------------------------------------------------------------
init_cpr:
;========= BandGap Voltage ===============	
	B0BSET	FBGRENB		; Enable Band Gap Reference voltage
 	MOV	A,#089h
	B0MOV	VREG,A		;AVDDR=2.4V，AVE=1V
	B0BSET	FAVENB		; AVE Enable
	B0BSET	FAVDDRENB	; AVDDR Enable
	call	wait10ms
;****************************************************************
;NAME:			update_timer
;INPUT:			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;****************************************************************
update_timer00:
	b0bset	f_flash	
	B0MOV_	flash_buf,#T_flash
update_timer:	
	B0MOV_	timer_buf1,#100	;update auto turn off timer
update_timer10:
	b0mov	rbank,#01
	MOV	A,#60
	MOV	timer_buf3,A
	MOV	min,A
	mov	a,#05
	b0mov	bl_base_time_buf,a
update_timer20:
	b0mov	rbank,#01
	mov	a,turn_off_time
	b0mov	timer_buf2,a
	b0mov	rbank,#00
update_timer90:	
	ret
;*********************************************************************************
;NAME:			init_ts
;INPUT:			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;*********************************************************************************
;*********************************************************************************
;NAME:			init_ts
;INPUT:			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;*********************************************************************************
init_ts:	
	call	wait10ms
	mov	a,#0ABH		;;TS: Al3 - Al4
init_ts01:
	B0MOV	CHS,A			;;TS: Al3 - Al4
init_ts10:

	B0MOV	RBANK,#01
	mov	a,init_ts_cnt		;;delay:16*1/20=0.8s	
	b0mov	sample_counter,a	;;
	MOV	A,TS_AMPM
init_ts80:
	B0MOV	AMPM,A
	MOV	A,ADCM_1
	B0MOV	ADCM1,A
	MOV	A,ADCM_2
	B0MOV	ADCM2,A
 	B0MOV	RBANK,#00H

	B0BSET	FACHPENB	; ADC Chopper Enable (always set "1")
	B0BSET	FADCENB		; Enable ADC function
	ret
;**************************************************************
;NAME:			init_tp
;INPUT:			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;**************************************************************
init_tp:
	clr	tpadc_counter
	mov	a,#089H
	B0MOV	CHS,A			;;TP: Al1 - Al2

	b0mov	rbank,#01
	mov	a,init_tp_cnt		;delay:16*1/25=0.6
	b0mov	sample_counter,a	;;

	B0BSET	FPCHPENB		; Enable PGIA chopper function
	B0BSET	FAMPENB			; Enable PGIA function

	MOV	A,TP_AMPM
	jmp	init_ts80
;****************************************************************
clr_ram:
	b0mov	z,#CLR_RAM_START1$l
	b0mov	y,#001h			;clear	bank1
	mov	a,#00
	call	fill_ram_block
clr_ram10:
	b0mov	y,#00h			;clear	bank0	
	b0mov	z,#CLR_RAM_START
	call	fill_ram_block
;;***************************************
fill_lcd_ram:
	b0mov	y,#0fh			;clear	bank15:lcd ram
	b0mov	z,#0fh
fill_ram_block:
	mov	@yz,a
	decms	z
	jmp	fill_ram_block
	mov	@yz,a
  	ret
;****************************************************************
;NAME:			DELAY10
;INPUT:			A
;FUNCTION:		DELAY TIME
;DESCRIBE:		(A)*10MS	MAX:256*10MS=2560MS=2.56S
;CALL SUBPROGRAM:	WAIT10MS
;USING RESOURCE:	R7,R6,WK07
;STACK NEED:		0 
;OUTPUT:		NONE
;*****************************************************************
delay10ms:
        MOV     A,#1
        JMP     DELAY
delay300ms:
	mov	a,#13
	jmp	delay
delay500ms:
	mov	a,#50
	jmp	delay
delay1s:
	mov	a,#200
delay:
	b0mov	wk10,a
delay20:
	call	wait10ms
	decms	wk10
	jmp	delay20
	ret
;******************************************************************
;NAME:			WAIT10MS
;INPUT:			CRYSTAL_VAL*250/2/INSTRUCTION_CYCLE
;FUNCTION:		DELAY TIME
;DESCRIBE:		10MS
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	R7,R6,WK07
;STACK NEED:		0
;OUTPUT:		NONE
;******************************************************************	
wait10ms:	
	mov	a,#18		;;2M
wait20:
	b0mov	wk09,a
	clr	wk08
wait21:
wait30:		
	decms	wk08		;1	;(4*256+1+1+2+1)*18+1+1=1028*18+2=10.051ms
	jmp	wait30		;2	
wait40:
 	decms	wk09
	jmp	wait21
	ret
;******************************************************************
;NAME:			rolling_code_sum
;INPUT:			
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		a
;******************************************************************
enable_red_led:
	b0bset	green_led
	jmp	enable_yellow_led10
;******************************************************************		
enable_grn_led:	
	b0bclr	green_led
	jmp	b0bclr_led10
;******************************************************************
enable_yellow_led:
	b0bclr	green_led		;;黄灯
enable_yellow_led10:
	b0bclr	red_led
	jmp	b0bclr_led20		
;******************************************************************https://mini.eastday.com/a/n190313073950217.html?qid=03123
b0bclr_led:
	b0bset	green_led
b0bclr_led10:
	b0bset	red_led
b0bclr_led20:
	ret
;********************************************************************************






