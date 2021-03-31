IFNDEF	__MY__
	__MY__	EQU	1

;************************************************************
;NAME:			CPL_F
;INPUT:			FLAG
;FUNCTION:		位取反
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		/FLAG
;************************************************************
CPL_F	macro	FLAG
	bts0	flag
	jmp	$+3
	bset	flag
	jmp	$+2
	bclr	flag	
	ENDM
	
;************************************************************
;NAME:			CPL_FC
;INPUT:			FC
;FUNCTION:		标志位取反
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		/FC
;************************************************************
CPL_FC	MACRO
	mov	a,#04h			;cpl fc
	xor	pflag,a
ENDM
		
;************************************************************
;NAME:			AND_F
;INPUT:			FLAG1,FLAG2
;FUNCTION:		AND	FLAG1,FLAG2
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		
;************************************************************
AND_F	macro	FLAG1,FLAG2
	bts1	flag2
	bclr	flag1
	ENDM

;************************************************************
;NAME:			OR_F
;INPUT:			FLAG1,FLAG2
;FUNCTION:		AND	FLAG1,FLAG2
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		
;************************************************************
OR_F	macro	FLAG1,FLAG2
	bts0	flag2
	bset	flag1
	ENDM


;************************************************************
;NAME:			XOR_F
;INPUT:			FLAG1,FLAG2
;FUNCTION:		AND	FLAG1,FLAG2
;DESCRIBE:		不同为1，相同为0
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		
;************************************************************
XOR_F	macro	FLAG1,FLAG2
	
	bts1	flag2			;1
	jmp	XOR_F90			;0
	
	bts1	flag1			;1
	jmp	XOR_F10			;0,不同
	bclr	flag1
	jmp	XOR_F90
XOR_F10:
	bset	flag1
XOR_F90:
	ENDM



;************************************************************
;NAME:			MOV_F
;INPUT:			FLAG1,FLAG2
;FUNCTION:		(FLAG1)<-(FLAG2)
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		NONE
;************************************************************
MOV_F	macro	FLAG1,FLAG2
	bclr	flag1
	bts0	flag2
	bset	flag1
	ENDM

;************************************************************
;NAME:			CPL_M
;INPUT:			MEM
;FUNCTION:		将寄存器中的值取反
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		/MEM
;************************************************************
CPL_M	macro	mem
	ifidni	<mem>, <a>
		xor	a, #0xff
	else
		mov	a, #0xff
		xor	mem, a
	endif
	endm

;************************************************************
;NAME:			B0MOV_
;INPUT:			MEM
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		
;************************************************************
B0MOV_	MACRO	MEM, MEM_VAL
	B0MOV_S1	TEXTEQU <MEM_VAL>		;取字符串
	B0MOV_V1	INSTR	1,B0MOV_S1,<#>		;在字符串中查找"#",返回位置值，
							;如果没有该字符串则返回0

	IF	B0MOV_V1==0				;没有#字符	
	b0mov	a, mem_val
	
	elseif	b0mov_v1==1
	mov	a, mem_val
	endif
	
	b0mov	mem, a
	ENDM

	
;************************************************************
;NAME:			INC_YZ
;INPUT:			NONE
;FUNCTION:		INC THE Y,Z
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		NONE
;************************************************************	
INC_YZ	MACRO	 	 
 	incms	z		; z+1
  	jmp	@f		; not overflow
  	incms	y		; y+1
 	nop	 		; Not overflow
@@:	 	 	 
 	ENDM	

 

;************************************************************
;NAME:			INC_HL
;INPUT:			NONE
;FUNCTION:		INC THE H,L
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	NONE
;OUTPUT:		NONE
;************************************************************	
INC_HL	MACRO	 	 
 	incms	l		; l+1
 	jmp	$+3		; not overflow
  	incms	h		; h+1
 	nop	 		; not overflow
 	ENDM
 	
;************************************************************
;NAME:			HEX2B_CJBE
;INPUT:			DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
;FUNCTION:		Compare 6bits bin data
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,FC FZ
;OUTPUT:		NONE
;************************************************************	
HEX2B_CJBE 	MACRO 	DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
	HEX2B_CJAE 	<DATA2_H>,<DATA2_L>,<DATA1_H>,<DATA1_L>,<JMP_ADDRESS>	
		ENDM 


