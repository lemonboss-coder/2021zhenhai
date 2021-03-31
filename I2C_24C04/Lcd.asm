;*************************************************************************************
;NAME:			lcd_display
;INPUT:			
;			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;*************************************************************************************
lcd_display:
	b0mov	h,#dis_data_buf$m
	b0mov	l,#dis_data_buf$l+3	;backup address	
	B0MOV_	wk12,#04		;total bit
	B0MOV_	wk09,#01h		;start 		
lcd_display20:
	b0mov   y,#LCD_TABLE$m    ;LCD_TABLE2 显示20210320
	b0mov	z,#LCD_TABLE$l
	mov	a,@hl
	add	z,a
	mov	a,#00
	adc	y,a
	movc
	b0mov	wk00,a
	

	B0MOV_	z,wk09
	b0mov	y,#0fh
	b0mov	a,wk00
    ;    b0bts1  r.3
     ;   b0bts0  r.2
      ;  jmp     lcd_display30 
       ; ret
lcd_display30:       
	mov	@yz,a
        ;b0bts0  r.2  r.0 r.1 r.2 r.3 
	incms	z

	b0mov	a,r
	mov	@yz,a
lcd_display40:
	mov	a,#02h
	add	wk09,a
	decms	l
	decms	wk12
	jmp	lcd_display20
lcd_display90:		
;*****************************************************************
;NAME:			lcd_display
;INPUT:			
;			
;FUNCTION:		
;DESCRIBE:		
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:		NONE
;******************************************************************
lcd_bit_app:
	b0mov	rbank,#0fh
	B0mov	a,lcd_dot1
	and	a,#0fh
	b0mov	rbank,#0fh
	mov	00h,a
	b0mov	rbank,#00h
	swap	lcd_dot1
	and	a,#0fh
	b0mov	rbank,#0fh
	mov	09h,a
	
 	bclr	r_data_1
	b0bts0	f_data_1
	bset	r_data_1			;;小数点
	
	bclr	r_memo_1
	b0bts0	f_memo_1
	bset	r_memo_1			

	bclr	r_point
	b0bts0	f_point
	bset	r_point			;;小数点

	bclr	r_F
	b0bts0	f_F
	bset	r_F			;;F

;	b0bts0	f_buz_x			;;
;	bset	r_buz_x			;;蜂鸣器符号

;	b0bts0	f_buz			;;
;	bset	r_buz			;;蜂鸣器符号

;	b0bts0	f_memo
;	bset	r_memo			;;M记忆符号

;	b0bts0	f_suf
;	bset	r_body			;;体温符号

;	b0bts0	f_suf
;	bset	r_suf			;;体表模式符号

;	b0bts0	f_bat1			
;	bset	r_bat0			;;电池符号

;	b0bts0	f_c			
;	bset	r_c			;;℃
	
	b0mov	rbank,#00h

lcd_bit_app90:	
	ret