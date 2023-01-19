

CODESEG
;DO 	:opens file
;IN  	: , [local_filehandle] [ErrorMsg]
;OUT 	: opens file and [local_filehandle] maybey with eror msg
;EFFECTED REGISTERS : Aס, DX, [local_filehandle]
proc OpenFile
; Open file for reading and writing
	mov ah, 3Dh
	mov al, 2
	mov dx, offset filename
	int 21h
	jc local_openerror
	mov [local_filehandle], ax
	ret
	local_openerror :
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	ret
endp OpenFile

;*****all yhe file procidurs I took from assembly book, the link to the book - https://data.cyber.org.il/assembly/assembly_book.pdf*******************************
;DO 	: reads and stroes in [message] text from txt file
;IN  	: [local_filehandle], [NumOfBytes] and the file must exist and opened and al neets to be 0 or 2
;OUT 	: [message], the arr off ,essege you want to encode
;EFFECTED REGISTERS : AH, BX, CX, DX, [message]
proc ReadFile
	; Read file
	mov ah,3Fh
	mov bx, [local_filehandle]
	mov cx, [NumOfBytes]
	mov dx,offset message
	int 21h
	ret
endp ReadFile



;DO 	:write text in file
;IN  	: [local_filehandle], the file muat bw opened and can be changed, [secret_msg]
;OUT 	: changed txt file
;EFFECTED REGISTERS : ah, bx, dx and the txt file
proc WriteToFile
; Write secret_msg to file
	mov ah,40h
	mov bx, [local_filehandle]
	mov dx,offset secret_msg
	int 21h
	ret;returning
endp WriteToFile ;end prociduration

;DO 	:closes file
;IN  	: [local_filehandle]
;OUT 	:  closes file
;EFFECTED REGISTERS : ah and bx
proc CloseFile
	; Close file
	mov ah,3Eh
	mov bx, [local_filehandle]
	int 21h
	ret
endp CloseFile

;DO 	:open the file, readTheFile and colses it
;IN  	: [local_filehandle], [NumOfBytes] , [ErrorMsg]
;OUT 	:  [Message], [local_filehandle]
;EFFECTED REGISTERS : NONE, varibels: [local_filehandle], [Message]
proc openAndRead
	; Process file
	call OpenFile ;calling open fiel
	mov cx, 0 ;cx = 0
	call ReadFile ;calling reafFile
	
	call CloseFile ;calling close file
	ret 
endp openAndRead

;DO 	:opens, erasing and write and reads on txt file
;IN  	: [local_filehandle], [NumOfBytes] , [ErrorMsg], [meesege]
;OUT 	:  [local_filehandle] and chage txt file
;EFFECTED REGISTERS : txt file 
proc openAndWrite
	PUSHA ;saving rejistros
; Process file
	call OpenFile
	mov cx, 0 ;cx = 0
	call WriteToFile
	
	mov bx, 0 ;bx = 0
file_chek:
	cmp [secret_msg + bx], '$' ;compraing the mesge to $
	je write_file ;jumping equl to write_file
	inc bx ;cx += 1
	jmp file_chek ;jumping to file_chek
	
write_file:	
	mov cx, bx ;cx = bx
	call WriteToFile
	call CloseFile
	POPA ;poping rejistors
	ret ;returning to main
endp openAndWrite

