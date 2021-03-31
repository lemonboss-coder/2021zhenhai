;*********************************************************************************
;NAME:			buzzer_app
;INPUT:			
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:	;	
;*********************************************************************************
buzzer_app:
	b0mov	a,buzzer_mode
	@jmp_a	8    ;跳表列表的数量为8个
	jmp	buzzer_app90
	jmp	buzzer_app20		;1:1长哔
	jmp	buzzer_app31		;
	jmp	buzzer_app30		;3:1短哔	
	jmp	buzzer_app31		
	jmp	buzzer_app40		;5:3短哔
	jmp	buzzer_app41
	jmp	buzzer_app60		;7:发烧警告:10急促哔
;================================================================
buzzer_app61:
	b0mov	a,buzzer_delay
	jnz	buzzer_app90
		
	incs	buz_step
	cjbe	a,#03,buzzer_app64
	mov	a,#00
buzzer_app64:
	b0mov	buz_step,a
	cmprs	a,#03
	jmp	buzzer_app62
//	jmp	buzzer_app65
buzzer_app65:
	mov	a,#25
	jmp	buzzer_app431
;;****************************************
buzzer_app62:	
	mov	a,#05
	b0mov	buzzer_delay,a
	B0BTS1	buz_step.0
	JMP	init_buz
	JMP	buzzer_app90
buzzer_app20:				;1:1 长哔初始化 	
	mov	a,#50	
	jmp	buzzer_app700
;================================================================
buzzer_app32:	
	mov	a,#05h
	jmp	buzzer_app700
buzzer_app30:				;3: 1短哔
	mov	a,#15
	jmp	buzzer_app700
buzzer_app31:
	b0mov	a,buzzer_delay
	jnz	buzzer_app90
	jmp	buzzer_app80
;================================================================
buzzer_app40:				;5: 3短哔	
	mov	a,#03	
	b0mov	buzer_short_cnt,a
	incms	buzzer_mode
	jmp	buzzer_app42
;;****************************************
buzzer_app41:
	b0mov	a,buzzer_delay
	jnz	buzzer_app90

	B0BTS0	buz_step.0
	JMP	buzzer_app43
buzzer_app42:
	mov	a,#15
	b0mov	buzzer_delay,a
 	B0BSET	buz_step.0
	jmp	init_buz	
buzzer_app43:
	B0BCLR	buz_step.0
	mov	a,#15
buzzer_app431:	
	b0mov	buzzer_delay,a	
	djnz	buzer_short_cnt,buzzer_app90
	jmp	buzzer_app80
;================================================================	
buzzer_app60:				;9:发烧警告:10急促哔	
	mov	a,#4
buzzer_app602:	
	b0mov	buzer_short_cnt,a
	clr	buz_step
	incms	buzzer_mode
	jmp	buzzer_app62
;================================================================
buzzer_app700:	
	b0mov	buzzer_delay,a
	call	init_buz
	incms	buzzer_mode
	jmp	buzzer_app90
;================================================================
buzzer_app80:	
	clr	buzzer_mode		
buzzer_app90:
	ret
;;****************************************************************
init_buz:
	mov	a,#0c0h
	b0mov	TC0R,a
	B0BSET	FPWM0OUT
init_buz90:
	RET



