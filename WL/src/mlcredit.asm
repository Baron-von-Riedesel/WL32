;*********************************************************************
;*   MLCREDIT.ASM                                                    *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          05/11/93                                         *
;*   Model:         Small                                            *
;*   Version:       2.5                                              *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 2.x+                                      *
;*                                                                   *
;*   display linker copyright/credit line                            *
;*                                                                   *
;*********************************************************************

TITLE   WARPLINK mlcredit
PAGE    50,80

.MODEL  SMALL

;*****************************
;* Include files             *
;*****************************

INCLUDE    MLEQUATE.INC
INCLUDE    MLDATA.INC
     
;*****************************
;* Public declarations       *
;*****************************

PUBLIC  credits

;*****************************
;* Constant data             *
;*****************************

.CONST

credline    DB  CR,LF
            DB  LINKER,' 2.61 (05/11/93 Alpha) Written 1989-93 by Michael Devore.',CR,LF,'Public Domain.',CR,LF
credlen     EQU $-credline

.CODE

;*****************************
;* Code begins               *
;*****************************

credits     PROC
    mov ah,40h              ; write to file or device
    mov bx,STDOUT           ; write to standard output device
    mov dx,OFFSET DGROUP:credline   ; ds:dx == segment:offset of buffer area
    mov cx,credlen          ; number of bytes to write
    int 21h
    ret
credits     ENDP

END
