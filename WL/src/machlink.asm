;*********************************************************************
;*   MACHLINK.ASM                                                    *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          11/06/92                                         *
;*   Model:         Small                                            *
;*   Version:       2.5                                              *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 2.x+                                      *
;*                                                                   *
;*   main driver for linker                                          *
;*                                                                   *
;*********************************************************************

TITLE   WARPLINK machlink
PAGE    50,80

IFNDEF  NODOS
    DOSSEG
ENDIF

.MODEL  SMALL
.STACK  400h

;*****************************
;* Include files             *
;*****************************

INCLUDE MLEQUATE.INC
INCLUDE MLDATA.INC
INCLUDE MLERRMES.INC

;*****************************
;* Public declarations       *
;*****************************

PUBLIC  exit_link

;*****************************
;* Data begins               *
;*****************************

;*****************************
;   Initialized data         *
;*****************************

.DATA

;*****************************
;* External declarations     *
;*****************************

; variables
EXTRN   mod_alloc_base:WORD
EXTRN	writing_qlk_flag:BYTE

; linker defaults, byte values
is_args         DB  0       ; nonzero if arguments passed to linker
is_comfile      DB  0       ; nonzero if .COM file creation indicated
is_mapfile      DB  0       ; nonzero if .MAP file creation indicated
is_mapexpand    DB  0       ; nonzero if expanded .MAP file indicated
is_casesense    DB  0       ; nonzero if symbol names are case sensitive
is_ondisk       DB  0       ; nonzero if program image in temporary disk file
is_inmem        DB  0       ; nonzero if program image is in memory
is_msextlib     DB  0       ; nonzero if use extended ms lib format
is_nodeflib     DB  0       ; nonzero if no default libraries
is_dosseg       DB  0       ; nonzero if DOSSEG segment ordering specified
is_nonuldosseg  DB  0       ; nonzero if option /non is set
is_stackval     DB  0       ; nonzero if stack size set by /st option
wrap_flag       DB  0       ; nonzero if read from file buffer wraps to beginning of buffer
prev_flag       DB  0       ; nonzero if keeping previously read record (pass 2 L?DATA record prior to fixup)
eof_flag        DB  0       ; nonzero if end of file was encountered loading file buffer
is_dgroup       DB  0       ; nonzero if DGROUP group encountered
is_inlib        DB  0       ; nonzero if currently processing LIB file
is_anyovls      DB  0       ; nonzero if any overlaid modules were specified
is_reload       DB  0       ; nonzero if reload active but swapped out overlays
is_maxparval    DB  0       ; maximum paragraph allocation specified
is_nowarn       DB  0       ; nonzero if warnings disabled
is_exit0        DB  0       ; nonzero if warnings generate exit code of 0
is_beep         DB  0       ; nonzero if beep on exit
is_linkinfo     DB  0       ; nonzero if print linker info
is_tempfile     DB  0       ; nonzero if temporary file name specified
is_no_ems       DB  1       ; default is set, nonzero if don't use available EMS during link
is_ems_ovlpool  DB  0       ; nonzero if EMS used for overlay pool
is_internal     DB  0       ; nonzero if internal overlays specified
is_clarion      DB  0       ; clarion overlays specified
is_smartmem     DB  0       ; nonzero if using SMARTMEM.XXX functions
is_clpinc       DB  0       ; nonzero if Clipper incremental link
inc_padval      DB  48      ; pad value to add to segments for incremental link
is_clip5        DB  0       ; zero if Clipper 5 overlays specified
tmp_in_emsxms   DB  0       ; nonzero if temporary file image is in EMS/XMS
tmp_in_xms      DB  0       ; nonzero if temporary file image in XMS only
is_xms          DB  0       ; nonzero if XMS present and available
is_min_pool     DB  0       ; nonzero if minimum pool specified through op:m option
is_ddl          DB  0       ; nonzero if creating DDL
use_ddl         DB  0       ; nonzero if using DDL(s)
any_ddl         DB  0       ; nonzero if creating OR using DDL(s)
is_xtstash      DB  0       ; nonzero if stashing swapped overlays in extended memory (/ort)
is_xpstash      DB  0       ; nonzero if stashing swapped overlays in EMS 4.0 (/orp)
is_quick        DB  0       ; nonzero if QuickLinker option set (/ql)
is_sympac       DB  0       ; nonzero if automatic symbol table compaction for Clipper
is_ohp          DB  0       ; nonzero if ohp option used
is_oht          DB  0       ; nonzero if oht option used
is_umb          DB  0       ; nonzero if UMB overlay option (/ou) used
ems3_flag       DB  0       ; nonzero if explicit EMS 3.0 compatibility specified for /ohp

