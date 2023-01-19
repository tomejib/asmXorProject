IDEAL
MODEL small
STACK 100h
P186  
JUMPS
DATASEG
; --------------------------
; Your variables here

;SOUND VARIBALES
	note dw 1394h ; 1193180 / 131 -> (hex)
	time_play dw 100 ;defolt one in miliseconds
	
;text varibales
	message db 66 dup ('$')
	
;image varibales
	chip_pic   db 'chipImg.bmp',0
; --------------------------

start_pic   db 'start.bmp',0

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	
	; Graphic mode
	mov ax, 13h
	int 10h	
	
	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
		
	;getting the msg
	mov dx, offset message
	mov bx, dx
	mov [byte ptr bx], 64 ;63 not 62, the last input is ENTER
	mov ah, 0Ah
	int 21h
	
	;reset screen
	mov ax, 13h
	int 10h	
	
	mov cx, 64 ;cx = 21
	mov bx, 0;
	;resting arr
minusEachArr:
	add bx, 2 ;bx += 2
	mov al,  [message + bx]
	sub bx, 2 ;bx -= 2
	mov [message + bx], al
	inc bx
	
	;looping
	loop minusEachArr
	
	;puting msg
	mov dh, 2           ;Cursor position line
	mov dl, 2         ;Cursor position column
	
	
	;printing the messege
	mov cx,  offset message
	call putMessage
	
	
endText:
	; wait for any key
	mov ah,1
	int 21h
	
	; Back to text mode
	call exit_screen
	
	
exit:
	mov ax, 4c00h
	int 21h
	


;THIS PROC TAKES CODE FROM OUR ASSMBLY BOOK - https://data.cyber.org.il/assembly/assembly_book.pdf and was edited by  Tom Mejibovski 
;DO 	: makes sound for some second
;IN  	: [note] - the number represents the sound frequency [time_play] - the seconds do play
;OUT 	: SOUNd in the right frequency and BL timws
;EFFECTED REGISTERS : NONE
proc sound_by_time
	PUSHA ;save the registors
	
	; open speaker
	in al, 61h
	or al, 00000011b
	out 61h, al
	
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	
	; play frequency 131Hz
	mov ax, [note]
	
	out 42h, al ; Sending lower byte
	mov al, ah
	
	out 42h, al ; Sending upper byte
	
	mov ax, [time_play] ;ax = time_play
	call MOR_SLEEP ;sleeping the time nedd
	
	; close the speaker
	in al, 61h
	and al, 11111100b
	out 61h, al
	
	POPA ;returning th main rgistors
	ret ;returning to main 
endp sound_by_time ;end prociduration

;DO 	: exit grafic mode
;IN  	: NONE
;OUT 	: NONE but exist grafic mode
;EFFECTED REGISTERS : NONE
proc exit_screen
	pusha;save main registors
	
	;back to from grafick mode
	mov ah, 0 ; ah = 0
	mov al, 2 ; al = 2
	int 10h ;
	
	popa;pop main registors
	ret ;returning to main program
endp exit_screen ;end prociduration



include "MOR_LIBG.ASM" ;;  MOR_LIBG  -  written by Oren Gross
END start

***************************    PROCEDURES THATS I USED FROM MOR LIB     ***********************************

Proc MOR_PRINT_NUM
;DO 	: Prints a number in base 10
;IN  	: AX - the number
;OUT 	: NONE
;EFFECTED REGISTERS : NONE


Proc MOR_SLEEP
;DO 	: sleep and return after AX mili second
;IN  	: AX - unsigned - hold delay time in msec  
;OUT 	: NONE
;EFFECTED REGISTERS : NONE

Proc MOR_RANDOM
;DO 	: generate pseudo random number
;IN  	: AX - the range  ( 0 till AX-1)
;OUT 	: AX - the generated random number  
;EFFECTED REGISTERS : NONE

Proc MOR_GET_KEY  
;DO :  get key from Type Ahead Buffer (TAB)
;IN  : NONE
;OUT :  ZF - FALSE (0) when key exist  AL - ASCII  AH - scan code
;EFFECTED REGISTERS : NONE

proc MOR_LOAD_BMP
; DO : load a BMP at location (x,y)
; IN : ax - filename cx - x dx - y
; OUT : None
; effected registers : None

proc MOR_SCREEN
; DO : take a BMP and put it on screen ( starting from location 0,0)
; IN : ax filename
; OUT : None
; effected registers : None

proc putMessage
;==============================================
;   putMessage  - print message on screen
;   IN: DH= row number  , DL = column number  , cx = the message (offset)
;   OUT:  NONE
;	AFFECTED REGISTERS AND VARIABLES: NONE

proc drawPixel
;==============================================
;   drawPixel  – draw a pixel at  X,Y  
;   IN: CX=X  , DX =Y , AL = COLOR 
;   OUT:  NONE
;	AFFECTED REGISTERS AND VARIABLES : NONE

proc drawLine
;==============================================
;   drawLine  – draw a line starting at  X,Y  
;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH
;   OUT:  NONE
;	AFFECTED REGISTERS AND VARIABLES: NONE

proc drawRect	
;==============================================
;   drawRect  – draw a rectangle starting at  X,Y  
;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
;   OUT:  NONE
;	AFFECTED REGISTERS AND VARIABLES: NONE