LCD_TABLE:
	       				;LCD 段码表
	DW	SA+SF+SE+SD+SC+SB	;'0'		
	DW	SB+SC			;'1'
	DW	SA+SB+SG+SE+SD	 	;'2'
	DW	SA+SB+SG+SC+SD	 	;'3'
	DW	SF+SG+SB+SC		;'4'
	DW	SF+SG+SC+SD+SA		;'5'
	DW	SA+SF+SE+SD+SC+SG	;'6'
	DW	SA+SB+SC		;'7'
	DW	SA+SB+SC+SD+SE+SF+SG	;'8'
	DW	SA+SB+SC+SD+SF+SG	;'9'
	DW	SA+SB+SC+SE+SF+SG	;'A'	10
	DW	SF+SE+SD+SC+SG		;'b'	11
	DW	SA+SD+SE+SF		;'c'	12
	DW	SB+SG+SE+SD+SC		;'d'	13
	DW	SA+SF+SG+SE+SD		;'E'	14
	DW	SA+SF+SE+SG		;'F'	15
	DW	SB+SC+SE+SF+SG		;'H'	16
	DW	SA+SB+SE+SF+SG		;'P'	17
	DW	SF+SE+SD		;'L'	18
	DW	SE+SG			;'r'	19
	DW	SG			;'-'	20
	DW	SB+SC+SD+SE+SF		;'V'	21
	DW	00H			;'灭'	22
	dw	se			;"i	23
	dw	sg+sc+se+sd		;"O"	24
	dw	sg+sc+se		;"n"	25
	dw	sg+sf+se+sd		;"T"	25
	DW	SA
	DW	SD
;;************************************************
norml_key_table:			;
	dw	00h,01h,02h		;onoff 开机测量键   
	dw	00h,03h,00h		;mode/UP  模式转换键    
	dw	00h,04h,00h		;memo/DOWN记忆多功能键  	


