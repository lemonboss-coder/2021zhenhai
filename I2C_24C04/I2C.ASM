I2C_START:                ;SCL高,SDA由高变低，产生起始信号
         WRITEMODE
         SCLL
         SDAH
         SCLH
         SDAL
         ;CALL DELAY5US
         ;SCLL
         RET

I2C_STOP:                 ;SCL高,SDA由低变高，产生终止信号
        WRITEMODE
        SCLL
        SDAL
        SCLH 
        SDAH
        
        RET
;*************************************************************************************
;*************************************************************************************
I2C_ACK:             ;发送ACK ，即SDA产生一个零
        SCLL
        WRITEMODE
        SDAL
        SCLH
        SCLL
      ;  READMODE
        RET
       ;SDAL
       ;CALL DELAY5US
       ;SCLH
       ;CALL DELAY5US
       ;SCLL
       ;CALL DELAY5US
       ;RET

I2C_NOACK:            ;发送NOACK，即SDA产生一个一
       SCLL
       WRITEMODE
       SDAH
       SCLH
       SCLL
       RET
       ;SDAH
       ;CALL  DELAY5US
       ;SCLH
       ;CALL  DELAY5US
       ;SCLL
       ;CALL  DELAY5US
       ;RET

I2C_CHECKACK:          ;检查ACK
       SDAH        ;拉高SDA与SCL释放总线
                       
       READMODE  ;SDA在SCL为低的时候变化，谁先拉低，谁掌握SDA
       SCLH      ;主机在SCL拉高的时候读取一次ACK
       ;CALL  DELAY10US
       ;SCLH
       ;B0BCLR  SDA_MODE
       B0MOV  R,#0FFh
I2C_CHECKACK_cyc:
       DJNZ  R,I2C_CHECKACK_judge 
       B0BSET  ACKDATA           ;noack
       JMP   I2C_CHECKACK_RET 
I2C_CHECKACK_judge:
        B0BTS0  SDA
       JMP   I2C_CHECKACK_cyc
       B0BCLR  ACKDATA           ;ack
I2C_CHECKACK_RET:
       SCLL
       RET
;*************************************************************************************
;*************************************************************************************
SEND_I2C_ONEBYTE:        ;发送位于SENDBUF的一个字节,先发高位
        writemode
        B0MOV  R,#08
        SCLL             ;SDA改变之前先拉低SCL
SEND_I2C_ONEBYTE_START:;判断发1 or  0
        B0BTS0   SENDBIT
        JMP    SEND_I2C_ONEBYTE_1
        JMP    SEND_I2C_ONEBYTE_0
SEND_I2C_ONEBYTE_0:; 发 0  
        SDAL
        SCLH       ;SCL上升沿提醒从机读取SDA
        SCLL       ;SCL下降沿提醒主机准备下一个SDA
        B0BCLR   FC
        RLCM   SENDBUF
        DECMS  R
        JMP    SEND_I2C_ONEBYTE_START
        JMP    SEND_I2C_ONEBYTE_END     
SEND_I2C_ONEBYTE_1:; 发 1
        SDAH
        SCLH       ;SDA变化后，SCL拉高需保持一段时间，且时间不能太短，再拉低
        SCLL
        B0BCLR   FC
        RLCM   SENDBUF
        DECMS  R
        JMP    SEND_I2C_ONEBYTE_START
        JMP    SEND_I2C_ONEBYTE_END
SEND_I2C_ONEBYTE_END:  ;送完8bit,结束发送返回
        RET
;*************************************************************************************

;*************************************************************************************     
I2C_WRITEBYTES:               ;WRITEDATA的数据写入从机特定地址位置
         B0BSET    WRITE_OR_READ
         ;CALL   I2C_START
I2C_WRITEBYTES_SLAVER_ADR:    ;送从机地址
         MOV    A,#I2C_CON_WRITE0
         MOV    SENDBUF,A
         CALL   I2C_START
         CALL   I2C_WRITEBYTES_SEND   ;送一字节；加检测有无应答
         B0BTS0   ACKDATA  ;0表示发送成功
         JMP    I2C_WRITEBYTES_SLAVER_ADR
;I2C_WRITEBYTES_REG_ADR_M:    ;送从机寄存器地址
 ;        MOV    A,WORD_ADR_M
  ;       MOV    SENDBUF,A
   ;      CALL    I2C_WRITEBYTES_SEND
    ;     B0BTS0   ACKDATA  ;0表示发送成功
     ;    JMP    I2C_WRITEBYTES_REG_ADR_M
I2C_WRITEBYTES_REG_ADR_L:
         MOV    A,WORD_ADR_L
         MOV    SENDBUF,A
         CALL    I2C_WRITEBYTES_SEND
         B0BTS0   ACKDATA  ;0表示发送成功
         JMP    I2C_WRITEBYTES_REG_ADR_L
         B0BTS1   WRITE_OR_READ
         RET
         JMP    I2C_WRITEBYTES_DATA
I2C_WRITEBYTES_DATA:         ;送数据
         B0MOV   H,#WRITEDATA$M
         B0MOV   L,#WRITEDATA$L
         MOV   A,#00
         MOV     N01,A ;N01用来记录发送了多少字节
I2C_WRITEBYTES_DATA01:
         B0MOV     A,@HL
         B0MOV     SENDBUF,A
         CALL    I2C_WRITEBYTES_SEND
         B0BTS0   ACKDATA
         JMP    I2C_WRITEBYTES_DATA01
         JMP    I2C_WRITEBYTES_DATA02
         ;JMP    I2C_WRITEBYTES_DATA_NUM
