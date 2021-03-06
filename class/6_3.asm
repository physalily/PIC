	LIST	P=PIC16F84A
	#INCLUDE	<P16F84A.INC>
	__CONFIG 	_HS_OSC & _WDT_OFF & _PWRTE_ON

RESERVE_W	EQU	0CH

	ORG 	0H
	GOTO	INIT

	ORG	04H

	GOTO	OPENING

	GOTO	MOLEATTACK
	
	GOTO	ENDING

	RETFIE

INIT
	BCF	INTCON, GIR
	BSF	STATUS, RP0
	
	BCF	STATUS, RP0
	
	
	BSF	INTCON, RBIE
	BSF	INTCON, GIE
	BCF	INTCON, RBIF

LOOP
	MOVFW	RESERVE
	MOVWF	PORTA
	GOTO	LOOP	

MOLEATTACK
	GOTO	MOLEUP
	GOTO	CHKBUTTON
	GOTO	MOLEDOWN
	GOTO	CHKSCORE
	RETURN
OPENING

	RETURN
ENDING

	RETURN