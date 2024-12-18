; boot.asm
org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
	jmp main


;Prints a string to screen
; - ds:si points to string
puts:
	;save current regs
	push si
	push ax
.loop:
	lodsb		;loads next character into al
	or al, al	; verify if next char is null
	jz .done	;jump if zero
	
	mov ah, 0x0e	;call bios int
	mov bh, 0	
	int 0x10	

	jmp .loop
.done:
	pop ax
	pop si
	ret


main:
	
	; setup data segments
	mov ax, 0
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00 	

	;print welcome msg
	mov si, msg_hello
	call puts

	hlt

.halt:
	jmp .halt

msg_hello: db 'Welcome to Crackhead OS!', ENDL, 0 


times 510- ($-$$) db 0
dw 0AA55h
