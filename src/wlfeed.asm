;*********************************************************************
;*   WLFEED.ASM                                                      *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          12/02/96                                         *
;*   Model:         Small                                            *
;*   Version:       1.31                                             *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 3.0+                                      *
;*                                                                   *
;*   linker feedback routines                                        *
;*                                                                   *
;*********************************************************************

TITLE   WL32 WLFEED
PAGE    50,80

.MODEL  SMALL
.386C					; using 386-level code in this module
DGROUP	GROUP CONST,_BSS,_DATA

;*****************************
;* Equates                   *
;*****************************


;*****************************
;* Include files             *
;*****************************

INCLUDE WLEQUATE.INC
INCLUDE WLDATA.INC

;*****************************
;* Public declarations       *
;*****************************

PUBLIC	DisplayCredits
PUBLIC	DisplayFinalFeedback
PUBLIC	DisplayLinkInfo
PUBLIC	DisplayModuleName
PUBLIC	DisplayParseResults
PUBLIC	DisplayProcFileFeedback
PUBLIC	DisplayReadFileFeedback
PUBLIC	DisplaySummary
PUBLIC	DisplaySegmentName
PUBLIC	DisplayShortString
PUBLIC	DisplayTextStringCRLF
PUBLIC	DisplayTextStringNoCRLF
PUBLIC	DisplayVarStringCRLF
PUBLIC	DisplayVarStringNoCRLF

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

CreditTextLen	DB	CreditTextStop-CreditText
CreditText		DB	'WL32 Linker'
IFDEF CLIPPER
				DB	' for Clipper'
IFNDEF NATHAN
				DB	' Version 1.33'
ELSE
				DB	' Version 1.33n
ENDIF
ENDIF
IFDEF CLARION
				DB	' for Clarion 2.1'
				DB	' Version 1.33'
ENDIF
IFDEF WATCOM_ASM
				DB	' Version 1.33'
ENDIF
				DB	' - Public Domain.'
CreditTextStop	=	$

	DB	sizeof SuccessText
SuccessText		DB	'Link of executable file successfully completed.'

Summary1TextLen	DW	Summary1TextStop-Summary1Text
Summary1Text	DB	' Usage: WL32 [options] objs[,exefile][,mapfile][,libs]',CR,LF
				DB	' Options:'
CRLFText		DB	CR,LF	; double duty as printable CR/LF
				DB	CR,LF
				DB	' /32         no warning on 32-bit segments (option /ex)', CR,LF
				DB	' /3p         Create protected mode 3P-format executable without DOS extender',CR,LF
SpaceSlash		DB	' /b          Beep the speaker at linker completion',CR,LF
IFDEF WATCOM_ASM
				DB	' /cs         perform Case Sensitive symbols link',CR,LF
				DB	' /ds         set DS to SS at startup',CR,LF
ENDIF
				DB	' /ex         create DOS MZ EXE-format file',CR,LF
IFDEF WATCOM_ASM
				DB	' /f          create protected-mode CauseWay executable, CWSTUB.EXE added (def.)',CR,LF
ENDIF
				DB	' /fl         use Fast Load EXE file DOS extender feature',CR,LF
IFDEF CLIPPER
				DB	' /fx         use alternate FiXup logic (req. for CA Clipper Tools)',CR,LF
ENDIF
				DB	' /i          display link process Information',CR,LF
				DB	' /il         display link process Information, Limit information displayed',CR,LF
				DB	' /lc:<name>  Link options Configuration file name',CR,LF
IFNDEF CLARION
				DB	' /ls         use alternate Library Search logic',CR,LF
ENDIF
				DB	' /m          create MAP file',CR,LF
				DB	' /nd         do Not use Default library names in object modules',CR,LF
				DB	' /non        do Not add 16 NUL bytes to _TEXT if dosseg segorder active',CR,LF
				DB	' /nwd        do Not Warn on Duplicate symbols',CR,LF
				DB	' /nwld       do Not Warn on Library only Duplicate symbols',CR,LF
				DB	' /q          no logo display',CR,LF
				DB	' /qq         no logo and - if no warnings occured - no success display',CR,LF
