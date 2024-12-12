;*********************************************************************
;*   WLERROR.ASM                                                     *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          12/15/95                                         *
;*   Model:         Small                                            *
;*   Version:       1.3d                                             *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 3.0+                                      *
;*                                                                   *
;*   error handling routines                                         *
;*                                                                   *
;*********************************************************************

TITLE   WL32 WLERROR
PAGE    50,80

.MODEL  SMALL
.386C					; using 386-level code in this module
DGROUP	GROUP CONST,_BSS,_DATA

;*****************************
;* Equates                   *
;*****************************

TEXTSTRINGPRINT	EQU	1
WORDVALUEPRINT	EQU	2
ANYTEXTPRINT	EQU	0ffh
FILENAMESTRING	EQU	80h

;*****************************
;* Include files             *
;*****************************

INCLUDE WLEQUATE.INC
INCLUDE WLDATA.INC
INCLUDE	WLERRCOD.INC

;*****************************
;* Public declarations       *
;*****************************

; routines
PUBLIC	BadOBJModuleExit
PUBLIC	DOSErrorExit
PUBLIC	InternalErrorExit
PUBLIC	LinkerErrorExit
PUBLIC	MultipleDefSymWarn
PUBLIC	NormalizeErrorExit
PUBLIC	UnknownOptionWarn
PUBLIC	UnresExternalWarn

; variables
PUBLIC	NumberBuffer

;*****************************
;* Data begins               *
;*****************************

;*****************************
;* Uninitialized data        *
;*****************************

_BSS	SEGMENT WORD PUBLIC USE16 'BSS'

NumberBuffer	DB	12 DUP (?)	; number to display storage buffer
ErrorWordValue	DW	?	; error routine word value to display

_BSS ENDS

;*****************************
;* Constant data             *
;*****************************

CONST	SEGMENT WORD PUBLIC USE16 'DATA'

ERRDEF struct
bFlgs	db ?
wOfs	dw ?
ERRDEF ends

;	DW	NUMERRORS
ErrorTable	label byte
	DB	INTERNALERRORCODE
	DB	DOSVERSIONERRORCODE
	DB	RSPLINELENERRORCODE
	DB	BADOPTIONERRORCODE
	DB	RSPNESTLEVELERRORCODE
	DB	MEMALLOCFAILERRORCODE
	DB	MEMSIZEFAILERRORCODE
	DB	NOOBJFILEERRORCODE
	DB	BADOBJRECERRORCODE
	DB	UNSUPOBJRECERRORCODE
	DB	MEMRELEASEFAILERRORCODE
	DB	BADOBJRECLENERRORCODE
	DB	POORFORMOBJERRORCODE
	DB	SEGLEN64KERRORCODE
	DB	BADLIBERRORCODE
	DB	SEG32BITEXEERRORCODE
	DB	CONFIGLINELENERRORCODE
	DB	BADCONFIGLINEERRORCODE
	DB	BADSYMBOLTOKENERRORCODE
NUMERRORS equ ( $ - ErrorTable )

; MUST be in sync with ErrorTable
; first byte is flag byte, second word is pointer to text to print
; set bit 0 (TEXTSTRINGPRINT) then dx -> additional string to print
; set bit 7 (FILENAMESTRING) the file name to print

