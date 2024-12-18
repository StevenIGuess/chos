; boot.asm
org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A


; 
; FAT12 HEADER
;

;jmp short start
;nop

;bdb_oem:			db 'MSWIN4.1' 		;8bytes
;bdb_bytes_per_sector:		dw 512
;bdb_sectors_per_cluster:	db 1
;bdb_reserved_sectors:		dw 1
;bdb_fat_count:			db 2
;bdb_dir_entries_count:		dw 0E0h
;bdb_total_sectors:		dw 2880			; 2880 *512 = 1.44 MB
;bdb_media_descriptor_type:	db 0F0h			; "Floppy"
;bdb_sectors_per_fat:		dw 9
;bdb_sectors_per_track:		dw 18
;bdb_heads:			dw 2
;bdb_hidden_sectors:		dd 0
;bdb_large_sector_count:		dd 0

;extended boot record
;ebr_drive_number:		db 0
;				db 0
;ebr_signature:			db 29h
;ebr_volume_id:			db 42h, 69h, 42h, 69h	; Serial number 42694269
;ebr_volume_label: 		db 'CRCKHEAD OS'	; 11bytes
;ebr_system_id:			db 'FAT12   '		; 8bytes

;
; codes goes here
;

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

cursed_puts:
	push si
	push ax
	mov cl, 0	
.loop:
	lodsb		;loads next character into al
	or al, al	; verify if next char is null
	jz .done	;jump if zero	

	mov ah, 0x0e	;call bios int
	mov bh, 0
	int 0x10	
	
	mov ah, 0x09
	mov bh, cl
	mov bl, cl 
	int 0x10

	mov ah, 0x0b
	mov bh, 0x00
	mov bl, cl
	int 0x10

	inc cl

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

	mov si, s1
	call puts
	
	mov si, s2
	call puts
	
	mov si, s3
	call puts
	
	mov si, s4
	call puts
	
	mov si, s5
	call puts
	
	mov si, s6
	call puts
	mov si, msg_modes
	call puts

.loops:	
	mov ah, 0x00
	int 0x16 
	;mov  bl, al
	mov ah, 0x0e	;call bios int
	mov bh, 0	
	int 0x10	
	
	cmp al, 27
	je a_press

	cmp al, 13
	je b_press
	
	jmp .loops

	cli
	hlt

a_press:
	mov si, msg_ESC
	call cursed_puts
	jmp a_press

b_press:
	jmp 0FFFFh:0



.halt:
	cli
	jmp .halt



msg_hello: 		db 'Welcome to Crackhead OS!', ENDL, 0
s1: db ' _____  _   _ _____ _____ ', ENDL, 0
s2: db '/  __ \| | | |  _  /  ___|', ENDL, 0
s3: db '| /  \/| |_| | | | \ `--. ', ENDL, 0
s4: db '| |    |  _  | | | |`--. \', ENDL, 0
s5: db '| \__/\| | | \ \_/ /\__/ /', ENDL, 0
s6: db ' \____/\_| |_/\___/\____/ ', ENDL, 0
msg_modes: db 'Press ESC to exit, press ENTER for doom', ENDL, 0
msg_ESC: db 'DONT EXIT CHOS!', ENDL, 0 


times 510- ($-$$) db 0
dw 0AA55h
