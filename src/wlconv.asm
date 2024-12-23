;*********************************************************************
;*   WLCONV.ASM                                                      *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          03/16/96                                         *
;*   Model:         Small                                            *
;*   Version:       1.3f                                             *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 3.0+                                      *
;*                                                                   *
;*   linker text and number conversion routines                      *
;*                                                                   *
;*********************************************************************

TITLE   WL32 WLCONV
PAGE    50,80

.MODEL  SMALL
.386C					; using 386-level code in this module
DGROUP	GROUP CONST,_BSS,_DATA

;*****************************
;* Include files             *
;*****************************

INCLUDE WLEQUATE.INC
INCLUDE WLDATA.INC

;*****************************
;* Public declarations       *
;*****************************

; routines
PUBLIC	ByteToHexString
PUBLIC	DwordToDecimalString

; variables
PUBLIC	TempBuffer

;*****************************
;* Data begins               *
;*****************************

;*****************************
;* Uninitialized data        *
;*****************************

_BSS	SEGMENT WORD PUBLIC USE16 'BSS'

TempBuffer	DB	128 DUP (?)	; temporary storage buffer

_BSS ENDS

;*****************************
;* Constant data             *
;*****************************

CONST	SEGMENT WORD PUBLIC USE16 'DATA'

CONST ENDS

;*****************************
;* Initialized data          *
;*****************************

_DATA	SEGMENT WORD PUBLIC USE16 'DATA'

_DATA ENDS

;*****************************
;* External data             *
;*****************************

;*****************************
;* Code begins               *
;*****************************

_TEXT	SEGMENT WORD PUBLIC USE16 'CODE'

ASSUME	ds:DGROUP

;*****************************
;* External code routines    *
;*****************************

;*****************************
;* Code routines             *
;*****************************

;*****************************
;* BYTETOHEXSTRING           *
;*****************************

; byte to hex string conversion
; upon entry al==value, di -> storage for number
; updates di -> first char after last digit (not null terminated)
; destroys ax

ByteToHexString	PROC
	mov	ah,al			; save original value
	shr	al,4			; make 4 high bits relative zero
	call	hexcall		; tricky stuff, call then drop through to get both nybbles of byte
	mov	al,ah			; al holds low word of value
	and	al,0fh			; mask off high bits

hexcall:
	cmp	al,0ah			; see if A-F hex
	jb	hex2			; no
	add	al,7			; alpha adjust

hex2:
	add	al,30h			; convert to ASCII
	stosb				; save to storage
	ret
ByteToHexString	ENDP

;*****************************
;* DWORDTODECIMALSTRING      *
;*****************************

; dword to decimal string conversion
; upon entry eax==value, di -> storage for number
; updates di -> null terminator after last digit
; destroys eax,bx,cx,edx

DwordToDecimalString	PROC
	mov cx, sp
	mov	ebx,0ah			; number divisor, constant
divloop:
	xor	edx,edx			; zero high word value
	div	ebx				; divide by 10
	or	dl,'0'			; change remainder to ASCII
	push	dx
	test	eax,eax		; stop dividing when zero
	jne	divloop

revloop:
	pop ax
	mov [di],al
	inc di
	cmp cx,sp
	jnz revloop		; unrevers all chars in buffer
	mov	BYTE PTR [di],0	; null terminate string
	ret
DwordToDecimalString	ENDP

_TEXT ENDS

END