;***********END	 of file prociduration
;==============================================
;   do  – the prociduration that doing encode to xor text, gets encoded text and returned normall text
;   IN: [time_play] זמן להפעלת צלילים , [note] תו שיתנגן , [message] הודעה לפניי הצפנה, [secret_msg] הודעה מוצפנת, [press_key] תמונת לחצת מפתח, [chip_pic] תמונה לבלת מחרוזת טקטס, [key_enter] תמונה שמחכה שתו ילחץ, [enter_mesege_print] מחרוזת שמראה טאת הקטסט הסופי  המוצפן
;   OUT:  chage in graficks and chnges this varibales [key] מפתח , [secret_msg] הודעה סודית, [key] מפתח להצפנה, [char] תו להצפנה: 
;	AFFECTED REGISTERS AND VARIABLES: [key] מפתח , [secret_msg] הודעה מוצפנת, , [char]
; =============================================
proc main_encode_xor
	pusha;save main registors
	
		; Graphic mode
	mov ax, 13h
	int 10h	
	
	;calling sound to play
	call sound_by_time
	
	;open image 
	mov ax, offset enter_mesege_print 
	call MOR_SCREEN 
	
	call input_with_sound ;input with sound
		
	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
	
	call get_text_from_screen_arr ;getting text from screen
	
	;open image
	mov ax, offset key_enter
	call MOR_SCREEN 
	
	call input_with_sound ;input with sound
	
	
	;call geting key
	call getKey
	
	
	;doing xor
	call xor_arr_chip
	
	;puting the xor msg
	;puting msg in right p[lace 
	mov dh, 1           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the message
	mov cx,  offset secret_msg
	call putMessage
	
	call input_with_sound ;input with sound
	
	call sound_by_time ;playimg music
	
	popa;pop main registors
	ret ;returning to main program
endp main_encode_xor ;end prociduration


;==============================================
;   do  – the prociduration that doing encode to xor chip 
;   IN:[time_play] זמן להשמעת צליל, [note] התוו מוזיקלי להשמעה, [message] הודעה לפניי הצפנהה, [secret_msg] הודעה אחריי הצפנה, [press_key] תמונה ללחוץ כפתור, [chip_pic] תמונה לקיטת תווים, [key_enter] תמונה להראות מפתח, [enter_mesege_print] תמונה המראה את המפשט המוצפן
;   OUT:  chage in graficks and chnges this varibales:  [key] המפתח להצפנה, [message] הודעה להצפנה, [secret_msg] מערך של תווים0 לאחר הצפנה, [char] - תו של מחרוזת לפניי הצפנה.
;	AFFECTED REGISTERS AND VARIABLES: [key], [message], [secret_msg], [key], [char]
; =============================================
proc main_xor_program
	pusha;save main registors
	
	;calling sound to play
	call sound_by_time
	
	;open image 
	mov ax, offset enter_mesege_print 
	call MOR_SCREEN 
	
	call input_with_sound ;input with sound
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

	;printing the message
	mov cx,  offset secret_msg
	call putMessage
	
	;puting the key msg
	;puting key msg in right place 
	mov dh, 20           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the message *****************************************************
	mov cx,  offset press_key
	call putMessage
	
	
	call input_with_sound ;input with sound
	
	;sowing the key
	;open image
	mov ax, offset key_pic
	call MOR_SCREEN 
	
	;show the key******************************************************
	;puting the key msg
	;puting key msg in right place 
	mov dh, 17           ;Cursor position line
	mov dl, 1         ;Cursor position column

	;printing the key message *****************************************************
	mov ax, 0000 ;zeroing ax
	mov al, [key] ;al = key
	call MOR_PRINT_NUM
	
	call input_with_sound ;input with sound
	
	call sound_by_time ;playimg music
	
	popa;pop main registors
	ret ;returning to main program
endp main_xor_program ;end prociduration


;==============================================
;   getKey  – gets key num from screen 
;   IN:[chip_pic] - תמונה לבקשת מפתח 
;   OUT:  [key] - המפתח להצפנה
;	AFFECTED REGISTERS AND VARIABLES: [key] הנמפתח להצפנה
; ==============================================
proc getKey
	PUSHA ;saving registors
	
	mov [key], 0
	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
getting_key_loop: 	
	; wait for any key
	mov ah,1
	int 21h
	
	;cheking if enter
	cmp al, 0dh
	je end_key_loop ;ending key loop
	
	
	mov cl, al ;bl = al
	
	;mulplying bl by 10
	mov ax, 0000h ;ax = 0000
	mov al, [key]
	mov bl, 10 ;cl = 10
	mul bl ; ax = ax * 10
	

	;adding to cl the digit
	sub cl, 30h
	add al, cl
	
	mov [key], al ;key = cl
	
	jmp getting_key_loop ;jumpit get key loop 
	
end_key_loop :	

	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
	
	popa ;getting back all registors
	ret ;back to main program
endp getKey ;end prociduration

;DO 	: gets text from screen 
;IN  	: [note] - התו שצריך לנגן התדר שלו[time_play] -  זמן צריך לנגן את התו בשניות
;OUT 	: al - המספר שקילנו מהמסך , ah = 1
;EFFECTED REGISTERS :axge
proc input_with_sound
	
	
	;calling sound
	call sound_by_time
	;reding key
	mov ah,1
	int 21h
	ret ;returning to main program
endp input_with_sound ;end prociduration


;DO 	: gets text from screen and saves it in arrey untiil enter
;IN  	: [note] - התו שצריך לנגן התדר שלו[time_play] -  זמן צריך לנגן את התו בשניות, [chip_pic] - התמונה לקבלת מחרוזת מהמסך
;OUT 	: [MEESEGE] המחרוזת בה נשמר הטקטס שהתקבל
;EFFECTED REGISTERS : NONE but the varible [message] is chnge
proc get_text_from_screen_arr
	PUSHA ;save the registors
	
	
	;moving to  cx 149
	mov cx, 149
	
	;bl is counter
	mov bx, 0 ; bl = 0
start_read_key :
	call input_with_sound ;input with sound
	
	;cheking if enter
	cmp al, 0dh
	je endText ;end looop
	


default_text :
	;put letter in arrey
	mov [message + bx], al
	inc bx ;increasing bx
	
	;open image
	mov ax, offset chip_pic
	call MOR_SCREEN 
	
	;puting msg
	mov dh, 1           ;Cursor position line
	mov dl, 1         ;Cursor position column
	
	;saving cx in ax
	mov ax, cx
	
	;printing the message
	mov cx,  offset message
	call putMessage
	
	;geting baack cx
	mov cx, ax

end_arr_loop:
	;jumping to start
	loop start_read_key
	
	
endText:
	popa ;getting back all registors
	ret ;back to main program
endp get_text_from_screen_arr


;DO 	: gets meege and returne chiped meesege
;IN  	: [message] מחרוזת בה טקסט רגיל לפניי הצפנה, [key] המפתח להצפנה
;OUT 	: [secret_msg] המחרוזת בה ישמר הטקסט המוצפן, [char] תוו לקליטת תוו במערך
;EFFECTED REG AND VARIABLES NONE but vatibale : [char]תוו לקליטת תוו במערך, [secret_msg] המחרוזת בה ישמר הטקסט המוצפן
proc xor_arr_chip
	PUSHA ;save the registors
	
	;*************geting the key****************
	
	
	;***loping the 2 arreys ech letter from the first arrey to the second arrey
	mov bx, 0 ; bx = 0
;start loop
arr_mov_loop :

	;cheking if message[bx]!= $
	cmp [message + bx], '$'
	je end_arr_mov_loop ;if eqal jump to end_arr_mov_loop
	
	;geting the char
	mov al, [message + bx] ;al = message[bx]
	mov [char], al ;char = al
	call xorCipherChar ;calling func now he char is chiped in xor
	
	;puting char in his place in [secret_msg]
	mov al, [char] ; al = [char]
	mov [secret_msg + bx], al ;[secret_msg + bx] = al
	
	;end loop
	inc bx ; bx += 1 , incresing bx
	jmp arr_mov_loop ;jumping arr_mov_loop
	
end_arr_mov_loop :
	POPA ;returning th main rgistors
	ret ;returning to main 
endp xor_arr_chip ;end prociduration

;DO 	: xorCipherChar -gets num in [char] and [key] returns the chip 
;IN  	: [char] - תו להצפנה, [key] - מפתח להצפנה
;OUT 	: [char] - תו להצפנה
;EFFECTED REG AND VARIABLES NONE but vatibale : [char]

	proc xorCipherChar
		;pusha ;saving all registors
		PUSHA;save registors
		
		mov al, [key] ; al = [key]
		
		;doing xor between num and key
		mov ah,  [char] ;[ah] = char
		xor ah, al  ;xor ah and al
		

		
		mov [char], ah ;[char] = ah
end_xor:
		popa ;getting back all registors
		ret ;back to main program
endp xorCipherChar
	
;DO 	: resets [meesege] and [secret_msg]
;IN  	: [meesege] ההודעה ללא הצפנה  [secret_msg] הודעה לאחר הצפנה
;OUT 	:  [meesege] ההודעה ללא הצפנה  [secret_msg] הודעה לאחר הצפנה
;EFFECTED REGISTERS : NONE
proc recetVaribels
	PUSHA ;save registors
	;resting mesge
	mov bx, 0 ;bx = 0
reset_loop:
	mov [message + bx], '$' ;reset mesege in bx to $
	mov [secret_msg + bx], '$';reset secret_msg in bx to $
	inc bx ;bx++
	cmp bx, 150 ;comparing bx to 150
	jb reset_loop ;if bx < 150 jumpto reset loop
	popa ;getting back all registors
	ret ;back to main program
endp recetVaribels
	
;THIS PROC TAKES key FROM OUR ASSMBLY BOOK - https://data.cyber.org.il/assembly/assembly_book.pdf and was edited by  Tom Mejibovski 
;DO 	: makes sound for some second
;IN  	: [note] - התו לפי חישובי תדרים אותו אנחנו רוצים לנגם [time_play] - הזמן אותו נרצה לנגנן
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

;DO 	: gets mesage and retured xor meesege in secret_msg
;IN  	: [mesage] הודעה מקורית, [key] מפתח להצפנה
;OUT 	: [secret_msg] הודעה מוצפנת
;EFFECTED REGISTERS : NONE ecapt this varibale [secret_msg] הודעה מוצפנת
proc MesageToSecretXor
	pusha;save main registors
	
	mov cx, 149 ;cx = 149 , the num of loops
	mov bx, 0 ;bx is actualy counter
	
secret_loop:
	mov al, [message + bx] ;al = mesage[bx]
	
	cmp al, '$' ;seing if need to xor
	je exit_secret_loop ;if eqaul jump to exit_secret_loop
	
	mov [char], al ;char = al
	call xorCipherChar ;doing xor
	
	mov al, [char] ; al = char
	mov[secret_msg + bx], al ;secret_msg = al

	inc bx ;bx++
	loop secret_loop ;looping here
	
exit_secret_loop:
	popa;pop main registors
	ret ;returning to main program
endp MesageToSecretXor ;end prociduration
	

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


;==============================================
; putMessage - print message on screen
; IN: DH= row number , DL = column number , cx = the message (offset)
; OUT: NONE
; AFFECTED REGISTERS AND VARIABLES: NONE

proc MOR_SCREEN
; DO : take a BMP and put it on screen ( starting from location 0,0)
; IN : ax filename
; OUT : None
; effected registers : None
