	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"
	
	__CONFIG	_HS_OSC &_WDT_OFF
;timer counter 
CNT1	EQU	0CH
CNT2	EQU	0DH
CNT3	EQU	0EH
;output data set
LA1	EQU	1CH		
LA2	EQU	1DH
LB1	EQU	2CH
LB2	EQU	2DH
;flag set
LAF	EQU	1EH
LBF	EQU	1FH

	ORG	0H
INIT	
	BSF	STATUS, RP0
	CLRF	TRISB
	CLRF	TRISA
	BCF	STATUS, RP0
	BCF	STATUS, C
	MOVLW	b'10000000'
	MOVWF	PORTB
	CLRF	PORTA
	MOVWF	LA1
	CLRF	LA2
	MOVWF	LB1
	CLRF	LB2
	CLRF	LAF
	CLRF	LBF
MAINLOOP
	CALL	TIME50M
	CALL	LIGHT_A
	CALL	OUTPUTS
	CALL	TIME50M
	CALL	LIGHT_B
	CALL	LIGHT_A
	CALL	OUTPUTS
	GOTO	MAINLOOP
OUTPUTS
	MOVF	LA1, W
	IORWF	LB1, W
	MOVWF	PORTB
	MOVF	LA2, W
	IORWF	LB2, W
	MOVWF	PORTA
	RETURN
LIGHT_A
	BTFSS	LAF, 000H
	CALL	RSH
	BTFSC	LAF, 000H
	CALL	LSH
	RETURN	
RSH
	RRF	LA1, F
	BTFSC	STATUS, C
	BSF	LA2, 002H
	BCF	STATUS, C
	RRF	LA2, F
	BTFSC	STATUS, C
	COMF	LAF
	RETURN
LSH
	RLF	LA2, F
	BTFSC	LA2, 002H
	BSF	STATUS, C
	BCF	LA2, 002H
	RLF	LA1, F
	BTFSC	STATUS, C
	CALL	LSHR
	RETURN
LSHR
	COMF	LAF
	RRF	LA1, F
	RETURN
LIGHT_B
	RRF	LB2, F
	RRF	LB1, F
	BTFSC	STATUS, C
	BSF	LB2, 001H
	BCF	STATUS, C
	RETURN
;software loop counter
TIME100U
	MOVLW	0A5H
	MOVWF	CNT1
	NOP
	NOP
LOOP1
	DECFSZ	CNT1, F
	GOTO	LOOP1
	RETURN

TIME10M
	MOVLW	063H
	MOVWF	CNT2
	NOP
	NOP
LOOP2
	CALL	TIME100U
	DECFSZ	CNT2, F
	GOTO 	LOOP2
	RETURN

TIME50M
	MOVLW	005H
	MOVWF	CNT3
LOOP3
	CALL	TIME10M
	DECFSZ	CNT3, F
	GOTO	LOOP3
	RETURN

	END