ErrorInfo label ERRDEF
	ERRDEF <WORDVALUEPRINT, OFFSET InternalText>
	ERRDEF <0             , OFFSET DOSVersionText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,	OFFSET RSPLineLenText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,	OFFSET BadOptionText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,	OFFSET RSPNestLevelText>
	ERRDEF <0,  								OFFSET AllocFailText>
	ERRDEF <0,  								OFFSET SizeFailText>
	ERRDEF <0,  								OFFSET NoOBJFileText>
	ERRDEF <TEXTSTRINGPRINT OR WORDVALUEPRINT OR FILENAMESTRING,OFFSET BadOBJRecText>
	ERRDEF <TEXTSTRINGPRINT OR WORDVALUEPRINT OR FILENAMESTRING,OFFSET UnsupOBJRecText>
	ERRDEF <0,  												OFFSET ReleaseFailText>
	ERRDEF <TEXTSTRINGPRINT OR WORDVALUEPRINT OR FILENAMESTRING,OFFSET BadOBJLenText>
	ERRDEF <TEXTSTRINGPRINT OR WORDVALUEPRINT OR FILENAMESTRING,OFFSET PoorFormOBJText>
	ERRDEF <TEXTSTRINGPRINT,									OFFSET SegLen64KText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,  				OFFSET BadLIBText>
	ERRDEF <TEXTSTRINGPRINT,									OFFSET Seg32BitEXEText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,  				OFFSET ConfigLineLenText>
	ERRDEF <TEXTSTRINGPRINT OR FILENAMESTRING,  				OFFSET BadConfigLineText>
	ERRDEF <TEXTSTRINGPRINT OR WORDVALUEPRINT OR FILENAMESTRING,OFFSET BadSymbolTokenText>

DOSErrorTable label byte
	DB	2				; file not found
	DB	3				; path not found
	DB	4				; too many open files, no handles left
	DB	5				; access denied
	DB	8				; insufficient memory
NUMDOSERROR equ $ - DosErrorTable

; MUST be in sync with DOSErrorTable

DOSErrorInfo label ERRDEF
	ERRDEF <FILENAMESTRING, OFFSET FileNotFoundText>
	ERRDEF <FILENAMESTRING, OFFSET PathNotFoundText>
	ERRDEF <FILENAMESTRING, OFFSET NoHandlesText>
	ERRDEF <FILENAMESTRING, OFFSET AccessDeniedText>
	ERRDEF <0,				OFFSET OutOfMemoryText>

	DB	sizeof InternalText
InternalText	DB	'Internal linker error occurred during linking process'

	DB	sizeof DOSVersionText
DOSVersionText	DB	'MS-DOS or PC-DOS version must be 3.0 or above.'

	DB	sizeof RSPLineLenText
RSPLineLenText	DB	'Response file line length exceeds 253 characters in '

	DB	sizeof BadOptionText
BadOptionText	DB	'Invalid option: '

	DB	sizeof RSPNestLevelText
RSPNestLevelText	DB	'Response files nested more than 10 levels deep in '

	DB	AllocFailStop-AllocFailText
AllocFailText	DB	'Allocate memory attempt failed.'
SpaceText		DB	'  '	; cheap way to reference text of two spaces
				DB	'Probably out of virtual memory.'
AllocFailStop	=	$

	DB	sizeof SizeFailText
SizeFailText	DB	'Resize memory attempt failed.  Probably out of virtual memory.'

	DB	sizeof NoOBJFileText
NoOBJFileText	DB	'At least one object module file must be specified when linking.'

	DB	sizeof BadOBJRecText
BadOBJRecText	DB	'Bad object record type in '

	DB	sizeof PoorFormOBJText
PoorFormOBJText	DB	'Poorly formed object record in '

	DB	sizeof SegLen64KText
SegLen64KText	DB	'Segment size exceeds 64K: '

	DB	sizeof BadLIBText
BadLIBText	DB	'Bad or invalid library (.LIB) file format in '

	DB	sizeof Seg32BitEXEText
Seg32BitEXEText	DB	'32-bit segment in DOS EXE file: '

	DB	sizeof NoStartAddressText
NoStartAddressText	DB	'No start address defined'

	DB	sizeof Entry32bitText
Entry32bitText	DB	'Program entry in 32-bit segment'

	DB	sizeof ConfigLineLenText
ConfigLineLenText	DB	'Configuration file line length exceeds 125 characters in '

	DB	sizeof BadConfigLineText
BadConfigLineText	DB	'Invalid configuration file line: '

	DB	sizeof BadSymbolTokenText
BadSymbolTokenText	DB	'Bad Clipper symbol token in '

; end specific error code feedback messages

	DB	sizeof UnsupOBJRecText
UnsupOBJRecText	DB	'Unsupported object record type in '

	DB	sizeof ReleaseFailText
ReleaseFailText	DB	'Release memory attempt failed.'

	DB	sizeof BadOBJLenText
