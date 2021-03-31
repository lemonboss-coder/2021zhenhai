;;****************************************
;;睡眠程序
;;****************************************
power_down00:
	clr	sys_bit
	call	clr_ram	
power_down:
	mov	a,#00111000b
	b0mov	p0m,a
	mov	a,#11100111b
	b0mov	p0ur,a

	mov	a,#00000011b
	b0mov	p1m,a
	b0mov	p2seg,a			;;设置为LCD
	b0mov	p2m,a			;;设置输出1
	b0mov	p1ur,a
	b0mov	p2,a

	B0BCLR	FPWM0OUT
	b0bclr	FUTXEN			;Enable UART TX. UTX pin exchanges from GPIO mode to UART TX mode and idle high 
	b0bclr	FURXEN		;Enable UART RX. URX pin exchanges from GPIO mode to UART RX mode
	mov	a,#00h
	b0mov	p0,a
	b0mov	p3,a
	B0MOV	P1,A
	b0mov	p3seg,a			;;设置为LCD


	b0mov	CHS,a
	b0mov	VREG,a			;;关闭稳压器输出
	b0mov	AMPM,a			;;禁制PGIA
	b0mov	adcm1,a			;;
;	b0mov	adcm2,a			;;
;	b0mov	LCDM2,a			;;
	b0mov	LBTM,a
	MOV	A,#0F3H
	B0MOV	LCDM1,A
;;****************************************
;=====================================================================
power_down20:
	b0bset	fcpum0			;去睡眠模式
	nop
	b0bclr	f_power_on
;=====================================================================
reset:
	mov 	a,#07fh			;initial stack pointer and
   	b0mov 	stkp,a			;disable global interrupt
	mov     a,#00h			
	b0mov   oscm,a
	b0mov	rbank,#00

	b0bts0	f_power_on
	jmp	power_down00
reset10:
	b0mov	a,p0
	xor	a,#0ffh
	and	a,#00000001b
	jz	power_down
;=====================================================================	
reset20:
	call	clr_ram
	call	cpu_init		;cpu initializtion
reset60:	
;==============================================================

main:
			
;;*********************************************************
main01:	
;	call	read_key
;	call	key_app
;	call	display_app
	call	cpu_init		;cpu initializtion

        CALL    WRITE_00
        MOV     A,#00000000b
        MOV     WORD_ADR_M,A
        MOV     A,#00000000b
        MOV     WORD_ADR_L,A
        CALL    I2C_WRITEBYTES
        MOV     A,#00000000b
        MOV     WORD_ADR_M,A
        MOV     A,#00000001b
        MOV     WORD_ADR_L,A
        CALL    I2C_READBYTES_RANDROM_READ
        NOP
      
;;****************************************
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh
dw	0ffffh


	