;@@@				DB	' /s          Symbol names are case sensitive when linking',CR,LF
;@@@				DB	' /sp         Symbol table Pack of Clipper-compiled routines',CR,LF
				DB	' /st:<size>  set program STack size in bytes',CR,LF
				DB	' /sy         create SYM file for CWD debugger',CR,LF
;@@@				DB	' /ud:<setting>  User Defined link option setting',CR,LF
				DB	' /w1         Warnings generate exit code of 1, not zero',CR,LF
;@@@				DB	' /wn         Warnings are Not displayed by linker',CR,LF
				DB	' /wu         issue Warning on Unknown linker options or commands',CR,LF
IFDEF WATCOM_ASM
				DB	' /zu         Zero fill Uninitialized segments',CR,LF
ENDIF
Summary1TextStop	=	$

	DB	sizeof EXEText
EXEText	DB	'EXE file name: '

	DB	sizeof MAPText
MAPText	DB	'MAP file name: '

	DB	sizeof OBJText
OBJText	DB	'Object module file names: '

	DB	sizeof LIBText
LIBText	DB	'Library file names: '

	DB	sizeof OptionText
OptionText	DB	'Link Option Settings:',CR,LF

	DB	sizeof ReadFileText
ReadFileText	DB	CR,LF,'*** Reading file: '

	DB	sizeof ReadModText
ReadModText	DB	CR,LF,'*** Reading library module: '

	DB	sizeof ProcessFileText
ProcessFileText	DB	CR,LF,'*** Processing file: '

	DB	sizeof WriteSegText
WriteSegText	DB	CR,LF,'*** Writing segment: '

	DB	sizeof WarnCountText
WarnCountText	DB	'Total number of warnings: '

CONST ENDS

;*****************************
;* Initialized data          *
;*****************************

_DATA	SEGMENT WORD PUBLIC USE16 'DATA'

;*****************************
;* External data             *
;*****************************

EXTRN	CurrentFileName:BYTE
EXTRN	InText:BYTE
EXTRN	NumberBuffer:BYTE
EXTRN	OBJNameSelector:WORD,LIBNameSelector:WORD
EXTRN	OptionList:WORD
EXTRN	ProcessModText:BYTE
EXTRN	WorkingBuffer:BYTE

_DATA ENDS

;*****************************
;* Code begins               *
;*****************************

_TEXT	SEGMENT WORD PUBLIC USE16 'CODE'

ASSUME	ds:DGROUP

;*****************************
;* External code routines    *
;*****************************

EXTRN	NormalGSBXSource:PROC
EXTRN	DwordToDecimalString:PROC

;*****************************
;* Code routines             *
;*****************************

;*****************************
;* DISPLAYCREDITS            *
;*****************************

; display linker credit/copyright line

DisplayCredits	PROC
	mov	bx,OFFSET CreditText
	call	DisplayTextStringCRLF
dcret:
	ret
DisplayCredits	ENDP

;*****************************
;* DISPLAYSUMMARY            *
;*****************************

; display linker command summary

DisplaySummary	PROC

	call DisplayCredits
; display built in link options
	mov	bx,OFFSET Summary1Text
	call	DisplayLongStringCRLF
	ret
DisplaySummary	ENDP

;*****************************
;* DISPLAYSHORTSTRING        *
;*****************************

; display a string of <256 characters to stdout
; upon entry cl==string length, dx -> string
; destroys ax

DisplayShortString	PROC
	push edx
	movzx edx, dx		; adjustment: clear hiword(edx)
	xor	ch,ch			; zap high byte of length word
	push ecx
	movzx ecx, cx
	mov	bx,STDOUT
	mov	ah,40h
	int	21h
	pop ecx
	pop edx
	ret
DisplayShortString	ENDP

;*****************************
;* DISPLAYTEXTSTRINGNOCRLF   *
;*****************************

; display text string with no CR/LF at end
; upon entry ds:bx -> string text, immediately preceded by one-byte length of string,
; destroys ax,bx,cx,dx
; returns bx == stdout, ch==0 for additional printing

DisplayTextStringNoCRLF	PROC
	mov	cl,[bx-1]		; get length of string to print
	mov	dx,bx			; ds:dx -> string to print
	call	DisplayShortString
	ret
