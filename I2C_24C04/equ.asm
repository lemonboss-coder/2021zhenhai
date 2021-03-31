;;***************************************************************
	password_adress equ	00fffh
	TS_CAL_TIMES	equ	00Ff2h		;;У������ 
 	CAL_ADDR	equ	00ff3h	

	EPPROM		EQU	05EH

	T_flash		EQU	50
	T_10MS		equ	01EH
;-----------------------------------------------------------

;;**********************************************************
	Normal		EQU	00H
	Memory		EQU	01H
	Cal		EQU	02h
	Set		equ	03h
	Test		EQU	04H
;-----------------------------------------------------------				
	key_on_off	EQU	P0.0		;;
	key_memo	EQU	P0.1 		;;����/�� MO/CLR
	key_mode	EQU	P0.2		;;ģʽ/�� MODE/SET

 
	KEY_AGE_VAL	EQU	8
	KEYCODENO	EQU	3		;define how many keys	

	green_led	equ	P2.0		;;�͵�ƽ����
	red_led		equ	p2.1		;;�͵�ƽ����
	
;;����ֵ
;;*******************************************************
				;I2C Defines 
	SCL		EQU	P0.6
	SCL_MODE	equ	p0m.6

	SDA		EQU	P0.7
	SDA_MODE	equ	p0m.7
;===========================================================	
	I2C_CON_CODE	equ 	10100000B 		;I2C����������:1010 A2[P2] A1[P1] A0[P0] R/W
	I2C_CON_WRITE0	equ 	I2C_CON_CODE&11111110B	;����дbak0ָ��
	I2C_CON_WRITE1	equ	I2C_CON_CODE|00000010B	;����дbak1ָ��
	
	I2C_CON_READ0	equ	I2C_CON_CODE|00000001B	;�����bak0ָ��
	I2C_CON_READ1	equ	I2C_CON_CODE|00000011B	;�����bak1ָ��

	I2C_CON_READ	EQU	I2C_CON_CODE|00000001B	
	;		MSD		         LSB
	;128/256��8:	1  0  1  0  A2  A1  A0   R/W	XX24C01/C02
	;512��8:	1  0  1  0  A2  A1  P0	 R/W	XX24C04
	;1024��8:	1  0  1  0  A2  P1  P0	 R/W	XX24C08
	;2048��8:	1  0  1  0  P2  P1  P0	 R/W	XX24C16
	;16384��8:	1  0  1  0  0   A1  A0	 R/W    XX24C128
	;32768��8:	1  0  1  0  0   A1  A0   R/W	XX24C256
;===========================================================
;LCD��ض���
;------------------------------------------------------------------------
				   ;SEG:      N     N-1
			   ;COM: ---3210----3210
				;000ABCD00000FGE		
	SA		EQU	0000100000000000B
	SB		EQU	0000010000000000B
	SC		EQU	0000001000000000B
	SD		EQU	0000000100000000B
	SE		EQU	0000000000000001B
	SG		EQU	0000000000000010B
	SF		EQU	0000000000000100B

	CHAR_A		EQU	10	;�ַ�
	CHAR_b		EQU	CHAR_A+1
	CHAR_c		EQU	CHAR_b+1
	CHAR_d		EQU	CHAR_c+1
	CHAR_E		EQU	CHAR_d+1
	CHAR_F		EQU	CHAR_E+1
	CHAR_H		EQU	CHAR_F+1
	CHAR_P		EQU	CHAR_H+1
	CHAR_L		EQU	CHAR_P+1
	CHAR_r		EQU	CHAR_L+1
	CHAR_LINE	EQU	CHAR_r+1
	CHAR_V		EQU	CHAR_LINE+1
	LCD_OFF		EQU	CHAR_V+1   ;22:��
	char_i		equ	LCD_OFF+1
	char_o		equ	char_i+1
	char_n		equ	char_o+1
	char_t		equ	char_n+1
	CHAR_SA		EQU	char_t+1
	CHAR_SD		EQU	CHAR_SA+1
	CHAR_��		equ	CHAR_SD+1
	CHAR_��		equ	CHAR_��+1

	r_buz		equ	09h.0		;;���ȷ���
	r_buz_x		EQU	09h.1		;;���ȷ��Źر�
	r_memo		equ	09h.2		;;�������
	
	r_memo_1	equ	07h.3		;;����1(��1)
	r_point		equ	05h.3		;;С����
	r_data_1	equ	01h.3		;;����1��С1��

	
	r_suf		equ	00h.2		;;���ģʽ����
	r_body		equ	00h.3		;;����ģʽ����
	r_bat0		equ	00h.1		;;��ط���	
	r_c		equ	00h.0		;;���϶�
	r_F		equ	03h.3		;;F

;-------------------------------------------------			
	d_rdy_for_tst	equ	00		;;00:�������
	d_obj_tst_ok	equ	d_rdy_for_tst+1	;;02:����OK��ʾ		
	d_memo		equ	d_obj_tst_ok+1	;;04:����ģʽ
	d_amb_cal_fail	equ	d_memo+1	;;05:У�����Գ�������
	d_test_fail	equ	d_amb_cal_fail+1;;06:У��TP������ʾ
	d_tamb_fail	equ	d_test_fail+1	;;07:У��TS���󣬻�У������37�泬��У������
	d_cal_index	equ	d_tamb_fail+1	;;08:У��ģʽ�¼�����ʾ "CAx"  
	d_amb_cal_ok	equ	d_cal_index+1	;;09:25.0"thermistor У��OK��ʾ
	d_lcd_tst	equ	d_amb_cal_ok+1	;;10:diaplay�Լ�	
	d_ts_raw_data	equ	d_lcd_tst+1	;;11thermistor raw data  
	d_tp_raw_data	equ	d_ts_raw_data+1	;;12thermopile raw data 
 	d_amb		equ	d_tp_raw_data+1	;;13	
	d_fun_index	equ	d_amb+1		;;12;����ģʽ�¼�����ʾ "Fx"
	d_unit_cnvt	equ	d_fun_index+1	;;14:			F1	
	d_fever_set	equ	d_unit_cnvt+1	;;15;buzzer		F3	
	d_buz_set	equ	d_fever_set+1	;;16;��λת��ģʽ��ʾ	F4 
	d_offset	equ	d_buz_set+1	;;14;fever set		F2
	d_rst		equ	d_offset+1	;;18;��λ��ʾ
	d_clr_memo	equ	d_rst+1		;;17;�������ģʽ��ʾ	

;-------------------------------------------------
	b_1long_buz	equ	1
	b_1short_buz	equ	3
	b_3short_buz	equ	5
	b_10short_buz	equ	7

	Test_38_low	EQU	3834     
	Test_38_high	EQU	3864  
        DATA_NUM        EQU     32

	