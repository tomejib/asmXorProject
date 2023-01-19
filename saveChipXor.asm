IDEAL
MODEL small
STACK 100h
P186  
JUMPS
DATASEG
; --------------------------
; Your variables here

;SOUND VARIBALES
	note dw 3900h ; 1193180 / 13194 -> (hex)
	time_play dw 55 ;defolt one in miliseconds
	
;text varibales
	message db 150 dup ('$')
	secret_msg db 150 dup ('$')
	press_key db 'press any key to see the key$'
	
;image varibales
	chip_pic   db 'chipImg.bmp',0
	key_pic db 'keyImg.bmp', 0
	enter_mesege_print db 'en.bmp', 0
;chip varibales
	key db ? ;- the key to chip
	char db ? ;char
; --------------------------

start_pic   db 'start.bmp',0

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your key here
; --------------------------
	
	; Graphic mode
	mov ax, 13h
	int 10h	
	
	int 10h	
	
	;calling sound to play
	call sound_by_time
	
	;open image 
	mov ax, offset enter_mesege_print 
	call MOR_SCREEN 
	
	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
	
	
	call get_text_from_screen_arr ;getting text from screen
	
	;clering screen
	mov ax, 13h
	int 10h	
	
	;genreate random num
	mov ax, 0FFFEh ;zerongi
	inc al ;al += 1
	call MOR_RANDOM
	
	;puting ax in [key]
	mov [key], al
	
	;calling the func to chip
	call xor_arr_chip
	
	;puting the xor msg
	;puting msg in right p[lace 
	mov dh, 1           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the messege
	mov cx,  offset secret_msg
	call putMessage
	
	;puting the key msg
	;puting key msg in right place 
	mov dh, 20           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the messege *****************************************************
	mov cx,  offset press_key
	call putMessage
	
	
	; wait for any key
	mov ah,1
	int 21h
	
	;sowing the key
	;open image
	mov ax, offset key_pic
	call MOR_SCREEN 
	
	;show the key******************************************************
	;puting the key msg
	;puting key msg in right place 
	mov dh, 17           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the key messege *****************************************************
	mov ax, 0000 ;zeroing ax
	mov al, [key] ;al = key
	call MOR_PRINT_NUM
	
	; wait for any key
	mov ah,1
	int 21h

	; Back to text mode
	call exit_screen
	
exit:
	mov ax, 4c00h
	int 21h




include "myProc.ASM" ;;  MOR_LIBG  -  written by Oren Gross
END start

***************************    PROCEDURES THATS I USED FROM MOR LIB     ***********************************