; linker defaults, word values
EVEN
stack_value     DW  0       ; stack size set by /st option
maxpar_value    DW  0       ; maximum paragraph allocation set by /pa option
warn_count      DW  0       ; count of warning messages
obj_count       DW  0       ; count of object modules
lib_count       DW  0       ; count of libraries
module_count    DW  0       ; count of all modules linked, object and library
seg_count       DW  0       ; count of all discrete (after combined) segments in all object modules
segdef_count    DW  0       ; count of all different segments
current_obj     DW  0       ; current object module
current_lib     DW  0       ; current library
number_reloc    DW  0       ; number of relocation items in .EXE header
communal_count  DW  0       ; count of communal variables
stack_segval    DW  0       ; program's initial stack segment (SS) value
stack_offval    DW  0       ; program's initial stack pointer (SP) value
entry_segval    DW  0       ; program's initial code segment (CS) value
entry_offval    DW  0       ; program's initial instruction pointer (IP) value

; linker defaults, doubleword values
pub_sym_count   DD  0       ; count of all public symbols
tot_sym_count   DD  0       ; count of all symbols
highest_exe_write   DD  0   ; value of highest write for beginning of program

; linker defaults, overlay related values
IFNDEF JUNIOR
ovl_ox_evar DB  32 DUP (0)  ; /ox environment variable setting
ovl_class   DB  'CODE',0,123 DUP (0)    ; overlay class name
exact_ovl_class DB  0       ; nonzero if exact overlay class
EVEN
ovl_pool    DD  147456      ; overlay pool size, user set maximum 512K
ovl_ohp_size	DW	512		; overlay expanded file stash amount in K
ovl_oht_size	DW	0		; overlay extended file stash amount in K
ovl_mem_alloc   DB  0       ; zero if overlay pool is free memory, nonzero if allocated memory
udl_proc_pass   DB  0       ; 0 if not creating a LIB'ed UDL, 1 if first pass, 2 if second
ovl_ohp_alloc	DB	0		; zero if overlay stash amount in expanded is free, nonzero if allocated
ovl_oht_alloc	DB	0		; zero if overlay stash amount in extended is free, nonzero if allocated
EVEN
ovl_max_load    DW  96     	; maximum number of loaded overlays, user set maximum 512
ovl_max_load_size   DW  96*16	; size of array for loaded overlay (ovl_max_load*16)
ovl_stack   DW  2048        ; overlay stack size, user set maximum 63K
ovl_count   DW  0           ; count of overlays
ovl_pubcount    DW  0       ; count of overlaid publics
;ddldat_filename LABEL   BYTE    ; name of DAT file for DDL file to read
;ovl_filename    DB  128 DUP (0) ; name of overlay file, including .OVL extension and path
;ovl_nopath  DB  128 DUP (0) ; name of overlay file WITHOUT prepended path (if any)
first_ovlpubblk_ptr DW  0   ; segment of first overlaid public declarations block
alloc_ovlpubblk_ptr DW  0   ; segment of last allocated overlaid public declarations block
largest_ovl DW  0           ; size of largest overlay
second_ovl  DW  0           ; size of second largest overlay
ovl_code_id DW  0           ; overlay code segment identifier, for writing L?DATA segments
ovl_data_id DW  0           ; overlay data segment identifier, for writing Clarion _DT and _DAT LEDATA segments
ovl_handle  DW  0           ; handle of .OVL overlay file
data_ovlblk_ptr DW  0       ; segment of first data overlay block
ems_handle  DW  0           ; handle of EMS blocks used by WarpLink
ems_currmap DW  4 DUP (-1)  ; current logical page mapping of EMS physical pages
ENDIF

