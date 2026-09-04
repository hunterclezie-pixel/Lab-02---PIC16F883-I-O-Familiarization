// Hunter Clezie
// RCET3373
// First Program
// Git url if you have one 

; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  
; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto Setup

; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2
 
Setup:
    ; add device setup here
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
    
    ; PORTB Code:
    ; CCP1CON on power up reset is all LOW
    ; INTCON on power up reset is all LOW
    CLRF 0x06 ; Setting PORTB on reset to LOW
    
    ; PORTC Code:
    ; CCP1CON on power up reset is all LOW
    ; CCP2CON on power up reset is all LOW
    CLRF 0x07 ; Setting PORTC on reset to LOW
    ; RCSTA on power up reset is all LOW
    ; SSPCON on power up reset is all LOW
    ; T1CON on power up reset is all LOW
    
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    
    ; PORTB Code:
    ; OPTION_REG on power up reset is all HIGH
    MOVLW 0xFF ; Sets all bits high for TRISB
    MOVWF 0x86 ; Setting TRISB on reset to HIGH, making PORTB an input
    CLRF 0x95 ; Sets WPUB bits on reset LOW, disabling pull-up
    ; ICOB on power up reset is all HIGH
    
    ; PORTC Code:
    ; PSTRCON on power up reset is all LOW
    CLRF 0x87 ; Setting TRISC on reset to LOW, making PORTC an output
    
    BSF 0x03,6 ; Sets Bank 2
    BCF 0x03,5 ; Sets Bank 2
    
    ; PORTB Code:
    BSF 0x09,1 ; Setting bit 1 for CM2CON1 HIGH
    
    BSF 0x03,6 ; Sets Bank 3
    BSF 0x03,5 ; Sets Bank 3
    
    ; PORTB Code:
    CLRF 0x89 ; Setting the ANSELH to LOW for the I/O to be digital
    BCF 0x03, 6
    BCF 0x03, 5
    
    goto Main
    
Main:
    // main code goes here
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
    
    ; Check switches from highest priority to lowest
    BTFSC   0x06, 7 ; Checks if RB7 = 1
    GOTO    DISPLAY_7 ; If RB7 = 1, go to Display 7

    BTFSC   0x06, 6 ; Checks if RB6 = 1
    GOTO    DISPLAY_6 ; If RB6 = 1, go to Display 6

    BTFSC   0x06, 5 ; Checks if RB5 = 1
    GOTO    DISPLAY_5 ; If RB5 = 1, go to Display 5

    BTFSC   0x06, 4 ; Checks if RB4 = 1
    GOTO    DISPLAY_4 ; If RB4 = 1, go to Display 4

    BTFSC   0x06, 3 ; Checks if RB3 = 1
    GOTO    DISPLAY_3 ; If RB3 = 1, go to Display 3

    BTFSC   0x06, 2 ; Checks if RB2 = 1
    GOTO    DISPLAY_2 ; If RB2 = 1, go to Display 2

    BTFSC   0x06, 1 ; Checks if RB1 = 1
    GOTO    DISPLAY_1 ; If RB1 = 1, go to Display 1

    BTFSC   0x06, 0 ; Checks if RB0 = 1
    GOTO    DISPLAY_0 ; If RB0 = 1, go to Display 0

    ; If no switches are active
    MOVLW   0x24 ; Display "$"
    MOVWF   0x07 ; Display output port
    GOTO    Main

;Display Outputs
DISPLAY_7:
    MOVLW   0x37 ; Display "7"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_6:
    MOVLW   0x36 ; Display "6"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_5:
    MOVLW   0x35 ; Display "5"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_4:
    MOVLW   0x34 ; Display "4"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_3:
    MOVLW   0x33 ; Display "3"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_2:
    MOVLW   0x32 ; Display "2"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_1:
    MOVLW   0x31 ; Display "1"
    MOVWF   0x07 ; Display output port
    GOTO    Main

DISPLAY_0:
    MOVLW   0x30 ; Display "0"
    MOVWF   0x07 ; Display output port
    GOTO    Main
End