I2C_WRITEBYTES_DATA02:
         INCMS   N01
         MOV    A,N01
         CMPRS  A,#10H         ;此处A的值决定发多少字节;此处A的值决定发多少字节;此处A的值决定发多少字节
         JMP    I2C_WRITEBYTES_DATA03
         JMP    I2C_WRITEBYTES_END 
I2C_WRITEBYTES_DATA03:
         INCMS   L
         B0MOV     A,@HL
         B0MOV     SENDBUF,A
         CALL    I2C_WRITEBYTES_SEND
         B0BTS0   ACKDATA
         JMP    I2C_WRITEBYTES_DATA01
         ;JMP    I2C_WRITEBYTES_DATA_NUM
         JMP    I2C_WRITEBYTES_DATA02

I2C_WRITEBYTES_SEND:
         CALL   SEND_I2C_ONEBYTE
         CALL   I2C_CHECKACK
         RET

I2C_WRITEBYTES_END:           ;结束写
         CALL   I2C_STOP
         CALL   DELAY10MS
         RET
;*************************************************************************************
;*************************************************************************************

I2C_READBYTES_RANDROM_READ:               ;特定地址读#VAL字节

                                          ;假写,送从机写地址，与字地址
         MOV    A,#I2C_CON_WRITE0
         MOV    SENDBUF,A
         CALL   I2C_START
         CALL   SEND_I2C_ONEBYTE
         CALL   I2C_CHECKACK

;         MOV    A,WORD_ADR_M
 ;        MOV    SENDBUF,A
  ;       CALL   SEND_I2C_ONEBYTE
   ;      CALL   I2C_CHECKACK

         MOV    A,WORD_ADR_L
         MOV    SENDBUF,A
         CALL   SEND_I2C_ONEBYTE
         CALL   I2C_CHECKACK

I2C_READBYTES_DATA:
         MOV    A,#I2C_CON_READ0     ;送从机读地址
         MOV    SENDBUF,A
         CALL   I2C_START     
         CALL   SEND_I2C_ONEBYTE
         CALL   I2C_CHECKACK
         B0BTS0   ACKDATA
         JMP    I2C_READBYTES_DATA
         MOV    A,#00
         B0MOV  N03,A
         B0MOV   H,#RECEIVEDATA$M
         B0MOV   L,#RECEIVEDATA$L  
I2C_READBYTES_DATA_01:   ;开始按字节读数据

         CALL   RECEIVE_I2C_ONEBYTE
         INCMS  L
         CALL   I2C_ACK
         CJNE_  N03,#10H,I2C_READBYTES_DATA_01;控制#val的值来控制读 多少字节
         JMP    I2C_READBYTES_END
         
I2C_READBYTES_END:
         CALL   I2C_NOACK
         CALL   I2C_STOP 
         CALL   DELAY10MS
         RET 
      
;*************************************************************************************
RECEIVE_I2C_ONEBYTE:      ;接收一个字节,数据放在RECEIVEBUF ,先收的为高位，
        B0MOV  R,#08
        INCMS  N03  ;N03记录读了多少字节
RECEIVE_I2C_ONEBYTE_START:;判断接收的是1  or  0
        SCLL
        READMODE     ;先拉低SCL允许SDA改变，再设置读模式，读SDA
        SCLH
        B0BTS0   SDA
        JMP    RECEIVE_I2C_ONEBYTE_1
        JMP    RECEIVE_I2C_ONEBYTE_0 
RECEIVE_I2C_ONEBYTE_0:; 收 0
        NOP
        NOP
        RLCM   RECEIVEBUF     ;先收的为高位，所以先左移再，给最后一位置1或置0
        B0BCLR   RECEIVEBIT   ;RECEIVEBIT EQU RECEIVEBUF.0
        DECMS  R
        JMP    RECEIVE_I2C_ONEBYTE_START
        JMP    RECEIVE_I2C_ONEBYTE_END
RECEIVE_I2C_ONEBYTE_1: ; 收 1
        NOP
        NOP
        RLCM   RECEIVEBUF
        B0BSET   RECEIVEBIT
        DECMS  R
        JMP    RECEIVE_I2C_ONEBYTE_START
        JMP    RECEIVE_I2C_ONEBYTE_END
RECEIVE_I2C_ONEBYTE_END: ; 收满8bit退出接收
 
        MOV     A,RECEIVEBUF
        B0MOV     @HL,A
        RET 
;*************************************************************************************


                       
;*************************************************************************************
;NAME:			write_eeprom_delay
;INPUT:			NONE
;FUNCTION:		
;DESCRIBE:		NONE
;CALL SUBPROGRAM:	NONE
;USING RESOURCE:	A,wk00,r
;STACK NEED:		0
;OUTPUT:		wk00
;*************************************************************************************
delay10us:				;10k
	b0mov	rbank,#01
	mov	a,#10
	mov	i2c_delay,a
delay10u0s10:
	decms	i2c_delay
	jmp	delay10u0s10
	b0mov	rbank,#00
	ret 
delay5us:				;10k
	b0mov	rbank,#01
	mov	a,#5
	mov	i2c_delay,a
delay10u0s20:
	decms	i2c_delay
	jmp	delay10u0s20
	b0mov	rbank,#00
	ret 
;*************************************************************************************
WRITE_00:
        B0MOV   Y,#WRITE_TABLE$M
        B0MOV   Z,#WRITE_TABLE$L
        B0MOV   H,#WRITEDATA$M
        B0MOV   L,#WRITEDATA$L
        MOV     A,#00
        MOV     N00,A
WRITE_01:
        MOVC
        B0MOV     @HL,A ;查表从WRITEDATA[0]开始赋值
        INCMS   L
        INCMS   Z
        MOV     A,#01
        ADD     N00,A
        CJNE_    N00,#10H,WRITE_01;;#VAL控制WRITEDATA[val]的数个数
        RET