BadOBJLenText	DB	'Object record length too large in '

	DB	sizeof UnknownText
UnknownText		DB	'Unknown error occurred during linking process.'

	DB	sizeof FatalLinkerText
FatalLinkerText	DB	'FATAL error encountered using ',LINKERNAME,'.',CR,LF,'Link terminated.  No executable file created.'

	DB	sizeof ValueText
ValueText		DB	', value '

	DB	sizeof DOSErrorText
DOSErrorText	DB	'DOS error'

	DB	sizeof FileNotFoundText
FileNotFoundText	DB	'File not found'

	DB	sizeof PathNotFoundText
PathNotFoundText	DB	'Path not found'

	DB	sizeof NoHandlesText
NoHandlesText	DB	'Too many open files, no handles left'

	DB	sizeof AccessDeniedText
AccessDeniedText	DB	'Access denied'

	DB	sizeof OutOfMemoryText
OutOfMemoryText	DB	'Out of memory'

	DB	sizeof WhichFileText
WhichFileText		DB	', File: '

LeftParenText	DB	'('
RightParenText	DB	')',0	; must have terminating zero for final print

	DB	sizeof SymDefText
SymDefText		DB	'Symbol defined more than once: '

	DB	sizeof DefinedInText
DefinedInText	DB	13,10,'Defined in '

	DB	sizeof DuplicatedInText
DuplicatedInText	DB	', duplicated in '

	DB	sizeof UnresText
UnresText		DB	'Unresolved externally declared symbol: '

	DB	sizeof DeclaredInText
DeclaredInText	DB	13,10,'Declared in '

	DB	sizeof UnknownOptionText
UnknownOptionText		DB	'Unknown linker option or command, ignored: '

CRLFText	db CR,LF

CONST ENDS

;*****************************
;* Initialized data          *
;*****************************

_DATA	SEGMENT WORD PUBLIC USE16 'DATA'

;*****************************
;* External data             *
;*****************************

EXTRN	CompBuffSource:BYTE
EXTRN	CurrentFileName:BYTE
EXTRN	FirstLIBModCount:DWORD
EXTRN	LIBDictTablePtr:WORD
EXTRN	ModuleCount:DWORD
EXTRN	OBJBuffSelTablePtr:WORD
EXTRN	UnresSymPtr:DWORD

_DATA ENDS

;*****************************
;* Code begins               *
;*****************************

_TEXT	SEGMENT WORD PUBLIC USE16 'CODE'

ASSUME	ds:DGROUP

;*****************************
;* External code routines    *
;*****************************

EXTRN	ByteToHexString:PROC
EXTRN	DisplayTextStringCRLF:PROC
EXTRN	DisplayTextStringNoCRLF:PROC
EXTRN	DisplayVarStringCRLF:PROC
EXTRN	DisplayVarStringNoCRLF:PROC
EXTRN	DisplayShortString:PROC
EXTRN	NormalGSBXSource:PROC
EXTRN	TerminateToDOS:PROC

;*****************************
;* Code routines             *
;*****************************

;*****************************
;* LINKERERROREXIT           *
;*****************************

; fatal linker error
; upon entry al holds the error code, dx -> file name, if any
; destroy registers at will

LinkerErrorExit	PROC
	push	ss
	pop	ds				; ds -> wl32 data
	call	LinkerErrorFeedback
;@@@	call	CleanupForExit	; clean up any interim system changes made
	call	TerminateToDOS	; no return

LinkerErrorExit	ENDP

DisplayCRLF	PROC
	push	dx			; save critical registers
	push	cx
	mov dx,OFFSET CRLFText
	mov cx,2
	call DisplayShortString
	pop	cx				; restore critical registers
	pop	dx
	ret
DisplayCRLF	ENDP

;*****************************
;* LINKERERRORFEEDBACK       *
;*****************************

; display linker error
; upon entry al holds the error code, dx -> text string, if any
;  cx holds error value
; save ax,ds destroy other registers at will

