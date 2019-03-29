	LIST P=PIC16F84A
	#INCLUDE <P16F84A.INC>

	__CONFIG _HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_ON	

W_TEMP	EQU	0CH
STATUS_TEMP	EQU	0DH
CNT1	EQU	0EH
CNTB	EQU	0FH
IN	EQU	012H

	ORG	0H
	GOTO	MAIN
	ORG	04H

;PUSH
	MOVWF	W_TEMP
	MOVF	STATUS,W
	MOVWF	STATUS_TEMP

	MOVLW	'A'
	CALL	CSEND
;POP
	MOVF	STATUS_TEMP,W
	MOVWF	STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W
	BCF	INTCON,INTF
	RETFIE

;REMAINNG CODE GOES HERE

MAIN
	BSF	STATUS, RP0
	BCF	INTCON, GIE
	CLRF	TRISA
	MOVLW	01H
	MOVWF	TRISB
	BCF	STATUS, RP0
	BSF	PORTA,4
	BSF	INTCON, GIE
	BSF	INTCON, INTE

MAINLP
	GOTO 	MAINLP

CSEND
	MOVWF	IN
	MOVLW	08H
	MOVWF	CNTB
	BCF	PORTA, 4
	CALL TIME104

CSENDLP
	BTFSC	IN,0
	BSF	PORTA, 4
	BTFSS	IN,0
	BCF	PORTA, 4
	CALL 	TIME104
	RRF	IN, F
	DECFSZ	CNTB, F
	GOTO	CSENDLP
	BSF	PORTA, 4
	CALL	TIME104
	RETURN

;104us
TIME104
	MOVLW	082h
	MOVWF	CNT1
LOOP2
	NOP
	DECFSZ	CNT1, F
	GOTO	LOOP2
	RETURN

	END