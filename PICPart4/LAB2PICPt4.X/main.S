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
    BCF 0x81,7 ; Make PortB have weak pull-ups OPTION_REG 
    MOVLW 0xF0 ; RB7-RB4 inputs, RB3-RB0 outputs
    MOVWF 0x86 ; Sets TRISB for the desired inputs and outputs
    ; WPUB on reset is HIGH, enabling pull-up
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
; Main code goes here
    CLRF 0x20 ; Clears all lower Bits
    CLRF 0x21 ; Clears all higher bits
    
; Checks Row 4 of the 4x4 matrix
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    MOVLW 0xF7 ; Sets RB3 as an output is low, the rest of RB are inputs
    MOVWF 0x86 ; Send W to PortB
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
; Checks each column 1-4
    BTFSS 0x06,4 ; Checks Column 1 for '*' key being pressed
    BSF 0x21,6 ; Set status bit if '1' is pressed
    BTFSS 0x06,5 ; Checks Column 2 for '0' key being pressed
    BSF 0x20,0 ; Set status bit if '2' is pressed
    BTFSS 0x06,6 ; Checks Column 3 for '#' key being pressed
    BSF 0x21,7 ; Set status bit if '3' is pressed
    BTFSS 0x06,7 ; Checks Column 4 for 'D' key being pressed
    BSF 0x21,5 ; Set status bit if '4' is pressed

; Checks Row 3 of the 4x4 matrix
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    MOVLW 0xFB ; Sets RB2 as an output is low, the rest of RB are inputs
    MOVWF 0x86 ; Sets TRISB inputs and outputs 
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
; Checks each column 1-4
    BTFSS 0x06,4 ; Checks Column 1 for '7' key being pressed
    BSF 0x20,7 ; Set status bit if '1' is pressed
    BTFSS 0x06,5 ; Checks Column 2 for '8' key being pressed
    BSF 0x21,0 ; Set status bit if '2' is pressed
    BTFSS 0x06,6 ; Checks Column 3 for '9' key being pressed
    BSF 0x21,1 ; Set status bit if '3' is pressed
    BTFSS 0x06,7 ; Check sColumn 4 for 'C' key being pressed
    BSF 0x21,4 ; Set status bit if '4' is pressed

; Checks Row 2 of the 4x4 matrix
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    MOVLW 0xFD ; Sets RB1 as an output is low, the rest of RB are inputs
    MOVWF 0x86 ; Sets TRISB inputs and outputs
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
; Checks each column 1-4
    BTFSS 0x06,4 ; Checks Column 1 for '4' key being pressed
    BSF 0x20,4 ; Set status bit if '1' is pressed
    BTFSS 0x06,5 ; Checks Column 2 for '5' key being pressed
    BSF 0x20,5 ; Set status bit if '2' is pressed
    BTFSS 0x06,6 ; Checks Column 3 for '6' key being pressed
    BSF 0x20,6 ; Set status bit if '3' is pressed
    BTFSS 0x06,7 ; Checks Column 4 for 'B' key being pressed
    BSF 0x21,3 ; Set status bit if '4' is pressed

; Checks Row 1 of the 4x4 matrix
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    MOVLW 0xFE ; Sets RB0 as an output is low, the rest of RB are inputs
    MOVWF 0x86 ; Sets TRISB inputs and outputs
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
; Checks each column 1-4
    BTFSS 0x06,4 ; Checks Column 1 for '1' key being pressed
    BSF 0x20,1 ; Set status bit if '1' is pressed
    BTFSS 0x06,5 ; Checks Column 2 for '2' key being pressed
    BSF 0x20,2 ; Set status bit if '2' is pressed
    BTFSS 0x06,6 ; Checks Column 3 for '3' key being pressed
    BSF 0x20,3 ; Set status bit if '3' is pressed
    BTFSS 0x06,7 ; Checks Column 4 for 'A' key being pressed
    BSF 0x21,2 ; Set status bit if '4' is pressed

; Sets all of TRISB rows Hi-Z before testing
    BCF 0x03,6 ; Set Bank 1
    BSF 0x03,5 ; Set Bank 1
    MOVLW 0xF0 ; Set all rows to a High Impedance
    MOVWF 0x86 ; Send W to PortB
    BCF 0x03,6 ; Set Bank 0
    BCF 0x03,5 ; Set Bank 0
    
    
    GOTO Test_Hash