LinkerErrorFeedback	PROC
	push	ax			; save error code
	call	DisplayCRLF
	pop	ax
	push	ax			; restore ax

	push	ds
	pop	es				; es -> wl32 data
	mov	ErrorWordValue,cx	; save associated error value, if any
	mov	di,OFFSET ErrorTable	; es:di -> lookup table for errors
	mov	cx,NUMERRORS	; number of entries in table
	repne	scasb
	je	founderr		; found the error entry

; error entry not found, unknown error code
	mov	bx,OFFSET UnknownText

ledisp:
	call	DisplayTextStringCRLF

; display fatal error message, exit
lefatal:
	mov	bx,OFFSET FatalLinkerText
	call	DisplayTextStringCRLF
	pop	ax				; restore error code
	ret

; found error entry in ErrorTable, process it for feedback
; di -> entry just past match
founderr:
	dec	di				; di -> matching entry
	sub	di,OFFSET ErrorTable	; di == error code offset
	imul di, sizeof ERRDEF   
	add	di,OFFSET ErrorInfo	; di -> entry in ErrorInfo table
	mov	si,dx			; si -> additional string to print, if any
	mov	bx,[di].ERRDEF.wOfs	; bx -> initial string to print
	test	[di].ERRDEF.bFlgs,ANYTEXTPRINT
	je	ledisp			; no additional text to print, print only and continue

; additional text strings, don't print with CR/LF
	call	DisplayTextStringNoCRLF
	test	[di].ERRDEF.bFlgs,TEXTSTRINGPRINT
	je	le2				; no text string
	mov	bx,si			; bx -> second string to print
	test	[di].ERRDEF.bFlgs,WORDVALUEPRINT
	jne	leno1			; value string, no crlf after text
	call	DisplayVarStringCRLF	; display variable length text string
	jmp	SHORT le2

leno1:
	call	DisplayVarStringNoCRLF	; display variable length text string

le2:
	test	[di].ERRDEF.bFlgs,WORDVALUEPRINT
	je	le3				; no word value string to print

; print word value in hex, value in cx
	mov	bx,OFFSET ValueText
	call	DisplayTextStringNoCRLF	; print 'value' string
	push	di			; save -> error flags
	mov	bx,OFFSET NumberBuffer	; bx -> string to print
	mov	di,bx			; di -> number storage
	mov	al,BYTE PTR ErrorWordValue+1
	call	ByteToHexString	; convert byte in al to hex
	mov	al,BYTE PTR ErrorWordValue
	call	ByteToHexString	; convert byte in al to hex
	mov	ax,'h'			; put hex 'h' identifier and null terminator on number
	stosw
	call	DisplayVarStringCRLF	; display variable length text string
	pop	di				; restore di -> error flags

le3:

;@@@ code goes here

	jmp	SHORT lefatal	; display fatal error message, exit

LinkerErrorFeedback	ENDP

;*****************************
;* DOSERROREXIT              *
;*****************************

; fatal DOS error
; upon entry al holds the error code, dx -> file name, if any
; destroy registers at will

DOSErrorExit	PROC
	push	ss
	pop	ds				; ensure that ds -> data
	call	DOSErrorFeedback
;@@@	call	CleanupForExit	; clean up any interim system changes made
	call	TerminateToDOS	; no return

DOSErrorExit	ENDP

;*****************************
;* DOSERRORFEEDBACK          *
;*****************************

; display linker error
; upon entry al holds the error code, dx -> file name, if any
; save ax
; destroys bx,cx,dx,si,di

DOSErrorFeedback	PROC
	push	ax			; save error code
	push	ds
	pop	es				; es -> wl32 data

	mov	si,dx			; si -> file name to print, if any

; write string terminating CR/LF
	call	DisplayCRLF

	mov	bx,OFFSET DOSErrorText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET ValueText
	call	DisplayTextStringNoCRLF	; print 'value' string

	pop	ax				; ax == error code (al only)
	push	ax			; restore to stack
	mov	di,OFFSET NumberBuffer	; di -> number storage
	mov	bx,di			; bx -> string to print
	call	ByteToHexString	; convert byte in al to hex
	mov	ax,'h'			; put hex 'h' identifier and null terminator on number
	stosw