stpass_len      DB  stpass_stop-stpass_text
stpass_text     DB  CR,LF,'*** Start of pass '
stpass_num      DB  '1'
stpass_stop     =   $

endpass_len     DB  endpass_stop-endpass_text
endpass_text    DB  CR,LF,'*** End of pass '
endpass_num     DB  '1'
endpass_stop    =   $
EVEN

; zero initialized segment word pointers to various control blocks

first_objblk_ptr    DW  0   ; segment of first object module name block
last_objblk_ptr     DW  0   ; segment of last object module name block
first_libblk_ptr    DW  0   ; segment of first library block
last_libblk_ptr     DW  0   ; segment of last library block
first_pdeclblk_ptr  DW  0   ; segment of first allocated pubdef declaration block
first_cdeclblk_ptr  DW  0   ; segment of first allocated comdef declaration block
alloc_pdeclblk_ptr  DW  0   ; segment of last allocated pubdef declaration block
alloc_cdeclblk_ptr  DW  0   ; segment of last allocated comdef declaration block
alloc_pdnameblk_ptr DW  0   ; segment of last allocated pubdef names block
alloc_lnamesblk_ptr DW  0   ; segment of last allocated lnames logical names block
first_segdefblk_ptr DW  0   ; segment of first allocated segdef block
alloc_segdefblk_ptr DW  0   ; segment of last allocated segdef block
first_grpblk_ptr    DW  0   ; segment of first allocated group block
alloc_grpblk_ptr    DW  0   ; segment of last allocated group block
first_segpartblk_ptr    DW  0   ; segment of first allocated segment partition block
alloc_segpartblk_ptr    DW  0   ; segment of last allocated segment partition block
first_relblk_ptr    DW  0   ; pointer to first allocated relocation table block
alloc_relblk_ptr    DW  0   ; pointer to last allocated relocation table block
first_libent_ptr    DW  0   ; pointer to first allocated library module entry
alloc_libent_ptr    DW  0   ; pointer to last allocated library module entry
;***first_local_ptr     DW  0   ; pointer to first allocated local declaration
first_fixblk_ptr    DW  0   ; pointer to first allocated fixup block (for DDL)
alloc_fixblk_ptr    DW  0   ; pointer to last allocated fixup block (for DDL)
first_binblk_ptr    DW  0   ; pointer to first allocated binary block (for DDL)
alloc_binblk_ptr    DW  0   ; pointer to last allocated binary block (for DDL)
; used only if DOSSEG switch set
_edata_pubaddr  DW  0       ; address of public declaration entry of _edata
_end_pubaddr    DW  0       ; address of public declaration entry of _end
_edata_segaddr  DW  0       ; address of BSS segment's segdef entry that _edata points to
_end_segaddr    DW  0       ; address of STACK segment's segdef entry that _end points to

;*****************************
;   Uninitialized data       *
;*****************************

.DATA?

; zero init'ed character or byte strings
exe_name    DB  128 DUP (?) ; executable file name, including any path
EVEN
map_name    DB  128 DUP (?) ; map file name, including any path

ddldat_filename LABEL   BYTE    ; name of DAT file for DDL file to read
ovl_filename    DB  128 DUP (?) ; name of overlay file, including .OVL extension and path
ovl_nopath  DB  128 DUP (?) ; name of overlay file WITHOUT prepended path (if any)

EVEN
; word arrays
pubdecl_hash    DW  HASH_ARRAY_SIZE DUP (?) ; hashed pointers to public declaration entries
segdef_hash     DW  HASH_ARRAY_SIZE DUP (?) ; hashed pointers to segdef entries
zero_table  DW  256 DUP (?) ; table of 512-byte page of zeros

; doubleword arrays
lnames_hash     DD  HASH_ARRAY_SIZE DUP (?) ; hashed pointers to lnames logical name entries

;.DATA?

; byte values
EVEN                        ; maximize speed on 8086 and better
ctrlbreak   DB  ?           ; status of Ctrl-Break checking
EVEN
dos_version DB  ?           ; major version number of DOS
EVEN
obj_ovl_flag    DB  ?       ; nonzero if object module is in an overlay

IFNDEF JUNIOR
EVEN
    seg_ovlclass    DB  ?   ; nonzero if at least one segment in module is overlay class
