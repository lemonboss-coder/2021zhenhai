LCD_TABLE2:
	       				;LCD ¶ÎÂë±í
	DW	SA+SB+SG+SE+SD   	;'2'		
	DW	SA+SF+SE+SD+SC+SB	;'0'
	DW	SA+SB+SG+SE+SD	 	;'2'
	DW	SB+SC			;'1'
	DW	SA+SF+SE+SD+SC+SB	;'0'
	DW	SA+SB+SG+SC+SD	 	;'3'
	DW	SA+SB+SG+SE+SD	 	;'2'
	DW	SA+SF+SE+SD+SC+SB	;'0'
	DW	SA+SB+SG+SE+SD   	;'2'
	DW	SA+SF+SE+SD+SC+SB	;'0'
	DW	SA+SB+SC+SD+SE+SF+SG	;'8'	10
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
	DW	00H			;'Ãð'	22
	dw	se			;"i	23
	dw	sg+sc+se+sd		;"O"	24
	dw	sg+sc+se		;"n"	25
	dw	sg+sf+se+sd		;"T"	25
	DW	SA
	DW	SD
;;************************************************
num_table:
         dw  00H
         dw  01H
         dw  02H
         dw  03H
         dw  04H
         dw  05H
         dw  06H
         dw  07H
         dw  08H
         dw  09H
 