; check for extra explanatory information
	pop	ax				; ax == error code (al only)
	push	ax			; restore to stack
	mov	di,OFFSET DOSErrorTable
	mov cx,NUMDOSERROR
defloop:
	cmp	al,[di]		; see if entry in table
	je	deffound		; yes
	add	di,sizeof ERRDEF + 1	; move to next entry
	loop	defloop
	call	DisplayVarStringCRLF	; display error value
	jmp	deffatal

; extra info to display with DOS error
deffound:
	call	DisplayVarStringNoCRLF	; display error value

	sub di, OFFSET DOSErrorTable
	imul di, sizeof ERRDEF
	add di, OFFSET DOSErrorInfo
    
; see if file name to print
	test	[di].ERRDEF.bFlgs,FILENAMESTRING
	je	defmess			; no file name to print
	mov	bx,OFFSET WhichFileText
	call	DisplayTextStringNoCRLF	; display file text
	mov	bx,si
	call	DisplayVarStringNoCRLF	; display file name
	mov	dx,OFFSET SpaceText
	mov	cl,2
	call	DisplayShortString

; display explanatory message in parentheses following filename or value
defmess:
	mov	dx,OFFSET LeftParenText
	mov	cl,1
	call	DisplayShortString
	mov	bx,[di].ERRDEF.wOfs	; bx -> explanatory message
	call	DisplayTextStringNoCRLF	; show it
	mov	bx,OFFSET RightParenText
	call	DisplayVarStringCRLF	; display final paren and do cr/lf

deffatal:
	mov	bx,OFFSET FatalLinkerText
	call	DisplayTextStringCRLF

	pop	ax				; restore error code
	ret
DOSErrorFeedback	ENDP

;*****************************
;* BADOBJMODULEEXIT          *
;*****************************

; fatal linker error, poorly formed object module
; upon entry cl holds the error value
; set al to proper error code, dx -> obj file name, zero ch,
;  transfer to LinkerErrorExit
; destroy registers at will

BadOBJModuleExit	PROC
	xor	ch,ch			; zero high word of error value
	mov	al,POORFORMOBJERRORCODE
	mov	dx,OFFSET CurrentFileName
	call	LinkerErrorExit
BadOBJModuleExit	ENDP

;*****************************
;* INTERNALERROREXIT         *
;*****************************

; fatal linker error, internal error
; upon entry cl holds the error value
; set al to proper error code, zero ch,
;  transfer to LinkerErrorExit
; destroy registers at will

InternalErrorExit	PROC
	xor	ch,ch			; zero high word of error value
	mov	al,INTERNALERRORCODE
	call	LinkerErrorExit
InternalErrorExit	ENDP

;*****************************
;* NORMALIZEERROREXIT        *
;*****************************

; normalize text string, do linker error exit
; upon entry al holds error code, gs:bx -> non-normalized text string

NormalizeErrorExit	PROC
	push	ax			; save error code
	call	NormalGSBXSource	; normalize text string in gs:bx to CompBuffSource
	mov	ax,gs
	cmp	ax,DGROUP		; see if segment changed (to DGROUP during normalization)
	je	nee2			; yes

; gs:bx -> original string, move to CompBuffSource
	push	ds
	pop	es
	mov	di,OFFSET CompBuffSource	; es:di -> destination
	mov	cl,gs:[bx]		; get count of bytes to transfer
	xor	ch,ch			; zap high byte
	jcxz	nee2		; null name
	mov	si,bx			; gs:si -> name with length byte prefixed
	inc	si				; si -> name

; transfer all name chars
neeloop:
	lods	BYTE PTR gs:[si]
	stosb
	loop	neeloop
	xor	al,al
	stosb				; null terminate the string

nee2:
	pop	ax				; restore error code
	mov	dx,OFFSET CompBuffSource	; dx -> string to print
	call	LinkerErrorExit	; no return

NormalizeErrorExit	ENDP

;*****************************
;* NORMALIZEWARNSTRING      *
;*****************************

