
;--- patch all segment relocs with selector in DS - in memory only.
;--- it's supposed that model is small, first segment is _TEXT.

	.286

IMAGE_DOS_HEADER STRUCT
  e_magic			WORD	  ?		;+0
  e_cblp			WORD	  ?		;+2
  e_cp				WORD	  ?		;+4
  e_crlc			WORD	  ?		;+6		number of relocation records
  e_cparhdr 		WORD	  ?		;+8
  e_minalloc		WORD	  ?		;+10
  e_maxalloc		WORD	  ?		;+12
  e_ss				WORD	  ?		;+14
  e_sp				WORD	  ?		;+16
  e_csum			WORD	  ?		;+18
  e_ip				WORD	  ?		;+20
  e_cs				WORD	  ?		;+22
  e_lfarlc			WORD	  ?		;+24	begin relocation records
IMAGE_DOS_HEADER ENDS


_TEXT segment word public 'CODE'

	.386

;--- load the MZ's relocation table and adjust all relocs with DGROUP selector
;--- in: ES=PSP

PatchSegRelocs proc uses es si di

local reloc:dword
local mzhdr:IMAGE_DOS_HEADER

;--- get the path of the binary

	mov es, es:[2Ch]
	xor di, di
	mov al,0
	or cx,-1
@@:
	repnz scasb
	cmp al,es:[di]
	jnz @B
	add di,3
	mov dx,di
	push ds
	push es
	pop ds
	mov ax,3D00h
	int 21h
	pop ds
	jc error_1

;--- load MZ header as needed

	mov bx, ax
	mov cx, sizeof mzhdr
	lea dx, mzhdr
	mov ah,3Fh
	int 21h
	jc error_2

;--- seek start of relocs

	mov dx, mzhdr.e_lfarlc
	xor cx, cx
	mov ax,4200h
	int 21h
	jc error_2

;--- get a CS alias - most (all?) relocs will be in _TEXT

	push bx
	mov ax, 000Ah
	mov bx, cs
	int 31h
	pop bx
	jc error_4
	mov es, ax

;--- now patch all relocs with DGROUP selector

	mov si, mzhdr.e_crlc
nextreloc:
	lea dx, reloc
	mov cx, sizeof reloc
	mov ax, 3F00h
	int 21h
	jc error_3
	mov di, word ptr reloc
	cmp word ptr reloc+2,0	 ; is it in _TEXT or in DGROUP?
	jnz is_data
	mov es:[di], ds
	jmp reloc_done
is_data:
	mov [di], ds
reloc_done:
	dec si
	jnz nextreloc

;--- free CS alias

	push bx
	mov bx, es
	mov ax, 1
	int 31h
	pop bx

error_4: ; dpmi error
error_3: ; read error reloc
error_2: ; read error/seek error
	mov ah, 3Eh
	int 21h
error_1: ; open error
	ret

PatchSegRelocs endp

_TEXT ends

	end

