	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"
	
	__CONFIG	_HS_OSC &_WDT_OFF

CNT1	EQU	0CH
CNT2	EQU	0DH
CNT3	EQU	0EH

	ORG	0H
INIT
	BSF	STATUS, RP0
	CLRF	TRISB
	BCF	STATUS, RP0
	BCF	STATUS, C
	MOVLW	b'11000000'
	MOVWF	PORTB
LOOP
	CALL	TIME125M
	RRF	PORTB, W
	BTFSC	STATUS, C
	CALL	STEP
	MOVWF	PORTB
	GOTO	LOOP
STEP
	BCF	STATUS, C
	MOVF	PORTB
	IORLW	b'10000000'
	MOVWF	PORTB
	RETURN

TIME100U
	MOVLW	0A5H
	MOVWF	CNT1
	NOP
	NOP
LOOP100U
	DECFSZ	CNT1, F
	GOTO	LOOP100U
	RETURN

TIME5M
	MOVLW	031H	;49
	MOVWF	CNT2	
LOOP5M
	CALL	TIME100U
	NOP
	NOP
	DECFSZ	CNT2, F
	GOTO	LOOP5M	
	RETURN	
	
TIME125M
	MOVLW	019H	;25
	MOVWF	CNT3
LOOP125M
	CALL	TIME5M
	DECFSZ	CNT3, F
	GOTO	LOOP125M
	RETURN
	
	END