; normalize warning text string
; upon entry gs:bx -> non-normalized text string, es=ds=DGROUP
; destroys ax,bx,cx,si,gs

NormalizeWarnString	PROC
	push	di			; save critical registers

	push	gs			; save original gs pointer
	call	NormalGSBXSource	; normalize text string in gs:bx to CompBuffSource
	mov	ax,gs			; ax == new gs
	pop	cx				; cx == original gs
	cmp	ax,cx			; see if segment changed
	jne	nws2			; yes, move to DGROUP occurred

; gs:bx -> original string, move to CompBuffSource
	mov	di,OFFSET CompBuffSource	; es:di -> destination
	mov	cl,gs:[bx]		; get count of bytes to transfer
	xor	ch,ch			; zap high byte
	jcxz	nws2		; null name
	mov	si,bx			; gs:si -> name with length byte prefixed
	inc	si				; si -> name

; transfer all name chars
nwsloop:
	lods	BYTE PTR gs:[si]
	stosb
	loop	nwsloop
	xor	al,al
	stosb				; null terminate the string

nws2:
	pop	di				; restore critical register
	ret
NormalizeWarnString	ENDP

;*****************************
;* MULTIPLEDEFSYMWARN        *
;*****************************

; symbol defined more than once
; display message "Symbol defined more than once: <symbol name>
; Defined in <file name>, duplicated in <filename>
; upon entry gs:di -> old public symbol info, es=ds=DGROUP
; destroys ax,bx,dx

MultipleDefSymWarn	PROC
	push	cx			; save critical registers
	push	si
	push	di
	push	fs
	push	gs
	xor	al,al
	cmp	IsNoWarnDupeOption,al	; see if warning about duplicates shut off
	jne	mdsret			; yes
	cmp	IsNoWarnLIBDupeOption,al	; see if warning about library duplicates shut off
	je	mss2			; no
	cmp	ProcessingLIBFlag,al
	jne	mdsret			; no warning on lib duplicates and processing LIB

; write string terminating CR/LF
mss2:
	call	DisplayCRLF

	inc	WarningsCount	; bump count of warnings
	mov	bx,OFFSET SymDefText
	call	DisplayTextStringNoCRLF
	push	gs			; save -> public symbol info
	lgs	bx,gs:[di+PubSymRecStruc.pssNamePtr]	; gs:bx -> symbol name
	call	NormalizeWarnString	; make sure name doesn't straddle i/o buffer, put into DGROUP
	mov	bx,OFFSET CompBuffSource
	call	DisplayVarStringNoCRLF	; display symbol name
	pop	gs				; restore gs -> public symbol info

	mov	bx,OFFSET DefinedInText
	call	DisplayTextStringNoCRLF
	mov	eax,gs:[di+PubSymRecStruc.pssModuleCount]
	cmp	eax,FirstLIBModCount	; see if module is in library
	jb	mssobj			; no
	mov	gs,LIBDictTablePtr
	xor	ebx,ebx			; init library count
	push	es			; save critical register

mssloop:
	mov	fs,gs:[2*ebx]		; fs -> library dictionary
	mov	di,fs:[LIBDictHeaderStruc.ldhsModIDPtr]
	or	di,di			; see if any library modules loaded from library yet
	je	mssnextlib		; no
	mov	es,di
	xor	di,di			; es:di -> modules to check
	mov	cx,fs:[LIBDictHeaderStruc.ldhsModUsedCount]	; number of modules to search
	repne	scasd		; search for module
	je	mssfound		; found the module

mssnextlib:
	inc	ebx				; move to next library
	jmp	SHORT mssloop

; di holds offset into module buffer for module lookup (di-4)/2
;  since dword past match and dword search versus word entry on lookup
mssfound:
	sub	di,4
	shr	di,1			; di holds true offset to module
	mov	gs,fs:[LIBDictHeaderStruc.ldhsModBuffPtr]	; gs -> module i/o buffer
	mov	gs,gs:[di]
	pop	es				; restore critical register
	jmp	SHORT mssname

