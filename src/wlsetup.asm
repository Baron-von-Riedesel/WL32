;*********************************************************************
;*   WLSETUP.ASM                                                     *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          12/12/93                                         *
;*   Model:         Small                                            *
;*   Version:       1.0                                              *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 3.0+                                      *
;*                                                                   *
;*   initial linker setup                                            *
;*                                                                   *
;*********************************************************************

TITLE   WL32 WLSETUP
PAGE    50,80

.MODEL  SMALL
.386C					; using 386-level code in this module
DGROUP	GROUP CONST,_BSS,_DATA

;*****************************
;* Include files             *
;*****************************

INCLUDE WLEQUATE.INC
INCLUDE	WLERRCOD.INC
INCLUDE WLDATA.INC
;INCLUDE	CW.INC

;*****************************
;* Public declarations       *
;*****************************

PUBLIC	Setup

;*****************************
;* Data begins               *
;*****************************

;*****************************
;* Uninitialized data        *
;*****************************

_BSS	SEGMENT WORD PUBLIC USE16 'BSS'

; globals
DosVersion	DB	?
	align 2
PSP		DW	?

; locals
OldCtrlCHandlerAddr	DD	?	; old Control-C handler address

_BSS ENDS

;*****************************
;* Constant data             *
;*****************************

CONST	SEGMENT WORD PUBLIC USE16 'DATA'

	DB	sizeof TermText
TermText	DB	CR,LF,'Link terminated by user.'

CONST ENDS

;*****************************
;* Initialized data          *
;*****************************

_DATA	SEGMENT WORD PUBLIC USE16 'DATA'

_DATA ENDS

;*****************************
;* External data             *
;*****************************

;EXTRN	CommandLineString [128]:BYTE
EXTRN	CommandLineString :BYTE

;*****************************
;* Code begins               *
;*****************************

_TEXT	SEGMENT WORD PUBLIC USE16 'CODE'

ASSUME	ds:DGROUP

;*****************************
;* External code routines    *
;*****************************

EXTRN	LinkerErrorExit:PROC
EXTRN	DisplayTextStringCRLF:PROC

;*****************************
;* Code routines             *
;*****************************

;*****************************
;* SETUP                     *
;*****************************

; initial linker setup
; destroys ax,cx,dx

Setup	PROC
	mov PSP,es			; save PSP value to memory variable

	cld					; make all string operations increment

; save dos version
	mov ah,30h			; get MS-DOS version number
	int 21h
	cmp al,3			; make sure at least 3.x
	jae s2				; yes

	mov	al,DOSVERSIONERRORCODE	; show DOS version error
	call	LinkerErrorExit

s2:
	mov DosVersion,al	; save major DOS version

	push	es			; save es -> PSP
; save linker command line, if any
	push	ds
	push	es
	pop	ds				; ds -> PSP
	pop	es				; es -> DGROUP
	mov	si,81h			; ds:si -> command line preceded by length
	mov	cl,[si-1]	; get count of bytes in command line
	xor	ch,ch			; zero high byte of count
	jcxz	s3			; no arguments on command line

; check for one char as space, in case of i/o redirection of summary
	mov	di,OFFSET CommandLineString	; es:di -> command line storage
	cmp	cl,1
	jne	getarg			; more than one character, not i/o redirection
	cmp	BYTE PTR [si],' '	; see if character is whitespace
	jbe	s3				; yes, no arguments on command line

getarg:
	mov	es:IsArgsFlag,cl	; set command line arguments flag with known nonzero value
	rep	movsb			; transfer command tail
	xor	al,al
	stosb				; null terminate command

s3:
	push ss
	pop ds				; restore DS=DGROUP

	mov ax,3523h		; get old CTRL-C handler address
	int 21h
	mov WORD PTR OldCtrlCHandlerAddr+0,bx
	mov WORD PTR OldCtrlCHandlerAddr+2,es

	push cs
	pop ds
	mov dx,OFFSET ControlBreakHandler	; ds:dx -> control-c handler
	mov ax,2523h		; set CTRL-C handler
	int 21h
	push ss
	pop ds				; restore DS=DGROUP

COMMENT !
; set CauseWay internal memory transfer buffer to 40K
	mov	bx,0a00h		; 0a00h paragraphs to allocate
	movzx	ecx,bx
	shl	cx,4			; convert to bytes in ecx
	sys	GetMemDos
	jc	s4				; error, don't set internal i/o buffer

; ax holds real mode segment, dx holds protected mode selector, ecx == buffer size
	mov	bx,ax			; bx holds real mode segment
	sys	SetDOSTrans		; set new address and buffer size for DOS memory transfers
s4:
END COMMENT !

	pop es				; restore es -> PSP
	ret
Setup	ENDP

;*****************************
;* CONTROLBREAKHANDLER       *
;*****************************

; control break handler
; terminates to DOS, destroy registers at will
; destroys ax,bx,dx,ds

ControlBreakHandler	PROC
	push	DGROUP
	pop	ds				; ds -> wl32 data

	lds dx,OldCtrlCHandlerAddr	; ds:dx -> old cntrl-cl handler
	mov ax,2523h		; set ctrl-c handler
	int 21h

	push	DGROUP
	pop	ds				; ds -> wl32 data

; write terminated feedback
	mov	bx,OFFSET TermText
	call	DisplayTextStringCRLF
	jmp DWORD PTR OldCtrlCHandlerAddr

ControlBreakHandler	ENDP

_TEXT ENDS

END
