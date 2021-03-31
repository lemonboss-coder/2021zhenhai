.DATA
ORG	00H
	wk00		ds	1	;system ram
	wk01		ds	1
	wk02		ds	1
	wk03		ds	1
	wk04		ds	1
	wk05		ds	1
	wk06		ds	1
	wk07		ds	1	
	wk08		ds	1
	wk09		ds	1
	wk10		ds	1
	wk11		ds	1	
	wk12		ds	1	
	wk13		ds	1
	wk14		ds	1
	wk15		ds	1	
	wk16		ds	1
	wk17		ds	1
	wk18		ds	1
	wk19		ds	1
	wk20		ds	1
	wk21		ds	1
	wk22		ds	1
	wk23		ds	1		
	wk24		ds	1
	wk25		ds	1
	wk26		ds	1
	wk27		ds	1
        WORD_ADR_H      DS      1
        WORD_ADR_M      DS      1
        WORD_ADR_L      DS      1
        SENDBUF         DS      1
        SENDBIT         EQU     SENDBUF.7
        RECEIVEBUF      DS      1
        RECEIVEBIT      EQU     RECEIVEBUF.0
        ACK             DS      1
        ACKDATA         EQU     ACK.0
        WRITE_OR_READ   EQU      ACK.1

        WRITEDATA       DS      16
        RECEIVEDATA     DS      16
        N00             DS      1
	N01             DS      1
        N03             DS      1
        N04             DS      1
	r00		ds	1	
	r01		ds	1
	r02		ds	1
	r03		ds	1
	r04		ds	1
	r05		ds	1
	r06		ds	1
	r07		ds	1	
	r08		ds	1
	r09		ds	1

        key_off         ds      1
       ; key_off_1       equ     key_off1.0
        key_off1        equ     key_off.0

;;***********************************
	temp_h		equ	r00
	temp_l		equ	r01

	body_max_h	equ	r00  	;;1
	body_max_l	equ	r01  	;;2
	body_min_h	equ	r02  	;;3
	body_min_l	equ	r03  	;;4
	fever1_h	EQU	r04	;;5
	fever1_L	EQU	R05	;;6
	fever3_h	equ	r06	;;7
	fever3_l	equ	r07	;;8		
;-----------------------------------------------------------------------------	
	accbuf		ds	1
	pflagbuf	ds	1
	rbankbuf	ds	1
	sys_mode	ds	1	;00:normal,01:memory,02:cal mode,03:offset,04h:check mode
;-----------------------------------------------------------------------------	
	keyinbuf	ds	1	;key process ram
	keychkbuf	ds	1
	keychat		ds	1
	keycvtbuf	ds	1
	keyoldbuf	ds	1
	key_command	ds	1
	long_key_back	ds	1
	key_state	ds	1

	long_key_h	ds	1
	long_key_l	ds	1
;-----------------------------------------------------------------------------	

;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------	


;-----------------------------------------------------------------------------		
	tst_obj_step	ds	1	;测量模式步骤，此寄存器还与清除记忆模式公用
	sample_counter	ds	1
	tpadc_counter	ds	1
	adc_counter	DS	1
	memory_index	ds	1	;;记忆模式索引
;-----------------------------------------------------------------------------	
	time_10ms	ds	1
	test_times	ds	1
	timer_buf1	ds	1
	timer_buf2	ds	1	;关机时间

	num		ds	1

	bl_base_time_buf	ds	1

	flash_buf	ds	1
	buzzer_mode	ds	1
	buzzer_delay	ds	1
	buz_step	ds	1
	buzer_short_cnt	ds	1
;===========================================================================	
	dis_mode_buf 	ds	1	;display
	dis_data_buf	ds	6

	
	lcd_dot1	ds	1
	lcd_dot2	ds	1	

	f_c		equ	lcd_dot1.0	;;摄氏度
	f_bat		equ	lcd_dot1.1	;;电池符号
	f_suf		equ	lcd_dot1.2	;;体表模式符号
	f_body		equ	lcd_dot1.3	;;人体模式化符号
	f_buz		equ	lcd_dot1.4	;;喇叭符号
	f_buz_x		equ	lcd_dot1.5	;;喇叭符号关闭
	f_memo		equ	lcd_dot1.6	;;记忆
	f_bat1		equ	lcd_dot1.7

	f_data_1	equ	lcd_dot2.0     ;(小1)
	f_point		equ	lcd_dot2.1	;;小数点
	f_memo_1	equ	lcd_dot2.2	;;记忆1（大1）
	f_f      	equ	lcd_dot2.3	;;F
	
	f_test_point	equ	lcd_dot2.6	;;0-位小数，1-两位小数
	f_set_negative	equ	lcd_dot2.7	;;负数

