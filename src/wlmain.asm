;*********************************************************************
;*   WLMAIN.ASM                                                      *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          06/10/96                                         *
;*   Model:         Small                                            *
;*   Version:       1.3g                                             *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 4.0+                                      *
;*                                                                   *
;*   main driver for linker                                          *
;*                                                                   *
;*********************************************************************

TITLE	WL32 WLMAIN
PAGE    ,132
DOSSEG

.MODEL  SMALL
.386C					; using 386-level code in this module
DGROUP	GROUP CONST,_BSS,_DATA,STACK

STACK	SEGMENT PARA STACK USE16 'STACK'
	DB	0c00h DUP (?)
STACK ENDS

;*****************************
;* Include files             *
;*****************************

INCLUDE WLEQUATE.INC
INCLUDE	WLDATA.INC

;*****************************
;* Public declarations       *
;*****************************

;*****************************
;* Data begins               *
;*****************************

;*****************************
;* Uninitialized data        *
;*****************************

_BSS	SEGMENT WORD PUBLIC USE16 'BSS'

_BSS ENDS

;*****************************
;* Constant data             *
;*****************************

CONST	SEGMENT WORD PUBLIC USE16 'DATA'

ResolvingSegTextLen	DB	ResolvingSegTextStop-ResolvingSegText
ResolvingSegText	DB	CR,LF,'*** Resolving segment addresses'
ResolvingSegTextStop		=	$

ApplyingOBJTextLen	DB	ApplyingOBJTextStop-ApplyingOBJText
ApplyingOBJText	DB	CR,LF,'*** Applying object module fixups'
ApplyingOBJTextStop		=	$

ApplyingLIBTextLen	DB	ApplyingLIBTextStop-ApplyingLIBText
ApplyingLIBText	DB	CR,LF,'*** Applying library module fixups'
ApplyingLIBTextStop		=	$

CONST ENDS

;*****************************
;* Initialized data          *
;*****************************

_DATA	SEGMENT WORD PUBLIC USE16 'DATA'

; globals
IsArgsFlag	DB	0
	align 2
WarningsCount	DW	0
Pass2Flag	DB	0		; nonzero if on pass 2+ of link

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

EXTRN	CleanupForExit:PROC
EXTRN	CreateProgramFile:PROC
DisplayCredits PROTO
EXTRN	DisplayFinalFeedback:PROC
EXTRN	DisplayLinkInfo:PROC
EXTRN	DisplayParseResults:PROC
EXTRN	DisplaySummary:PROC
EXTRN	OBJPass1:PROC,LIBPass1:PROC,Pass1Resolution:PROC
EXTRN	OBJPass2:PROC,LIBPass2:PROC,Pass2Resolution:PROC
EXTRN	ParseCommandLine:PROC
Setup PROTO
PatchSegRelocs PROTO
EXTRN	TerminateToDOS:PROC

;*****************************
;* Code routines             *
;*****************************

	include initpm.inc

start:
	mov ax, DGROUP	; setup small model: DS=SS=DGROUP
	mov ds, ax
	mov dx, ss
	sub dx, ax
	shl dx, 4
	mov ss, ax
	add sp, dx

	mov bx, sp		; free rest of DOS memory; DPMI needs some of it
	shr bx, 4
	mov cx, es
	sub ax, cx
	add bx, ax
	mov ah, 4Ah
	int 21h
	call InitPM		; enter PM - won't return on errors
	call PatchSegRelocs; patch all DGROUP segrefs with selector

if 1				; clear _BSS segment
externdef _edata:abs
externdef _end:abs
	push es
	mov di, offset _edata
	mov cx, offset _end
	sub cx, di
	xor ax, ax
	push ds
	pop es
	rep stosb
	pop es
endif

;*****************************
;* MAIN                      *
;*****************************

main		PROC

	call	Setup		; get system variables and values, trap control C
	cmp	IsArgsFlag,FALSE	; check for arguments to linker
	jne	m2				; at least one argument
	call	DisplaySummary	; display summary of linker syntax/commands
	jmp	SHORT ExitLinker	;  and exit program

m2:
	call	ParseCommandLine	; parse linker command line
	cmp	IsNoLogoOption,OFF
	jne m2a
	call	DisplayCredits	; display linker credit line
m2a:
	cmp	IsParseDisplayOption,OFF	; see if parse display flag set
	je	m3				; no
	call	DisplayParseResults	; display results of parse
	je	ExitLinker

m3:
	call	OBJPass1	; do first pass on object modules
	call	LIBPass1	; do first pass on libraries

	mov	bx,OFFSET ResolvingSegText
	call	DisplayLinkInfo	
	call	Pass1Resolution	; do first pass resolution processing

	mov	bx,OFFSET ApplyingOBJText
	call	DisplayLinkInfo	
	mov	Pass2Flag,ON	; flag doing second pass
	call	OBJPass2	; do second pass on object modules

	mov	bx,OFFSET ApplyingLIBText
	call	DisplayLinkInfo	
	call	LIBPass2	; do second pass on libraries

	call	Pass2Resolution	; do second pass resolution processing
	call	CreateProgramFile	; create the program
	call	DisplayFinalFeedback	; give feedback on warnings, other final info

ExitLinker:
	call	CleanupForExit	; clean up any interim system changes made
	xor	ax,ax			; init return code to zero (ah will be changed)
	cmp	IsWarnRetCode1Option,al	; see if warnings set return code to 1
	je	DoTerminate		; no
	cmp	WarningsCount,ax	; see if any warnings
	je	DoTerminate		; no
	inc	ax				; give return code (errorlevel) 1

DoTerminate:

;	mov	ax,0			; @@@ temporary, force GPF
;	mov	gs,ax
;	mov WORD PTR gs:[1234h],1234h

	call	TerminateToDOS	; no return

main		ENDP

_TEXT ENDS

END	start
