;*********************************************************************************
;NAME:			READ_KEY10
;INPUT:			NONE
;FUNCTION:		??????
;DESCRIBE:		P00______.-.________
;			P01______.-.________|
;			P10______.-.________|
;			P11______.-.________|
;			P12______.-.________|
;			P13______.-.________|
;			P14______.-.________|
;					    |
;					  -----
;					   ---
;					    -
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A
;STACK NEED:		2
;OUTPUT:		
;*********************************************************************************
read_key:			; scan key loop
;*******************************************************************************
keyin10:	
;       clr     keyinbuf
keyin20:      	
	MOV	A,#00000111B
	AND	A,P0
	XOR	A,#00000111B
	B0MOV	keyinbuf,A	
keyin90:
;*******************************************************************************
;       CHECK KEYINBUF AND KEYCHKBUF    
;*******************************************************************************
keychk10: 
       	b0mov	a,keyinbuf
       	cjne	a,keychkbuf,keychk20    ;A=KEYCHKBUF则顺序进行，否则跳到KEYCHK20
					
	b0bts1  f_key_state		; same
       	jmp     keychk90            	; end
; wait chatter
       	b0mov   a,keychat
       	jnz     keychk90        
; key bounce time = 0 , copy chk buf into cvt buf
;
	b0mov   a,keychkbuf
	b0mov   keycvtbuf,a

       	b0bclr  f_key_state        ; clr keystat
       	jmp     keychk90
       	                        
keychk20:
	b0mov   a,keyinbuf
	b0mov   keychkbuf,a
       	b0bset  f_key_state        ;set f_key_state,
       	mov     a,#key_age_val
       	b0mov   keychat,a       
keychk90:
       	;ret
;*******************************************************************************
;       compare keycvt and keyold and find the different.
;*******************************************************************************
keycvt:
	b0mov	a,keycvtbuf
	cje	a,keyoldbuf,keycvt30
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
keycvt10:
	clr	wk25	                                             
	b0mov	a,keycvtbuf		;新的KEYIN状态                     
	b0mov	wk02,a                                           
	xor	a,keyoldbuf		;旧的KEYIN状态                       
	b0mov	wk03,a			;XOR后可得出有变化的PIN,1-表示有变化 
keycvt11:	                                               
	b0mov	r,#KEYCODENO		;;define how many keys			     
keycvt21:                                                
	mov	a,r                                                
	jz	keycvt80                                           
	rrcm	wk03			;找出有变化的pin                       
	b0bts0	fc                                             
	jmp	keycvt22		;1-表示有变化	                         
	mov	a,#03h                                             
	add	wk25,a                                             
	decms	r                                                
	rrcm	wk02                                             
	jmp	keycvt21                                           
keycvt22:                                                
	rrcm	wk02                                             
	b0bts0	fc			;"1"表示是按KEY "0"表示放KEY           
	jmp	keycvt70     

	b0mov	a,keyinbuf
	jnz	keycvt230                                      
	                                                                                      
	b0bts1	f_longkey_state		;;                           
	jmp	keycvt23  
	jmp	clr_key_init	
//	jmp	keycvt90
keycvt230:     
	b0mov	a,sys_mode
	jnz	keycvt23	                                    	
	jmp	keycvt80
keycvt23:
	incms	wk25			;  
	jmp	keycvt71       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
keycvt30:				;长按处理
	b0mov	a,long_key_l
	or	a,long_key_h
	jnz	keycvt90

	mov	a,keyoldbuf
	jz	keycvt90

	b0bts0	f_long_down		;1-长按一直按下，0长按弹起  
	jmp	keycvt90      

	b0mov	a,keycvtbuf
	cje	a,#01h,keycvt31
	b0bset	f_long_down		;1-长按一直按下，0长按弹起   
	b0bset	f_longkey_state
keycvt31:
;	b0bset	f_longkey_state
	b0mov	a,long_key_back
	add	a,#02          
	b0mov	wk25,a       
	jmp	keycvt71       
keycvt70:                                        
	B0MOV_	long_key_back,wk25	;备份按下时候的值  
keycvt71:                                          
	b0mov	y,#norml_key_table$m
	b0mov	z,#norml_key_table$l
	b0mov	a,wk25
	add	z,a
	mov	a,#00
	adc	y,a
	movc                                     
keycvt72:		                                     
	b0mov	key_command,a                            
keycvt80:	
	b0mov   a,keycvtbuf
	b0mov   keyoldbuf,a
keycvt81:
	mov	a,#100
	b0bts0	f_longkey_state
	mov	a,#25
	b0mov	long_key_l,a
	
	mov	a,#03
	b0bts0	f_longkey_state
	mov	a,#01
	b0mov	long_key_h,a
keycvt90:	
	ret
;*******************************************************************************
clr_key_init:
	b0bclr	f_long_down    
	b0bclr	f_longkey_state 
	clr	long_key_back
	clr	keychkbuf	
	clr	keycvtbuf	
	clr	keyoldbuf
	ret
	

    	