;************************************************************
;NAME:			HEX2B_CJAE
;INPUT:			DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
;FUNCTION:		Compare 6bits bin data
;DESCRIBE:		注意：当data2是立即数时，实际执行的是CJA!!!!
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,FC FZ
;OUTPUT:		NONE
;************************************************************	
HEX2B_CJAE 	MACRO 	DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
	
	HEX2B_CJBE_S1	TEXTEQU <DATA2_H>		;取字符串
	HEX2B_CJBE_V1	INSTR	1,HEX2B_CJBE_S1,<#>	;在字符串中查找"#",返回位置值，
							;如果没有该字符串则返回0

	IF	HEX2B_CJBE_V1==0	;没有#字符	
	mov	a,data1_l
	sub	a,data2_l	
	mov	a,data1_h
	sbc	a,data2_h
	b0bts0	fc			
	jmp	jmp_address		;if fc=1,data1>=data2
					;if fc=0,data1<data2	
		
	ELSEIF	HEX2B_CJBE_V1==1
	mov	a,data2_l
	sub	a,data1_l
	mov	a,data2_h
	sbc	a,data1_h
	b0bts1	fc			;?????
	jmp	jmp_address		;if fc=0,data1>data2
					;if fc=1,data1<=data2
	ELSE
	
	ERROR	Input Error! Please Check It.
	
	ENDIF		
 	ENDM
 
;************************************************************
;NAME:			HEX2B_CJNE
;INPUT:			DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
;FUNCTION:		Compare 6bits bin data
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,FC FZ
;OUTPUT:		NONE
;************************************************************	
HEX2B_CJNE 	MACRO 	DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
	mov	a,data1_h		;h
	cmprs	a,data2_h		;if data1_h == data2_h then skip next instruction
	jmp	jmp_address		;data1_h != data2_h jmp to jmp_address

	mov	a,data1_l		;l
	cmprs	a,data2_l		;if data1_l == data2_l then skip next instruction
	jmp	jmp_address		;data1_l != data2_l jmp to jmp_address
@@:	
 	ENDM
	
;************************************************************
;NAME:			HEX2B_CJE
;INPUT:			DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
;FUNCTION:		Compare 6bits bin data
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,FC FZ
;OUTPUT:		NONE
;************************************************************	
HEX2B_CJE 	MACRO 	DATA1_H,DATA1_L,DATA2_H,DATA2_L,JMP_ADDRESS
	mov	a,data1_h		;h
	cmprs	a,data2_h		;if data1_h == data2_h then skip next instruction
	jmp	@f			;data1_h != data2_h jmp to jmp_address

	mov	a,data1_l		;l
	cmprs	a,data2_l		;if data1_l == data2_l then skip next instruction
	jmp	@f			;data1_l != data2_l jmp to jmp_address
	jmp	jmp_address
@@:	
 	ENDM
 
 
;************************************************************
;NAME:			LCD_BCLR
;INPUT:			FLAG
;FUNCTION:		Clear the LCD ram bit
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBNK
;OUTPUT:		none
;************************************************************	
LCD_BCLR MACRO 	FLAG
	b0mov	rbank,#15
	bclr	flag
	b0mov	rbank,#00h
 	ENDM

;************************************************************
;NAME:			LCD_BCLR
;INPUT:			FLAG
;FUNCTION:		Clear the LCD ram bit
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************	
LCD_BSET MACRO 	FLAG
	b0mov	rbank,#15
	bset	flag
	b0mov	rbank,#00h
 	ENDM
;************************************************************
;NAME:			readmode
;INPUT:			none
;FUNCTION:		SDA_MODE:0 读
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
readmode      MACRO  
              B0bclr  sda_mode
                NOP
                NOP
                NOP
                NOP
                NOP		
              jmp    $+1
              endm
;************************************************************
;NAME:			writemode
;INPUT:			none
;FUNCTION:		SDA_MODE:1 写
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
writemode     MACRO  
              B0bset  sda_mode
                NOP
                NOP
                NOP
                NOP
                NOP
              jmp    $+1
              endm
;************************************************************
;NAME:			sclhi
;INPUT:			none
;FUNCTION:		scl置1;
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
sclh		MACRO                            ;scl置1
		b0bset	SCL_MODE
		jmp	$+1
		b0bset 	SCL
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP	
                NOP
                NOP
               
		;call	delay10us
		ENDM
;************************************************************
;NAME:			sclho
;INPUT:			none
;FUNCTION:		scl置0;
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
scll		MACRO                            ;scl置0
		b0bset	SCL_MODE
		jmp	$+1
		b0bclr 	SCL
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
	
		;call	delay10us
		ENDM	
;************************************************************
;NAME:			sdahi
;INPUT:			none
;FUNCTION:		sda置1;
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
sdah		MACRO                            ;sda置1
		b0bset SDA
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP 
                NOP
                NOP
                NOP
                NOP
                NOP
              
		jmp	$+1
		ENDM
;************************************************************
;NAME:			sdahi
;INPUT:			none
;FUNCTION:		sda置0;
;DESCRIBE:		none
;CALL SUBPROGRAM:	none
;USING RESOURCE:	RBANK
;OUTPUT:		none
;************************************************************
sdal		MACRO                            ;sda置0
		b0bclr SDA
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
              	
		jmp	$+1
		ENDM		
	ENDIF

	