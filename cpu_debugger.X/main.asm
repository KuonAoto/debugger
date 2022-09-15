
; PIC16F57 Configuration Bit Settings

; Assembly source line config statements

#include "p16f57.inc"

; CONFIG
; __config 0xFFE
 __CONFIG _OSC_HS & _WDT_ON & _CP_OFF

TMP	EQU	0x09
CNT	EQU	0x0A
	
#DEFINE TX	PORTA,3	

    ;割り込みないので0番地から
    ORG 0X000
	
    ;初期設定
    ;バンク0
    ;BCF	    STATUS,PA0
    ;BCF	    STATUS,PA1
    
    ;タイマー設定
    MOVLW   B'00000001'
    OPTION
    
    ;ピンの入出力
    MOVLW   B'00001000'
    TRIS    PORTA
    MOVLW   B'00000000'
    TRIS    PORTB
    MOVLW   B'00000000'
    TRIS    PORTC
    CLRF    PORTB
    CLRF    PORTC
    
    MOVLW   B'10000000'
    MOVWF   PORTB
    
MAIN
    ;テスト用
    MOVLW   B'00000001'
    MOVWF   PORTB
MAIN_LOOP
    ;スタートビット(0)が来たら、スキップ
    BTFSC   TX
    GOTO    MAIN_LOOP
    ;7Dをセット（スタートビットから1ビット目までの時間
    MOVLW   0x7D
    MOVWF   TMR0
    ;8bit分
    MOVLW   0x08
    MOVWF   CNT
    
    MOVLW   B'00000010'
    MOVWF   PORTB
    CLRF    TMP
S_WAIT_LOOP
    ;タイマー
    INCF    TMR0
    DECFSZ  TMR0
    GOTO    S_WAIT_LOOP
    ;タイマー0が0になったら

M_WAIT_LOOP
    
    MOVLW   B'00000100'
    MOVWF   PORTB

    
    ;キャリーを0の状態で
    BCF	    STATUS,0
    ;1だったらキャリーを立てる
    BTFSC   TX
    BSF	    STATUS,0
    RLF	    TMP
    
    MOVLW   0x3C
    MOVWF   TMR0
    
    DECFSZ  CNT
    GOTO    S_WAIT_LOOP
    
    ;テスト用
    MOVF    TMP,W
    MOVWF   PORTC
    
    GOTO MAIN
    
    END