DisplayTextStringNoCRLF	ENDP

;*****************************
;* DISPLAYTEXTSTRINGCRLF     *
;*****************************

; display text string with CR/LF at end, plus blank line CR/LF
; upon entry bx -> string text, immediately preceded by one-byte length of string,
;  ds -> DGROUP
; destroys ax,bx,cx,dx

DisplayTextStringCRLF	PROC
	call	DisplayTextStringNoCRLF

; write string terminating CR/LF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

; write blank line CR/LF
;	call	DisplayShortString
	ret
DisplayTextStringCRLF	ENDP

;*****************************
;* DISPLAYVARSTRINGNOCRLF    *
;*****************************

; display variable text string with no CR/LF at end
; upon entry ds:bx -> string text
; returns bx == stdout, ch==0 for additional printing

DisplayVarStringNoCRLF	PROC
	mov	dx,bx			; dx -> string

dvsloop:
	cmp	BYTE PTR [bx],0	; see if at null terminator
	je	foundnull		; yes
	inc	bx				; move to next char to print
	jmp	SHORT dvsloop

foundnull:
	push edx
	movzx edx, dx		; adjustment: clear hiword(edx)
	mov	cx,bx			; get offset in string to null terminator
	sub	cx,dx			; cx holds number of bytes to print
	push ecx
	movzx ecx, cx
	mov	bx,STDOUT		; write to standard output device
	mov	ah,40h			; write to device
	int	21h
	pop ecx
	pop edx
	ret
DisplayVarStringNoCRLF	ENDP

;*****************************
;* DISPLAYVARSTRINGCRLF      *
;*****************************

; display variable text string with CR/LF at end, plus blank line CR/LF
; upon entry bx -> string text
;  ds -> DGROUP
; destroys ax,bx,cx,dx

DisplayVarStringCRLF	PROC
	call	DisplayVarStringNoCRLF

; write string terminating CR/LF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

; write blank line CR/LF
;	call	DisplayShortString
	ret
DisplayVarStringCRLF	ENDP

;*****************************
;* DISPLAYLONGSTRINGCRLF     *
;*****************************

; display long text string with CR/LF at end, plus blank line CR/LF
; upon entry bx -> string text, immediately preceded by two-byte length of string,
;  ds -> DGROUP
; destroys ax,bx,cx,dx

DisplayLongStringCRLF	PROC
	push edx
	xor edx, edx		; adjustment: clear hiword(edx)
	mov	cx,[bx-2]		; get length of string to print
	movzx ecx, cx
	mov	dx,bx			; ds:dx -> string to print
	mov	bx,STDOUT		; write to standard output device
	mov	ah,40h			; write to device
	int	21h

; write string terminating CR/LF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

; write blank line CR/LF
	call	DisplayShortString
	pop edx
	ret
DisplayLongStringCRLF	ENDP

;*****************************
;* DISPLAYFINALFEEDBACK      *
;*****************************