EVEN
    nonovl_rvect    DB  ?   ; nonzero if module is overlaid but overlay->root calls aren't vectored
EVEN
    ovl_ioblk   DW  ?       ; segment of 4K .OVL i/o block
    lookup_tbl_segdef   DW  ?   ; segdef entry of lookup table segment
    ind_tbl_segdef   DW  ?  ; segdef entry of indirect call table segment
    segcall_tbl_segdef  DW  ?   ; segdef entry of segment call segment
    _dt_seg_size    DW  ?   ;  size of current Clarion _DT segment
    _dat_seg_size   DW  ?   ;  size of current Clarion _DAT segment
    _dt_seg_index   DW  ?       ; segment index of clarion _DT segment
    _dat_seg_index  DW  ?       ; segment index of clarion _DAT segment
    ems_base    DW  ?       ; base of EMS page
    ems_pagecount   DW  ?   ; count of WarpLink allocated EMS pages
    ems_page_avail  DW  ?   ; EMS pages available for WarpLink use after i/o buffer
    xms_addr    DD  ?       ; XMS entry point address
ENDIF

EVEN                        ; maximize speed on 8086 and better
; word values
psp DW  ?                   ; machlink's PSP value
image_handle    DW  ?       ; handle of temporary file containing program's memory image
image_mem_ptr   DW  ?       ; segment pointer to program's image in memory
map_handle      DW  ?       ; handle of map file
memory_blk_base DW  ?       ; segment of memory block allocated thru DOS function 48h
memory_blk_size DW  ?       ; size of allocated memory block in paragraphs
memory_blk_end  DW  ?       ; end of memory block (first segment value past end)
allocation_base DW  ?       ; first available segment for block allocations
allocation_top  DW  ?       ; last+1 available segment for block allocations
buffer_base     DW  ?       ; base of buffer for file i/o (segment)
buffer_end      DW  ?       ; end of buffer in memory (offset)
buffer_head     DW  ?       ; address to begin load in buffer (offset)
buffer_tail     DW  ?       ; address to end load in buffer (offset)
buffer_size     DW  ?       ; size of buffer for file i/o in paragraphs
read_buff_ptr   DW  ?       ; file i/o buffer read offset (curr_buff_ptr before update)
prev_read_ptr   DW  ?       ; file i/o buffer read offset for previous object record
prev_rec_len    DW  ?       ; length of previous (L?DATA) record
current_lnames  DW  ?       ; number of current LNAMES record
current_extdef  DW  ?       ; number of current EXTDEF record
current_segdef  DW  ?       ; number of current SEGDEF record
current_grpdef  DW  ?       ; number of current GRPDEF record
eof_pos     DW  ?           ; offset position of end of file in i/o buffer
data_fixup_count    DW  ?   ; count of elements in data_fixup_flag array
master_segblk   DW  ?       ; address of block holding master segdef pointers for overlaid segparts
ovl_filepos_blk DW  ?       ; segment of block holding dword file positions of overlays

; double word values
file_pos_adj    DD  ?       ; file bytes adjustment from wrapped buffer to get true offset of file
prev_pos_adj    DD  ?       ; adjustment value for previous record pointer
lib_pos_adj     DD  ?       ; adjustment for library files, to compute offset from module start
image_size      DD  ?       ; program's executable image size
lib_id          DD  ?       ; library identification number (((current_lib|0x8000)*65536L)+lib_module)

; character or byte strings
EVEN
cmd_line        DB  128 DUP (?) ; command line from PSP
EVEN
prev_libname    LABEL   BYTE    ; name of library holding last processed module, shared with tmod_name
tmod_name       DB  128 DUP (?) ; name from T-module name field of THEADR record
EVEN
ovl_class_name  DB  32 DUP (?)  ; overlay class name

; byte arrays
EVEN
frame_thrd_meth     DB  4 DUP (?)   ; frame fixup thread method
EVEN
target_thrd_meth    DB  4 DUP (?)   ; target fixup thread method

