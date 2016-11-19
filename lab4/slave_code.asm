;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   �� ��� 21 2016
; Processor: AT89C51
; Compiler:  ASEM-51 (Proteus)
;====================================================================

$NOMOD51
$INCLUDE (8051.MCU)

;====================================================================
; DEFINITIONS
;====================================================================

;====================================================================
; VARIABLES
;====================================================================
      DEST_IND     DATA P1
      DESTINATION  DATA 24h
      MESSAGE      DATA P2
      THIS_ADDRESS DATA 22h
      RCVD_ADDRESS DATA 23h 
      ADDRESS_SEND BIT  21h.0
      DATA_SEND    BIT  21h.1
      RECIEVED_MSG DATA 20h
;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      org   0000h
      jmp   Start
      
      org   000bh
	 clr TF0
	 call Send
	 reti
      org   001bh
	 reti
      org   0023h
	 call SerialHandle
      

;====================================================================
; CODE SEGMENT
;====================================================================

      org   0100h
Start:	
           ;Write your code here

      setb EX1
      setb ES
      setb EA
      setb ET0
      setb IT1
      
      ;mov  SCON, #11010000b
      ;clr RI
      
      setb sm0 
      setb sm1 
      clr  sm2 
      
      setb ren 
      clr  tb8 
      clr  rb8 
      orl  pcon,#128
      
      
      mov  THIS_ADDRESS, #1
      mov  TH1, #0FDh
      mov  TL0, #0FFh
      mov  TH0, #0FFh
      mov  TMOD,#00100110b
      setb TR1
      setb TR0
      clr  ADDRESS_SEND
Loop:	
      jmp Loop

Send: 
      clr DATA_SEND
      call SetDestination
      mov DEST_IND, DESTINATION
      clr TB8
      mov SBUF, DESTINATION
      cpl ADDRESS_SEND
      ret
SerialHandle:
      jb  TI, TransmitComplete
      jb  RI, ReadComplete
      jmp HandleEnd
      TransmitComplete:
         clr TI
	 jb   DATA_SEND, HandleEnd
	 jnb  ADDRESS_SEND, HandleEnd
	 cpl  ADDRESS_SEND
	 setb TB8
	 setb DATA_SEND
	 mov  SBUF, MESSAGE
	 jmp  HandleEnd
      ReadComplete:
	 clr RI
	 jb  RB8, ReadData 
	 ReadAddress:
	    mov a, SBUF
	    mov RCVD_ADDRESS, SBUF
	    mov P1, SBUF
	    jmp HandleEnd
	 ReadData:
	    mov  a, RCVD_ADDRESS
	    cjne a, THIS_ADDRESS, HandleEnd
	    mov  a, SBUF
	    rl   a
	    rl   a
	    rl   a 
	    rl   a
	    anl  a, #11110000b
	    orl  a, DEST_IND
	    mov  DEST_IND, a
	    
      HandleEnd:
	    reti
SetDestination:
      mov  DESTINATION, P0
      mov  a, DESTINATION
      cjne a, #0 ,INC_DEST   ; a<0?
      ret
      INC_DEST:	
	 inc DESTINATION
	 ret	 
	 
	 
	 
;====================================================================
      END
