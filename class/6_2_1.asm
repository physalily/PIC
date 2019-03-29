	LIST P=PIC16F84A
	#INCLUDE <P16F84A.INC>

	__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON

W_TEMP 	EQU 	0CH
STATUS_TEMP 	EQU 	0DH 
TMP 	EQU 	0EH
FLG1 	EQU 	0FH
FLG2 	EQU 	10H

	ORG 	0H
	GOTO 	MAIN

	ORG 	04H

;PUSH
	MOVWF 	W_TEMP
	MOVF 	STATUS, W
	MOVWF 	STATUS_TEMP

	MOVF 	PORTB, W
	MOVWF 	TMP

	BTFSC 	TMP, 5
	COMF 	FLG2, F
	BTFSC 	TMP, 4
	COMF 	FLG1, F 

;POP 
	MOVF 	STATUS_TEMP, W
	MOVWF 	STATUS
	SWAPF 	W_TEMP, F
	SWAPF 	W_TEMP, W
	BCF 	INTCON, RBIF

	RETFIE

MAIN
	BCF 	INTCON, GIE
	BSF 	STATUS, RP0
	CLRF 	TRISA
	MOVLW 	030H
	MOVWF 	TRISB
	BCF 	STATUS, RP0
	CLRF 	PORTA
	CLRF 	FLG1
	CLRF 	FLG2
	CLRF 	TMP
	BSF 	INTCON, RBIE
	BSF 	INTCON, GIE
	BCF 	INTCON, RBIF

LOOP
	BTFSC 	FLG1, 0
	BSF 	TMP, 0
	BTFSS 	FLG1, 0
	BCF 	TMP, 0

	BTFSC 	FLG2, 0
	BSF 	TMP, 1
	BTFSS 	FLG2, 0
	BCF 	TMP, 1

	MOVFW 	TMP
	MOVWF 	PORTA
	GOTO 	LOOP
END