; word arrays
EVEN
seg_partent_indptr  LABEL   WORD    ; seg_partent_indptr and seg_defent_indptr share same memory space
seg_defent_indptr   DW  SEGDEF_MAX DUP (?)  ; indexed segment pointers to segdef entries of last read segdef record
grp_ent_indptr      DW  GRPDEF_MAX DUP (?)  ; indexed segment pointers to grpdef entries of last read grpdef record
IFNDEF JUNIOR
inc_seg_clcode      LABEL   BYTE    ; shared memory space with ext_defent_indptr, used by incremental link
ENDIF
ext_defent_indptr   DW  EXTDEF_MAX DUP (?)  ; indexed segment pointers to pubdef declaration entries of extdefs in object module

IFNDEF JUNIOR
ind_tbl_array       LABEL   WORD    ; share memory space with lookup_tbl_array, used after lookup_tbl_array
lookup_tbl_array    LABEL   WORD    ; share memory space with ovl_reloc_array and ovlpub_array, used between pass 1 and 2
ovl_reloc_array     LABEL   WORD    ; share memory space with ovlpub_array, used in pass 2
ovlpub_array        DW  EXTDEF_MAX+1 DUP (?)    ; index byte of overlaid public declaration entries, use in pass 1
                                                ; bit 15 set if far called, bit 14 if near
ENDIF

env_opt_storage     LABEL   BYTE    ; shared, used prior to pass one
lib_page_storage    LABEL   WORD    ; shared memory space with data_fixup_flag,used in pass 1
ddl_hold_buff       LABEL   WORD    ; used by ddl's to hold pub/com/extdef's prior to file write
data_fixup_flag     DW  1025 DUP (?)    ; positions in data record that flag a segment fixup, used pass 2
frame_thrd_index    DW  4 DUP (?)   ; frame fixup thread index
target_thrd_index   DW  4 DUP (?)   ; target fixup thread index

; doubleword arrays
ddl_symbol_lookup   LABEL   DWORD   ; used by ddl's to translate symbol seg:off to file position
lnames_ent_indptr   DD  LNAMES_MAX DUP (?)  ; indexed segment:offset pointers to lnames entries of last read lnames record

;*****************************
;* Constant data             *
;*****************************

.CONST

beep3   DB  BELL,BELL,BELL

IFNDEF DEMO
ddlpass_len     DB  ddlpass_stop-ddlpass_text
ddlpass_text    DB  CR,LF,'*** Start of main DDL processing pass'
ddlpass_stop    =   $
ENDIF

obj_len         DB  obj_stop-obj_text
obj_text        DB  ' on object modules'
obj_stop        =   $

lib_len         DB  lib_stop-lib_text
lib_text        DB  ' on library modules'
lib_stop        =   $

stwrite_len     DB  stwrite_stop-stwrite_text
stwrite_text    DB  CR,LF,'*** Begin writing file(s)'
stwrite_stop    =   $

endwrite_len    DB  endwrite_stop-endwrite_text
endwrite_text   DB  CR,LF,'*** End writing file(s)'
endwrite_stop   =   $

;*****************************
;* Code begins               *
;*****************************

.CODE

;*****************************
;* External declarations     *
;*****************************

EXTRN   setup:NEAR,getargs:NEAR,credits:NEAR,summary:NEAR
EXTRN   get_memory:NEAR,free_memory:NEAR,parse:NEAR
EXTRN   pass1:NEAR,proc1_libs:NEAR
EXTRN   init_map:NEAR,setup_exe_image:NEAR,finish_map:NEAR
EXTRN   pass2:NEAR,proc2_libs:NEAR,write_program:NEAR,cleanup:NEAR
EXTRN   give_warn_count:NEAR,give_load_size:NEAR

EXTRN   resolve_communals:NEAR
;*** EXTRN   show_unreferenced:NEAR
EXTRN   ovl_entry_point:NEAR,do_incremental:NEAR
EXTRN   ilf_rewind:NEAR,ilf_write_eof:NEAR,check_ems:NEAR
EXTRN   alloc_ems_trans:NEAR,check_xms:NEAR
EXTRN	check_qlk:NEAR,write_qlk_unres:NEAR

IFNDEF DEMO
EXTRN   reinit_variables:NEAR
EXTRN	ddl_save_libmod_entry:NEAR,proc_ddl:NEAR,create_ddl:NEAR
ENDIF

;*****************************
;* MAIN                      *
;*****************************

