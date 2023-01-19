; Yuval Miodownik

IDEAL
MODEL small
STACK 100h
P186  ; ! for PUSHA + POPA
JUMPS ; ! for long jumps
DATASEG

; --------------------------
; Your variables here
; --------------------------
	save_x  dw ?  ;save_x = ?
	save_y  dw ?  ;save_y = ?
	x_coordinate dw 100 ;x_coordinate = 100
	y_coordinate dw 150;y_coordinate = 150
	color dw 4 ;color = 
	len dw 10 ; len = 10
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	;statr grafhic
	mov ax, 13h
	int 10h
	
	
	;moving x_coordinate to save_x
	mov ax, [x_coordinate]
	mov [save_x], ax ;save_x = ax
	
	;moving y_coordinate to save_y
	mov ax, [y_coordinate]
	mov [save_y], ax ;save_x = ax
	
	mov cx, 255 ;10 times to do 
super_draw  :
	;mov y_coordinate 150
	mov [y_coordinate], 150

	
	;changing the color
	mov bx, cx ;bx = cx
	inc bx ;bx = bx + 1
	mov [color], bx;color = red

	call draw_rectangele ;call draw_rectangele
	
	;wait 0.1 seconds
	mov ax, 100
	call MOR_SLEEP
	
	;clear screen
	mov ax, @data
	mov ds, ax
	mov ax, 13h
	int 10h


	
	loop super_draw ;loping the loop
	
	;end wait for keyboard
	mov ah, 0h
	int 16h
	
	
	
	;back to text
	mov ax, 2h
	int 10h
	
	
exit:
	mov ax, 4c00h
	int 21h
	
INCLUDE "MOR_LIB.ASM"

; draws one pixel
proc draw_pixel
pusha
	;draw pixel
	xor bh, bh ; bh = 0
	mov cx, [x_coordinate]
	mov dx, [y_coordinate]
	mov ax, [color]
	mov ah, 0ch
	int 10h
popa
ret
endp draw_pixel


; draws a line of pixels
proc draw_line
	pusha
	; move x_coordinate to x_temp
	mov ax, [x_coordinate]
	mov cx, [len]
	draw:
		call draw_pixel
		inc [x_coordinate]
		loop draw
		popa
	ret
endp draw_line

;draw rectangele
proc draw_rectangele
	pusha
	mov cx, 10 ;num of loops
	rectangele_loop:
		call draw_line ;call draw_line
		inc [y_coordinate] ;y_coordinate++
		mov [x_coordinate], 100 ;x_coordinate = 100
		loop rectangele_loop ;dec cx, if cx bigger than zero than go to rectangele_loop
	popa
	ret

endp draw_rectangele
END start

***************************    PROCEDURES HEADS     ***********************************

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




