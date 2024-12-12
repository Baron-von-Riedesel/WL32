;*********************************************************************
;*   WLDATA.INC                                                      *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          06/18/96                                         *
;*   Model:         Small                                            *
;*   Version:       1.3h                                             *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 3.0+                                      *
;*                                                                   *
;*   Global data declarations                                        *
;*                                                                   *
;*********************************************************************

; link options
EXTERNDEF	IsCreateEXEOption:BYTE	; /ex
EXTERNDEF	IsExitBeepOption:BYTE	; /b
EXTERNDEF	IsFastLoadOption:BYTE	; /fl
EXTERNDEF	IsLIBSearchOption:BYTE	; /ls
EXTERNDEF	IsLinkConfigOption:BYTE	; /lc
EXTERNDEF	IsLinkInfoLimitOption:BYTE	; /il
EXTERNDEF	IsLinkInfoOption:BYTE	; /i
EXTERNDEF	IsMAPOption:BYTE		; /m
EXTERNDEF	IsNoDefaultLIBOption:BYTE	; /nd
EXTERNDEF	IsNoNullDossegOption:BYTE	; /non
EXTERNDEF	IsNoWarnDupeOption:BYTE	; /nwd
EXTERNDEF	IsNoWarnLIBDupeOption:BYTE	; /nwld
EXTERNDEF	IsParseDisplayOption:BYTE	; /pd
EXTERNDEF	IsNoLogoOption:BYTE		; /q
EXTERNDEF	IsQuietOption:BYTE		; /qq
EXTERNDEF	IsSeg32Option:BYTE		; /32
EXTERNDEF	IsStackOption:BYTE		; /st
EXTERNDEF	IsSYMOption:BYTE		; /sy
EXTERNDEF	IsThreePOption:BYTE		; /3p
EXTERNDEF	IsWarnRetCode1Option:BYTE	; /w1
EXTERNDEF	IsWarnUnknownOption:BYTE; /wu

IFDEF WATCOM_ASM
EXTERNDEF	IsCaseSensitiveOption:BYTE	; /cs
EXTERNDEF	IsDStoSSOption:BYTE	; /ds
EXTERNDEF	IsFlatOption:BYTE	; /f
EXTERNDEF	IsZeroUninitOption:BYTE	; /zu
ENDIF

;EXTERNDEF	EXEFileName [85]:BYTE
;EXTERNDEF	MAPFileName [85]:BYTE
;EXTERNDEF	SYMFileName [85]:BYTE
EXTERNDEF	EXEFileName :BYTE
EXTERNDEF	MAPFileName :BYTE
EXTERNDEF	SYMFileName :BYTE

IFDEF DLLSUPPORT
;EXTERNDEF	DLLFileName	[13]:BYTE
EXTERNDEF	DLLFileName	:BYTE
ENDIF

EXTERNDEF	DosVersion:BYTE	; dos version
EXTERNDEF	IsArgsFlag:BYTE	; nonzero if command line arguments
EXTERNDEF	IsDOSSEG:BYTE	; nonzero if DOSSEG segment ordering specified
EXTERNDEF	Pass2Flag:BYTE	; nonzero if on pass 2+ of link
EXTERNDEF	ProcessingLIBFlag:BYTE	; nonzero if processing library

EXTERNDEF	IOBlockSeg:WORD	; segment of 64K sized i/o block
EXTERNDEF	PSP:WORD		; WL32 PSP value
EXTERNDEF	TotalLIBCount:WORD	; total library file count
EXTERNDEF	TotalOBJCount:WORD	; total object module count
EXTERNDEF	WarningsCount:WORD	; count of linker warning messages
EXTERNDEF	ZeroBlockSeg:WORD	; segment of 16K block of zero values

EXTERNDEF	PublicSymbolCount:DWORD	; count of public symbols in program
EXTERNDEF	ResolvedSymbolCount:DWORD	; count of resolved symbols in program
EXTERNDEF	StackValue:DWORD	; user set stack value
EXTERNDEF	TotalCommunalCount:DWORD	; count of communals in program
EXTERNDEF	ZeroValue:DWORD	; known zero value, for pointers to null strings
EXTERNDEF	IsEntryPoint:BYTE

IFDEF DLLSUPPORT
EXTERNDEF	TotalEXPDEFCount:DWORD	; total count of EXPDEFs
EXTERNDEF	TotalIMPDEFCount:DWORD	; total count of IMPDEFs
ENDIF

;--- wlmemory.asm
AllocateMemory PROTO
AllocateBigMemory PROTO
ResizeMemory   PROTO
ResizeMemory32 PROTO
ReleaseMemory  PROTO