start:
	mov ax, DGROUP	; setup small model: DS=SS=DGROUP
	mov ds, ax
	mov dx, ss
	sub dx, ax
	mov cl, 4
	shl dx, cl
	mov ss, ax
	add sp, dx

	mov bx, sp		; free rest of DOS memory
	shr bx, cl
	mov cx, es
	sub ax, cx
	add bx, ax
	mov ah, 4Ah
	int 21h

;--- clear _BSS segment
externdef _edata:abs
externdef _end:abs
	push es
	mov di, offset _edata
	mov cx, offset _end
	sub cx, di
	xor ax, ax
	push ds
	pop es
	cld
	rep stosb
	pop es

main        PROC
    call    setup           ; system changes, segment register setup, etc.
    call    getargs         ; get command line arguments from PSP
    call    credits         ; display linker credit line
    or  is_args,0           ; check for arguments to linker
    jne m2                  ; at least one argument
    call    summary         ; display summary of linker syntax/commands

to_exit_1:
    jmp NEAR PTR exit_1     ;   and exit program
m2:
    call    get_memory      ; allocate memory for file buffers and control blocks

    mov ax,allocation_base
    mov mod_alloc_base,ax   ; save base of allocations prior to any allocations

    call    parse           ; parse linker command line
    call    free_memory     ; de-allocate memory prior to new memory allocation

    call    check_ems       ; see if useable EMS
    call    check_xms       ; see if useable XMS
    cmp is_clpinc,0         ; see if clipper incremental link flag set
    je  m3                  ; no
    call    do_incremental  ; do incremental link or setup if no ILF flag
    cmp al,'N'              ; check if should exit link (success or can't incremental link)
	je	to_exit_1			; yes

; incremental link failed, continuing with full link
; reparse options in case of library module
	mov	ax,mod_alloc_base
	mov	allocation_base,ax	; reset memory allocation base
    call    get_memory		; allocate memory for file buffers and control blocks
    call    parse			; parse linker command line
    call    free_memory		; de-allocate memory prior to new memory allocation
    call    check_ems       ; see if useable EMS
    call    check_xms       ; see if useable XMS

m3:
    call    get_memory      ; allocate memory for file buffers and control blocks

    call    alloc_ems_trans ; allocate EMS transfer buffer if necessary

IFNDEF DEMO
    mov al,is_ddl
    or  al,use_ddl          ; see if creating or using DDL
    mov any_ddl,al          ; save any DDL usage flag
    je  m_nocreate          ; no
	mov	is_sympac,0			; no symbol table compaction with DDLs
    call    create_ddl      ; create the DDL
ENDIF

m_nocreate:
    mov ax,allocation_base
    mov mod_alloc_base,ax   ; save base of allocations prior to any module stuff

    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p1ostart            ; no
    mov bx,OFFSET DGROUP:stpass_text
    call    print_info
    mov bx,OFFSET DGROUP:obj_text
    call    print_info

p1ostart:
    call    pass1           ; perform first pass of linker
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p1oend              ; no
    mov bx,OFFSET DGROUP:endpass_text
    call    print_info
    mov bx,OFFSET DGROUP:obj_text
    call    print_info
    mov bx,OFFSET DGROUP:stpass_text
    call    print_info
    mov bx,OFFSET DGROUP:lib_text
    call    print_info

p1oend:
	cmp	is_quick,0			; see if quick linking
	je	p1_p1lib			; yes
	call	check_qlk		; check quick link file

p1_p1lib:
    call    proc1_libs      ; perform first pass library processing
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p1lend              ; no
    mov bx,OFFSET DGROUP:endpass_text
    call    print_info
    mov bx,OFFSET DGROUP:lib_text
    call    print_info

p1lend:
    mov al,'2'
    mov stpass_num,al       ; change pass number to 2
    mov endpass_num,al

IFNDEF DEMO
    cmp any_ddl,0           ; see if creating or using DDL
    je  m4                  ; no

    cmp udl_proc_pass,1     ; see if processing UDL w/libs
    jne no_udl              ; no

    call    free_memory     ; de-allocate memory prior to new memory allocation
    inc udl_proc_pass       ; bump flag to indicate UDL processing done
    call    reinit_variables    ; reset the variables
    mov module_count,0      ; reinit module count
    mov ax,mod_alloc_base
    mov allocation_base,ax  ; restore base of allocations prior to any module stuff
    call    ddl_save_libmod_entry   ; save the library module entries in low memory
    call    get_memory      ; allocate memory for file buffers and control blocks

    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p1ostart            ; no
    mov bx,OFFSET DGROUP:ddlpass_text
    call    print_info
    jmp NEAR PTR p1ostart      ; reloop and process as UDL

no_udl:
    call    proc_ddl        ; finish processing the DDL
    xor al,al               ; init return code to zero
    jmp NEAR PTR exit_link  ; done
ENDIF

m4:
    call    resolve_communals   ; resolve communal variables if any, adjust segments
    call    free_memory     ; de-allocate memory prior to new memory allocation

    call    ilf_rewind      ; rewind ilf file if exists

    call    init_map        ; if map file, write header info
    call    setup_exe_image ; compute segment frame values and allocate disk/memory for executable image

    call    ilf_write_eof   ; write eof mark to ilf file, if exists

    call    get_memory      ; allocate memory for file buffers and control blocks
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p2ostart            ; no
    mov bx,OFFSET DGROUP:stpass_text
    call    print_info
    mov bx,OFFSET DGROUP:obj_text
    call    print_info

p2ostart:
    call    pass2           ; perform second pass of linker
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p2oend              ; no
    mov bx,OFFSET DGROUP:endpass_text
    call    print_info
    mov bx,OFFSET DGROUP:obj_text
    call    print_info
    mov bx,OFFSET DGROUP:stpass_text
    call    print_info
    mov bx,OFFSET DGROUP:lib_text
    call    print_info

p2oend:
    call    proc2_libs      ; perform second pass library processing
	cmp	writing_qlk_flag,0	; see if writing qlk file
	je	p2_endlib			; no
	call	write_qlk_unres

p2_endlib:
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  p2lend              ; no
    mov bx,OFFSET DGROUP:endpass_text
    call    print_info
    mov bx,OFFSET DGROUP:lib_text
    call    print_info

p2lend:
    call    free_memory     ; de-allocate memory

    cmp ovl_count,0         ; see if any overlays
    je  mach_1              ; no
    call    ovl_entry_point ; make entry point go to overlay mananger

mach_1:
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  wstart              ; no
    mov bx,OFFSET DGROUP:stwrite_text
    call    print_info

wstart:
    call    write_program   ; write finished .COM or .EXE program
    call    finish_map      ; if map file, write remaining info
    cmp is_linkinfo,0       ; see if linker information to be printed
    je  wend                ; no
    mov bx,OFFSET DGROUP:endwrite_text
    call    print_info

wend:

;***    call    show_unreferenced   ; show symbols not referenced
    call    give_warn_count ; give count of warning messages, if any
    call    give_load_size  ; give EXE load image size

exit_1:
    xor al,al               ; init return code to zero
    cmp warn_count,0        ; see if any warnings were generated
    je  exit_link           ; no
    cmp is_exit0,0          ; see if warnings generate exit code of 0
    jne exit_link           ; yes
    inc al                  ; return exit code of 1 for warnings

exit_link::
    mov ah,4ch              ; terminate
    push    ax              ; save terminate and return code
    call    cleanup         ; clean up any interim system changes made

IFNDEF DEMO
    cmp is_beep,0           ; see if should beep
    je  exit_3              ; no

    mov bx,STDOUT
    mov dx,OFFSET DGROUP:beep3
    mov cx,3
    mov ah,40h              ; write to file or device
    int 21h                 ; beep the speaker three times
ENDIF

exit_3:
    pop ax                  ; restore terminate and return code
    int 21h
main        ENDP

;*****************************
;* PRINT_INFO                *
;*****************************

; print linker pass info
; upon entry bx -> text to print, with length byte preceding
; destroys ax,bx,cx,dx

print_info  PROC
    mov cl,[bx-1]           ; get length of string to print
    mov dx,bx               ; ds:dx -> string
    xor ch,ch               ; zap high byte of cx
    mov bx,STDOUT           ; write to standard output device
    mov ah,40h              ; write to device
    int 21h
    ret
print_info  ENDP

END start
