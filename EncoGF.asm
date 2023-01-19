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
    key_enter db 'pressKey.bmp', 0
	chip_pic   db 'chipImg.bmp',0
	key_pic db 'keyImg.bmp', 0
	enter_mesege_print db 'enterMsg.bmp', 0
	choose_what_to_do db 'choiseDo.bmp', 0
	start_pic   db 'start.bmp',0
	ascii_img db 'ascii.bmp', 0
	main_choise db 'mainPic.bmp', 0
	succes db 'Done.bmp',0

;chip varibales
	key db ? ;- the key to chip
	char db ? ;char
;file varibales
	filename db 'txtMain.txt',0
	local_filehandle dw ?
	msg_to_show_on_file db '3455$'
	ErrorMsg db 'Error', 10, 13,'$'
	NumOfBytes dw 150

; --------------------------



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

	;***********************SOUND******************
	;calling sound
	call sound_by_time

	;loop sound
	mov cx, 5 ;max the loop 5 times

	sound_loop:
		mov ax, [note] ;ax = note
		add ax, 500h ;increasingx ax by 500
		mov [note], ax  ;note = ax

		call sound_by_time
		loop sound_loop

	;****************** image open *****************

	; open start_pic
	mov ax, offset start_pic
	call MOR_SCREEN

	call input_with_sound ;input with sound

;**main opening program
defolt_choise:
	; open main choise
	mov ax, offset main_choise
	call MOR_SCREEN

	call input_with_sound ;input with sound

	cmp al , '3' ;comparong al to '3'
	je exit ;if equal jump to exit program

	cmp al, '2' ;comparing al to 2
	je screeen_encode ;if equal jump to screen encode

	cmp al, '1' ;comparing al to 1
	je encode_txt_file_type ;if equal jump to encode_txt_file_type

	jmp defolt_choise ;jumping to default


;THIS IS ENCODE FROM TEXT FILE
encode_txt_file_type:
	;open image key_enter
	mov ax, offset key_enter
	call MOR_SCREEN

	call recetVaribels ;recing varibles

	call input_with_sound ;wating till key pressed

	call getKey ;getting key to encode

	call openAndRead ;reading file

	call MesageToSecretXor ;doing the encode

	call openAndWrite ;writing in file

	mov ax, offset succes ;open succes img
	call MOR_SCREEN ;open succes img

	call input_with_sound ;wating till any key preesed

	jmp defolt_choise ;jumping to defolt_choise

;*****ENCODE FROM SCREEEN
screeen_encode:
	;****main program loop****
main_program_loop:
	;open image coose
	mov ax, offset choose_what_to_do
	call MOR_SCREEN

	call recetVaribels; recing varibles

	call input_with_sound ;input with sound

	;cheking if the user want to exit
	cmp al, '3' ;comparing al, 3
	je defolt_choise ;if equal jump to exit

	;cheking if user want to encrypt
	cmp al, '1' ;comparing al to 1
	jne chek_if_decrypt ;if not eqal jump to decrtpte

	call main_xor_program ;call main_xor_program

chek_if_decrypt:

	;chek if user wants to decrypt
	cmp al, '2' ;comparing al to 2
	jne chek_if_ascii ;if not equal jump to chek_if_ascii

	call main_encode_xor ;calling main_encode_xor

chek_if_ascii:
	;chek if user want to chek ascii
	cmp al, '4';comparing al, 4
	jne jump_back ;if not equl jump to jump_back


	; open open ascii_img
	mov ax, offset ascii_img
	call MOR_SCREEN

	call input_with_sound ;input with sound

jump_back:
	jmp main_program_loop;jumping to main program


exit:
	mov cx, 5 ;loop of 5

sound_end:
	mov ax, 6000 ;genarate random num 0 -6000
	call MOR_RANDOM;genarate random num 0 -6000

	add ax, 1000 ;ax += 1000
	mov [note], ax ;note = ax
	call sound_by_time ;playing random note

	loop sound_end ;looping sound_end

    call exit_screen ;exiting screen

	;exiting back to main
	mov ax, 4c00h
	int 21h



include "GfEnProc.ASM" ;;  MOR_LIBG  -  written by Oren Gross
END start

***************************    PROCEDURES THATS I USED FROM MOR LIB     ***********************************