;Test Code
    Test_Hash:
    BTFSS 0x21,7 ; Test if # is pressed 
    GOTO Test_Star ; If not, moves to the next priority
    GOTO Disp_Hash ; GOTO the Display for #

    Test_Star:
    BTFSS 0x21,6 ; Test if * is pressed 
    GOTO Test_D ; If not, moves to the next priority
    GOTO Disp_Star ; GOTO the Display for *

    Test_D:
    BTFSS 0x21,5 ; Test if D is pressed 
    GOTO Test_C ; If not, moves to the next priority
    GOTO Disp_D ; GOTO the Display for D
    
    Test_C:
    BTFSS 0x21,4 ; Test if C is pressed 
    GOTO Test_B ; If not, moves to the next priority
    GOTO Disp_C ; GOTO the Display for C

    Test_B:
    BTFSS 0x21,3 ; Test if B is pressed 
    GOTO Test_A ; If not, moves to the next priority
    GOTO Disp_B ; GOTO the Display for B

    Test_A:
    BTFSS 0x21,2 ; Test if A is pressed 
    GOTO Test_9 ; If not, moves to the next priority
    GOTO Disp_A ; GOTO the Display for A

    Test_9:
    BTFSS 0x21,1 ; Test if 9 is pressed 
    GOTO Test_8 ; If not, moves to the next priority
    GOTO Disp_9 ; GOTO the Display for 9

    Test_8:
    BTFSS 0x21,0 ; Test if 8 is pressed 
    GOTO Test_7 ; If not, moves to the next priority
    GOTO Disp_8 ; GOTO the Display for 8

    Test_7:
    BTFSS 0x20,7 ; Test if 7 is pressed 
    GOTO Test_6 ; If not, moves to the next priority
    GOTO Disp_7 ; GOTO the Display for 7

    Test_6:
    BTFSS 0x20,6 ; Test if 6 is pressed 
    GOTO Test_5 ; If not, moves to the next priority
    GOTO Disp_6 ; GOTO the Display for 6

    Test_5:
    BTFSS 0x20,5 ; Test if 5 is pressed 
    GOTO Test_4 ; If not, moves to the next priority
    GOTO Disp_5 ; GOTO the Display for 5

    Test_4:
    BTFSS 0x20,4 ; Test if 4 is pressed 
    GOTO Test_3 ; If not, moves to the next priority
    GOTO Disp_4 ; GOTO the Display for 4

    Test_3:
    BTFSS 0x20,3 ; Test if 3 is pressed 
    GOTO Test_2 ; If not, moves to the next priority
    GOTO Disp_3 ; GOTO the Display for 3

    Test_2:
    BTFSS 0x20,2 ; Test if 2 is pressed 
    GOTO Test_1 ; If not, moves to the next priority
    GOTO Disp_2 ; GOTO the Display for 2

    Test_1:
    BTFSS 0x20,1 ; Test if 1 is pressed 
    GOTO Test_0 ; If not, moves to the next priority
    GOTO Disp_1 ; GOTO the Display for 1

    Test_0:
    BTFSS 0x20,0 ; Test if 0 is pressed 
    GOTO Disp_Dal ; default if no buttons are pressed
    GOTO Disp_0 ; GOTO the Display for 0
    
;Display Code
    Disp_Hash:
    MOVLW 0x23      ;Select the character set for display #
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_Star:
    MOVLW 0x2A      ;Select the character set for display *
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_D:
    MOVLW 0x44      ;Select the character set for display D
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_C:
    MOVLW 0x43      ;Select the character set for display C
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_B:
    MOVLW 0x42      ;Select the character set for display B
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_A:
    MOVLW 0x41      ;Select the character set for display A
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Disp_9:
    MOVLW 0x39      ;Select the character set for display 9
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_8:
    MOVLW 0x38      ;Select the character set for display 8
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_7:
    MOVLW 0x37      ;Select the character set for display 7
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_6:
    MOVLW 0x36      ;Select the character set for display 6
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_5:
    MOVLW 0x35      ;Select the character set for display 5
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_4:
    MOVLW 0x34      ;Select the character set for display 4
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_3:
    MOVLW 0x33      ;Select the character set for display 3
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_2:
    MOVLW 0x32      ;Select the character set for display 2
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_1:
    MOVLW 0x31      ;Select the character set for display 1
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_0:
    MOVLW 0x30      ;Select the character set for display 0
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Disp_Dal:
    MOVLW 0x24      ;Select the character set for display $
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    GOTO Main
    
End