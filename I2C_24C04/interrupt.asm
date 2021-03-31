int_server:
;-----------------------------------
;	save acc and system registers
;-----------------------------------
 	b0xch 	a,accbuf    ;����a���������				;b0xch instruction do not change c,z flag
	b0mov	a,pflag
        b0xch   a,pflagbuf  ;����b0xch�洢������λ�� BANK0��
	;b0mov	pflagbuf,a   ;����pflag������
	b0mov	a,rbank       
	b0mov	rbankbuf,a    ;����
	b0mov	rbank,#00
;-----------------------------------
;   check which interrupt happen
;-----------------------------------					
inttc0chk:
	b0bts1	ftc0irq					; ���TC0�Ƿ��������жϣ�Ϊ0��û�з����жϣ�ִ��jmp
	jmp	int_exit				; jump to int0 interrupt service routine
;--------------------------------------------------------
inttc0:
	b0bclr	ftc0irq         ;TCO�ж������־λ��0
	mov	a,#055h         ;��TCOC��Ԥ��ֵ
	b0mov	TC0C,a		
intt010:
	djnz	time_10ms,int_exit    ;djnz��ʲô��˼��������������������������������������������������������������
 	mov	a,#T_10MS
	b0mov	time_10ms,a
;--------------------------------------------------------
;;10MS
dkeychat:
       	b0mov   a,keychat
	b0bts1	FZ      ;ZΪ���ǣ�keychat��Ϊ0����FZΪ0��FZΪ0��ִ���Լ�1
	decms	keychat   ;keychat�Լ�1
	nop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
long_key_chat: 
	b0mov   a,long_key_h
	or	a,long_key_l  ;OR ָ��Ϊ�߼���ָ�������������Ӧ��λ�κ�һλΪ 1������ӦλΪ 1��������Ϊ 0�����־�� 1����֮�� 0��
	b0bts1	FZ            ;�ж�����λ�Ƿ�λ0����ζlong_key��Ϊ0��ִ��long_key_l�Լ�
	decms	long_key_l  ;long_key_l�Լ�
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
	
	b0bts0	f_dis_zd		;;0-�Զ���ʾ��1-�ֶ���ʾ
	jmp	timer_app10
;;***************************************
timer_app00:
	incs	num ;num�ԼӴ浽acc
	nop
	cjbe	a,#09,timer_app03
	b0bts0	f_dis_mode			;;0-��ʾ���֣�1-��ʾ��
	jmp	timer_app01
	;b0bset	f_dis_mode
        b0bts0	f_dis_mode              ;�����������ʾ��
	mov	a,#09
	jmp	timer_app01
	;jmp	timer_app03
timer_app01:
	b0bclr	f_dis_mode			;;0-��ʾ���֣�1-��ʾ��
	mov	a,#00
timer_app03:
	b0mov	num,a	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
timer_app10:
	djnz	timer_buf1,timer_app90
	B0MOV_	timer_buf1,#100		;10*100ms  �����������ʾ�ٶ�
timer_app100:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timer_app11:
	djnz	bl_base_time_buf,int_exit	;;5s��رձ���
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

				

	
	