; display final linker feedback (# of warnings, etc.)

DisplayFinalFeedback	PROC
	cmp	WarningsCount,0	; see if any warnings
	je	dff2			; no
	mov	bx,OFFSET WarnCountText
	call	DisplayTextStringNoCRLF
	mov	di,OFFSET NumberBuffer
	movzx	eax, WarningsCount
	call	DwordtoDecimalString
	mov	bx,OFFSET NumberBuffer ;  ds:bx -> string to write
	call	DisplayVarStringCRLF
    jmp dff1
dff2:
	cmp	IsQuietOption,0	; logo & link success display shut off
	jne	dffret
dff1:
	mov	bx,OFFSET SuccessText
	call	DisplayTextStringCRLF
dffret:
	ret
DisplayFinalFeedback	ENDP

;*****************************
;* DISPLAYPARSERESULTS       *
;*****************************

; display results of linker parsing
; destroys ax,bx,cx,dx,si,di

DisplayParseResults	PROC

; display link option settings
	mov	bx,OFFSET OptionText
	call	DisplayTextStringNoCRLF

	mov	si,OFFSET OptionList
	mov	bx,STDOUT

optloop:
	cmp	[si].OPTITEM.wOptText,-1	; see if at end of options
	je	endopt			; yes
	mov	di,[si].OPTITEM.wOptVal	; get pointer to option flag byte
	cmp	BYTE PTR [di],0	; see if option is set
	je	nextopt			; no

	mov	dx,OFFSET SpaceSlash	; precede option with space and slash
	mov	cl,2
	call	DisplayShortString

	mov	di,[si]		; di -> option text string with length byte prefix
	mov	cl,[di]		; cl holds length byte
	mov	dx,di
	inc	dx				; dx -> option text
	call	DisplayShortString

	test [si].OPTITEM.wArgFlgs,OPTFLG_STRINGPARAM	; see if string parameter
	je	chkword			; no, check if word parameter
	mov	bx,[si].OPTITEM.wArgPtr	; bx -> string
	call	DisplayVarStringNoCRLF

chkword:
	test [si].OPTITEM.wArgFlgs,OPTFLG_DWORDPARAM	; see if dword parameter
	je	doterm			; no

; show the dword parameter value
	mov	di,[si].OPTITEM.wArgPtr	; di -> dword value
	mov	eax,[di]
	mov	di,OFFSET NumberBuffer
	call	DwordToDecimalString	; convert dword value to string
	mov	bx,OFFSET NumberBuffer
	call	DisplayVarStringNoCRLF	; show string-ized word value

; write string terminating CR/LF
doterm:
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

nextopt:
	add	si,sizeof OPTITEM			; move to next option entry
	jmp	SHORT optloop

endopt:
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

; display EXE name
exedisp:
	mov	bx,OFFSET EXEText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET EXEFileName
	call	DisplayVarStringCRLF

; display MAP name
	cmp	IsMAPOption,OFF	; see if MAP file
	je	dispobj			; no
	mov	bx,OFFSET MAPText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET MAPFileName
	call	DisplayVarStringCRLF

; display object module names
dispobj:
	mov	bx,OFFSET OBJText
	call	DisplayTextStringNoCRLF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString
	mov	cx,TotalOBJCount
	jcxz	displib		; no object modules

	xor	si,si

omodloop:
	push	cx			; save object module count left to print
	mov	di,OFFSET WorkingBuffer
	mov	ds,OBJNameSelector

; ds:si -> object name in storage
; es:di -> destination for name for printing
ocharloop:
	movsb
	cmp	BYTE PTR [si-1],0	; see if null terminator transferred
	jne	ocharloop		; no
	push	ss
	pop	ds				; restore ds -> wl32 data
	mov	bx,OFFSET WorkingBuffer	; bx -> string to print
	call	DisplayVarStringNoCRLF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString
	pop	cx				; get object modules left to print
	loop	omodloop

	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

; display library file names
displib:
	mov	bx,OFFSET LIBText
	call	DisplayTextStringNoCRLF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString
	mov	cx,TotalLIBCount
	jcxz	dpret		; no library files

	xor	si,si

lmodloop:
	push	cx			; save object module count left to print
	mov	di,OFFSET WorkingBuffer
	mov	ds,LIBNameSelector

; ds:si -> object name in storage
; es:di -> destination for name for printing
lcharloop:
	movsb
	cmp	BYTE PTR [si-1],0	; see if null terminator transferred
	jne	lcharloop		; no
	push	ss
	pop	ds				; restore ds -> wl32 data
	mov	bx,OFFSET WorkingBuffer	; bx -> string to print
	call	DisplayVarStringNoCRLF
	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString
	pop	cx				; get object modules left to print
	loop	lmodloop

	mov	dx,OFFSET CRLFText
	mov	cl,2
	call	DisplayShortString

dpret:
	ret
DisplayParseResults	ENDP

;*****************************
;* DISPLAYREADFILEFEEDBACK   *
;*****************************

; display reading file message for /i option, if set
; destroys ax,bx,dx

DisplayReadFileFeedback	PROC
	cmp	IsLinkInfoLimitOption,OFF	; see if displaying limited link information
	jne	drf2			; yes
	cmp	IsLinkInfoOption,OFF	; see if displaying link information
	je	drfret			; no

drf2:
	push	cx			; save critical register
	mov	bx,OFFSET ReadFileText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET CurrentFileName
	call	DisplayVarStringNoCRLF
	pop	cx				; restore critical register

drfret:
	ret
DisplayReadFileFeedback	ENDP

;*****************************
;* DISPLAYPROCFILEFEEDBACK   *
;*****************************

; display processing file message for /i option, if set
; destroys ax,bx,cx,dx

DisplayProcFileFeedback	PROC
	cmp	IsLinkInfoLimitOption,OFF	; see if displaying limited link information
	jne	dpfret			; yes, don't show this
	cmp	IsLinkInfoOption,OFF	; see if displaying link information
	je	dpfret			; no
	mov	bx,OFFSET ProcessFileText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET CurrentFileName
	call	DisplayVarStringNoCRLF

dpfret:
	ret
DisplayProcFileFeedback	ENDP

;*****************************
;* DISPLAYLINKINFO           *
;*****************************

; display information message for /i option, if set
; upon entry bx -> message
; destroys bx

DisplayLinkInfo	PROC
	cmp	IsLinkInfoLimitOption,OFF	; see if displaying limited link information
	jne	dli2			; yes, show this
	cmp	IsLinkInfoOption,OFF	; see if displaying link information
	je	dliret			; no

dli2:
	push	ax
	push	cx
	push	dx
	call	DisplayTextStringNoCRLF
	pop	dx
	pop	cx
	pop	ax

dliret:
	ret
DisplayLinkInfo	ENDP

;*****************************
;* DISPLAYMODULENAME         *
;*****************************

; display information message for /i option, if set
; upon entry fs -> i/o buffer base
; destroys ax,bx,cx,dx,gs

DisplayModuleName	PROC
	cmp	IsLinkInfoLimitOption,OFF	; see if displaying limited link information
	jne	dmnret			; yes, don't show this
	cmp	IsLinkInfoOption,OFF	; see if displaying link information
	je	dmnret			; no

	mov	bx,OFFSET ReadModText
	cmp	Pass2Flag,OFF	; see if on pass 2+
	je	dmn2			; no
	mov	bx,OFFSET ProcessModText

dmn2:
	call	DisplayTextStringNoCRLF
	lgs	bx,fs:[IOBuffHeaderStruc.ibhsModNamePtr]	; gs:bx -> module name
	call	NormalGSBXSource	; make sure name is normalized
	push	ds			; save ds -> wl32 data
	push	gs
	pop	ds				; ds:bx -> string to print with length byte prepended
	inc	bx				; point bx past length byte
	call	DisplayTextStringNoCRLF
	pop	ds				; restore ds -> wl32 data
	mov	bx,OFFSET InText
	call	DisplayTextStringNoCRLF
	mov	bx,OFFSET CurrentFileName
	call	DisplayVarStringNoCRLF

dmnret:
	ret
DisplayModuleName	ENDP

;*****************************
;* DISPLAYSEGMENTNAME        *
;*****************************

; display information message for /i option, if set
; upon entry gs:bx -> master segdef entry
; destroys ax,cx,dx

DisplaySegmentName	PROC
	cmp	IsLinkInfoLimitOption,OFF	; see if displaying limited link information
	jne	dsnret			; yes, don't show this
	cmp	IsLinkInfoOption,OFF	; see if displaying link information
	je	dsnret			; no
	push	gs			; save critical registers
	push	bx
	mov	bx,OFFSET WriteSegText
	call	DisplayTextStringNoCRLF
	pop	bx				; restore bx, save back to stack
	push	bx
	lgs	bx,gs:[bx+MasterSegDefRecStruc.mssNamePtr]	; gs:bx -> segment name
	call	NormalGSBXSource	; make sure name is normalized
	push	ds			; save ds -> wl32 data
	push	gs
	pop	ds				; ds:bx -> string to print with length byte prepended
	inc	bx				; point bx past length byte
	call	DisplayTextStringNoCRLF
	pop	ds				; restore ds -> wl32 data
	pop	bx				; restore critical registers
	pop	gs

dsnret:
	ret
DisplaySegmentName	ENDP

_TEXT ENDS

END
