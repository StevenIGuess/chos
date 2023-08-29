; boot.asm

mov ax, 0x07c0
mov ds, ax

mov ah, 0x0
mov al, 0x3
int 0x10

mov si, msg
mov ah, 0x0E

jmp print_char_loop

lp:
	mov ax, 0x07c0
	mov ds, ax
	
	mov ah, 0x0
	mov al, 0x3
	int 0x10

	mov si, loop_msg
	mov ah, 0x0E
	jmp print_char_loop
	jmp lp

print_char_loop:
	lodsb
	
	or al, al
	jz hang
	

	int 0x10
	jmp print_char_loop

msg:
	db 'Welcome to crackhead OS', 13, 10, 0

loop_msg:
	db 'Crackhead', 13, 10, 0

hang:
	jmp hang

	times 510- ($-$$) db 0


	db 0x55
	db 0xAA
