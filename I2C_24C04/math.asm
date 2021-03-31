;*********************************************************************************
;NAME:			sub_hex2b
;INPUT:			���������ֽڸ���wk03�����ֽڸ���wk02
;			�������ֽڸ���wk01�����ֽڸ���wk00
;FUNCTION:		(FC)(wk01wk00)=(wk03wk02)-(wk01wk00)
;DESCRIBE:		ѡȡ��SUB_HEX2B_KEY	EQU	1
;			ԭ������,�������
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,wk03,wk02,wk01,wk00,PFLAG
;STACK NEED:		0
;ROMSIZE:		10
;OUTPUT:		��ĸ��ֽڴ���wk01��,���ֽڴ���wk00��,����λ��FC��,1:POS 0:NEG
;*********************************************************************************
sub_hex2b00:
	clr	wk01
	clr	wk03
sub_hex2b: 
	b0mov	a,wk02
	sub	wk00,a
	b0mov	a,wk03
	sbc	wk01,a	
	b0bts1	fc
	b0bts0	fc
	jmp	sub_hex2b90
	mov	a,#00h
	sub	wk00,a
	sbc	wk01,a
sub_hex2b90:
	ret 
;*********************************************************************************
;NAME:			mul_hex2b
;INPUT:			��������wk05(��)��wk04(��)(wk05wk04)�У�
;			������  wk01(��)��wk00(��)(wk01wk00)��
;FUNCTION:		˫�ֽڶ������޷������˷�
;DESCRIBE:		(wk03wk02wk01wk00)=(wk05wk04)*(wk01wk00)
;			ѡȡ��MUL_HEX2B_KEY 	EQU 	1
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,R,wk00,wk01,wk02,wk03,wk04,wk05,FC
;STACK NEED:		0
;ROMSIZE:		17
;run sycle:		14*16+4=228
;OUTPUT:		�˻���������wk03wk02wk01wk00��(��->��)
;*********************************************************************************
mul_hex1b0:
	B0MOV	WK04,A
mul_hex1b:		;(wk03wk02wk01wk00)=(wk04)*(wk00)
	clr	wk01
mul_hex2b1:
	clr	wk05
mul_hex2b: 
	b0mov	r,#16			;(wk03wk02wk01wk00)=(wk05wk04)*(wk01wk00)
	clr	wk03
	clr    	wk02 
mul_hex2b20:      
	b0bclr	fc
	b0bts1	wk00.0
	jmp	mul_hex2b30
	b0mov	a,wk04
     	add	wk02,a
	b0mov  	a,wk05
        adc	wk03,a
mul_hex2b30:	
	rrcm	wk03
	rrcm	wk02
	rrcm	wk01
	rrcm	wk00
	decms	r
	jmp	mul_hex2b20
     	ret
 
 