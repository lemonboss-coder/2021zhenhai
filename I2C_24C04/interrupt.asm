int_server:
;-----------------------------------
;	save acc and system registers
;-----------------------------------
 	b0xch 	a,accbuf    ;保存a里面的数据				;b0xch instruction do not change c,z flag
	b0mov	a,pflag
        b0xch   a,pflagbuf  ;调用b0xch存储器必须位于 BANK0，
	;b0mov	pflagbuf,a   ;保存pflag的数据
	b0mov	a,rbank       
	b0mov	rbankbuf,a    ;保存
	b0mov	rbank,#00
;-----------------------------------
;   check which interrupt happen
;-----------------------------------					
inttc0chk:
	b0bts1	ftc0irq					; 检查TC0是否有请求中断，为0则没有发生中断，执行jmp
	jmp	int_exit				; jump to int0 interrupt service routine
;--------------------------------------------------------
inttc0:
	b0bclr	ftc0irq         ;TCO中断请求标志位清0
	mov	a,#055h         ;给TCOC付预置值
	b0mov	TC0C,a		
intt010:
	djnz	time_10ms,int_exit    ;djnz是什么意思？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
 	mov	a,#T_10MS
	b0mov	time_10ms,a
;--------------------------------------------------------
;;10MS
dkeychat:
       	b0mov   a,keychat
	b0bts1	FZ      ;Z为零标记；keychat不为0；则FZ为0；FZ为0则执行自减1
	decms	keychat   ;keychat自减1
	nop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
long_key_chat: 
	b0mov   a,long_key_h
	or	a,long_key_l  ;OR 指令为逻辑或指令。两个操作数相应的位任何一位为 1，其相应位为 1。如果结果为 0，零标志置 1，反之置 0。
	b0bts1	FZ            ;判断零标记位是否位0，意味long_key不为0，执行long_key_l自检
	decms	long_key_l  ;long_key_l自减
	jmp	long_key_chat90
   
     	decms	long_key_h
     	jmp	long_key_chat80
     	jmp	long_key_chat90
long_key_chat80:
	B0MOV_	long_key_l,#100  	
long_key_chat90:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
buz_delay:	
   	b0mov	a,buzzer_delay
	jz	buz_delay90
	decms	buzzer_delay
	jmp	buz_delay90	
	B0BCLR	FPWM0OUT
buz_delay90:			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NAME:			timer_app
;INPUT:			10ms		
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	
;STACK NEED:		0
;OUTPUT:	   		
;************************************************************
timer_app:
	djnz	flash_buf,timer_app10
	B0MOV_	flash_buf,#T_flash
	b0bset	f_update_disp
	mov	a,#10000000b
	xor	bitram1,a		;0-bit,1-data
	
	b0bts0	f_dis_zd		;;0-自动显示，1-手动显示
	jmp	timer_app10
;;***************************************
timer_app00:
	incs	num ;num自加存到acc
	nop
	cjbe	a,#09,timer_app03
	b0bts0	f_dis_mode			;;0-显示数字，1-显示点
	jmp	timer_app01
	;b0bset	f_dis_mode
        b0bts0	f_dis_mode              ;跑马灯跳过显示点
	mov	a,#09
	jmp	timer_app01
	;jmp	timer_app03
timer_app01:
	b0bclr	f_dis_mode			;;0-显示数字，1-显示点
	mov	a,#00
timer_app03:
	b0mov	num,a	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
timer_app10:
	djnz	timer_buf1,timer_app90
	B0MOV_	timer_buf1,#100		;10*100ms  控制跑马灯显示速度
timer_app100:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timer_app11:
	djnz	bl_base_time_buf,int_exit	;;5s后关闭背光
	b0mov_	bl_base_time_buf,#05
timer_app90:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;						
int_exit:
	b0bclr	ftc0irq
	b0mov	a,rbankbuf
	b0mov	rbank,a	
	b0mov	a,pflagbuf
	b0mov	pflag,a
	b0xch	a,accbuf				;b0xch instruction do not change c,z flag
	reti	

				

	
	