;===========================================================================		
	bitram1		ds	1
	bitram2		ds	1
	bitram3		ds	1
	bitram4		ds	1
	bitram5		ds	1
	bitram6		ds	1
 	bitram7		ds	1
 	bitram8		DS	1

	f_key_state		equ	bitram1.0
	f_update_disp		equ	bitram1.1
	f_dis_mode		equ	bitram1.2	;;0-显示数字，1-显示点
	f_dis_zd		equ	bitram1.3	;;0-自动显示，1-手动显示
	f_power_on 		equ 	bitram1.4	;第一次上电
	f_turnoff		equ	bitram1.5
	f_dis_app		equ	bitram1.6	;;0-全部显示，1-显示字符
	f_flash			equ	bitram1.7	;0-bit,1-data

	f_longkey_state		equ	bitram2.0
	f_cal_test		equ	bitram2.1	;;0-普通校正模式，1-专业校正模式
	f_long_down		equ	bitram2.2
	f_fc_temp1		equ	bitram2.3	;;不能修改了，20180515


	CLR_RAM_START	EQU	07fh-1		
org	07fh			;;
	sys_bit		ds	1



ORG	100H

        ;DATA_NUM        DS      1	
	;tpadc_data_buf	ds	32
	data_temp_h	ds	1
	data_temp_m	ds	1
	data_temp_l	ds	1
	data_cnt	ds	1


	tp_adc_buf_H	DS	1
	tp_adc_buf_l	DS	1

	tp_adc_max_H	DS	1
	tp_adc_max_l	DS	1
;;*******************************************
	adc_avg_max_h	ds	1		   ;;此处位置不动
	adc_avg_max_l	ds	1	
	
	tsadc_avg_data_m ds	1
	tsadc_avg_data_l ds	1

	tp_adc_buf_bak_h	DS	1
  	tp_adc_buf_bak_L	DS	1

;	tpadc_raw_data_m	DS	1
;	tpadc_raw_data_L	DS	1
;;*******************************************

	
	lbt_raw_adc_L	ds	1
	lbt_raw_adc_h	ds	1

	tp_adc_bak_h	ds	1
	tp_adc_bak_l	ds	1

	t_object_h_bak	ds	1	;C
	t_object_l_bak	ds	1


	t_object_h_body	ds	1
	t_object_l_body	ds	1

	i2c_delay	ds	1
;;*******************************************************************************
	TEST_DEV		ds	1
	ts_sampl_cnt		DS	1
 	init_ts_cnt		ds	1	;;
	ts_div_cnt		DS	1

  	tp_sampl_cnt		ds	1
	init_tp_cnt		ds	1	;;
	tp_div_cnt		DS	1

	TS_AMPM			DS	1	;;				
	TP_AMPM			DS	1	;;				
 	ADCM_1			DS	1	;;				
	ADCM_2			DS	1	;;						
	turn_off_time		ds	1	;;
	Bl_base_time		DS	1
	pass_word		ds	1	;;											
	EPPROM_version		ds	1	;;
	LBT_H			ds	1
	LBT_l			ds	1						
	amb_cnst_lo_h		ds	1	;;				
	amb_cnst_lo_l		ds	1	;;				
	amb_cnst_hi_h		ds	1	;;				
	amb_cnst_hi_l		ds	1	;;

	order_stand		ds	1
	order_stand1		ds	1
	order_state1		ds	10	;;
	adc_step1		ds	1	;;
	adc_step2		ds	1
	suf_val			ds	1
	body_val		ds	1
	order_suf		ds	1
	order_body		ds	1
;;***********************************************
	timer_buf3		ds	1	;60S
	min			ds	1								
;;***********************************************
;	CLR_RAM_START		EQU	07eh
	CLR_RAM_START1		EQU	07fh

	

	
	