mssobj:
	mov	bx,ax			; bx holds module count (assumed <64K)
	dec	bx				; make relative zero
	add	bx,bx			; word per module
	mov	gs,OBJBuffSelTablePtr
	mov	gs,gs:[bx]		; gs -> base of first symbol defined object module

mssname:
	lgs	si,gs:[IOBuffHeaderStruc.ibhsFileNamePtr]	; gs:si -> file name
	mov	bx,OFFSET CompBuffSource	; string to printer after transfer
	mov	di,bx			; es:di -> string destination

mdsloop:
	lods	BYTE PTR gs:[si]
	stosb
	or	al,al			; see if null terminator transferred yet
	jne	mdsloop			; no
	call	DisplayVarStringNoCRLF

	mov	bx,OFFSET DuplicatedInText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET CurrentFileName
	call	DisplayVarStringCRLF

mdsret:
	pop	gs				; restore critical registers
	pop	fs
	pop	di
	pop	si
	pop	cx
	ret
MultipleDefSymWarn	ENDP

;--- adjustment: 32-bit segments in MZ exe are a warning only

Seg32BitWarning PROC
	pusha
	push bx
	mov bx,offset Seg32BitEXEText
	call DisplayTextStringNoCRLF
	pop bx
	call NormalizeWarnString
	mov bx, offset CompBuffSource
	call DisplayVarStringCRLF
	inc WarningsCount	; bump count of warnings
	popa
	ret
Seg32BitWarning ENDP

;--- adjustment: No start address defined (MZ exe only)

NoStartAddressWarning PROC
	pusha
	mov bx,offset NoStartAddressText
	call DisplayTextStringCRLF
	inc WarningsCount	; bump count of warnings
	popa
	ret
NoStartAddressWarning ENDP

Entry32bitWarn	PROC
	pusha
	mov bx,offset Entry32bitText
	call DisplayTextStringCRLF
	inc WarningsCount	; bump count of warnings
	popa
	ret
Entry32bitWarn	ENDP

;*****************************
;* UNRESEXTERNALWARN         *
;*****************************

; unresolved external used in fixup
; display message "Unresolved externally declared symbol: <symbol name>
; Declared in <file name>
; upon entry UnresSymPtr -> symbol entry
; maintain cx,si,gs

UnresExternalWarn	PROC
	push	cx			; save critical registers
	push	si
	push	gs

	lgs	bx,UnresSymPtr	; gs:bx -> symbol info
	test	gs:[bx+PubSymRecStruc.pssFlags],UNRESFEEDSYMBOLFLAG
	jne	uewret			; feedback already given

; write string terminating CR/LF
	call	DisplayCRLF

	inc	WarningsCount	; bump count of warnings
	mov	bx,OFFSET UnresText
	call	DisplayTextStringNoCRLF

	lgs	bx,UnresSymPtr	; gs:bx -> symbol info
	or		gs:[bx+PubSymRecStruc.pssFlags],UNRESFEEDSYMBOLFLAG	; flag feedback given
	lgs	bx,gs:[bx+PubSymRecStruc.pssNamePtr]	; gs:bx -> symbol name
	call	NormalizeWarnString	; make sure name doesn't straddle i/o buffer, put into DGROUP
	mov	bx,OFFSET CompBuffSource
	call	DisplayVarStringNoCRLF	; display symbol name

	mov	bx,OFFSET DeclaredInText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET CurrentFileName
	call	DisplayVarStringCRLF

uewret:
	pop	gs				; restore critical register
	pop	si
	pop	cx
	ret
UnresExternalWarn	ENDP

;*****************************
;* UNKNOWNOPTIONWARN         *
;*****************************

; unknown linker option
; display message "Unknown linker option or command, ignored: <option/command>"
; upon entry dx -> option/command
; maintain si, es

UnknownOptionWarn	PROC
	push	dx

; write string terminating CR/LF
	call	DisplayCRLF
	mov	bx,OFFSET UnknownOptionText
	call	DisplayTextStringNoCRLF
	pop	bx				; bx -> option/command string
	call	DisplayVarStringCRLF
	ret
UnknownOptionWarn	ENDP

_TEXT ENDS

END
