; base file with few  helping procedures : readUserInput , printString, printNumber ,newline 
; used for https://docs.google.com/document/d/1NZYgHlgLjxvQB54WZpABbhhJqXP_4VN0/edit

IDEAL
MODEL small
STACK 100h
P186 ; !!!
DATASEG

; --------------------------
; Your variables here
; --------------------------
	msg1 db 'Enter first digit (0..9):$'
	msgPrint db 10, 'the zero is : $'



CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	;printing msg1
	mov dx, offset msg1
	call printString
	
	;al = input
	call readUserInput
	
	xor al, al ;restart al
	
	;printing msgPrint
	mov dx, offset msgPrint
	call printString
	
	;printing al
	call printNum
	
	;mov bx 6
	mov bx, 6
	
	;zeronig by xor
	xor bx, bx
	
	;mov bx 6
	mov bx, 6
	
	;zeroing by mov
	mov bx, 0000h
		
exit:
	mov ax, 4c00h
	int 21h
	

;DO 	: new line
;IN  	: NONE
;OUT 	: NONE
;EFFECTED REG AND VARIABLES   : NONE
proc newLine
	pusha
	mov dl, 0ah
	mov ah, 2h
	int 21h
	popa
	ret
endp newLine

;DO 	: readUserInput - get input digit to al
;IN  	: NONE
;OUT 	: NONE
;EFFECTED REG AND VARIABLES   : NONE
proc readUserInput
	; get user first input number to al
	mov ah, 1h
	int 21h
	sub al, '0'
	ret
endp readUserInput

;printNum - proc to print the a number stored in al
;IN  	: AL - the number (0..99)
;OUT 	: NONE
;EFFECTED REG AND VARIABLES   : NONE
proc printNum
	pusha
	mov ah, 0
	mov bl,10
	div bl
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	int 21h
	popa
	ret
endp printNum

; printString - print message
;IN  	: DX  - the offset of the message
;OUT 	: NONE
;EFFECTED REG AND VARIABLES   : NONE
proc printString
	pusha
	mov ah, 9h
	int 21h
	popa
	ret
endp printString

	
END start
