;*********************************************************************
;*   MLDATA.INC                                                      *
;*                                                                   *
;*   By:            Michael Devore                                   *
;*   Date:          12/21/92                                         *
;*   Model:         Small                                            *
;*   Version:       2.5                                              *
;*   Assembler:     MASM 5.0                                         *
;*   Environment:   MS-DOS 2.x+                                      *
;*                                                                   *
;*   External global data declarations                               *
;*                                                                   *
;*********************************************************************

; DATA variables
EXTERNDEF   is_args:BYTE
EXTERNDEF   is_comfile:BYTE
EXTERNDEF   is_mapfile:BYTE
EXTERNDEF   is_mapexpand:BYTE
EXTERNDEF   is_casesense:BYTE
EXTERNDEF   is_ondisk:BYTE
EXTERNDEF   is_inmem:BYTE
EXTERNDEF   is_msextlib:BYTE
EXTERNDEF   is_nodeflib:BYTE
EXTERNDEF   is_dosseg:BYTE
EXTERNDEF   is_dgroup:BYTE
EXTERNDEF   is_inlib:BYTE
EXTERNDEF   is_reload:BYTE
EXTERNDEF   is_stackval:BYTE
EXTERNDEF   is_maxparval:BYTE
EXTERNDEF   is_nonuldosseg:BYTE
EXTERNDEF   is_nowarn:BYTE
EXTERNDEF   is_exit0:BYTE
EXTERNDEF   is_beep:BYTE
EXTERNDEF   is_linkinfo:BYTE
EXTERNDEF   is_tempfile:BYTE
EXTERNDEF	is_quick:BYTE
EXTERNDEF	is_sympac:BYTE
EXTERNDEF	is_ohp:BYTE
EXTERNDEF	is_oht:BYTE
EXTERNDEF	is_umb:BYTE
EXTERNDEF	ems3_flag:BYTE
EXTERNDEF   wrap_flag:BYTE
EXTERNDEF   prev_flag:BYTE
EXTERNDEF   eof_flag:BYTE

; linker overlay and language specific related values
IFNDEF JUNIOR
EXTERNDEF   obj_ovl_flag:BYTE
EXTERNDEF   ovl_ox_evar:BYTE
EXTERNDEF   ovl_class:BYTE
EXTERNDEF   exact_ovl_class:BYTE
EXTERNDEF   ovl_pool:DWORD
EXTERNDEF   ovl_mem_alloc:BYTE
EXTERNDEF   ovl_max_load:WORD
EXTERNDEF   ovl_max_load_size:WORD
EXTERNDEF   ovl_stack:WORD
EXTERNDEF   ovl_filename:BYTE
EXTERNDEF   ovl_nopath:BYTE
EXTERNDEF   ovl_count:WORD
EXTERNDEF   ovl_handle:WORD
EXTERNDEF   ovl_ioblk:WORD
EXTERNDEF   seg_ovlclass:BYTE
EXTERNDEF   ovlpub_array:WORD
EXTERNDEF   ovl_reloc_array:WORD
EXTERNDEF   lookup_tbl_array:WORD
EXTERNDEF   ind_tbl_array:WORD
EXTERNDEF   first_ovlpubblk_ptr:WORD
EXTERNDEF   alloc_ovlpubblk_ptr:WORD
EXTERNDEF   ovl_pubcount:WORD
EXTERNDEF   lookup_tbl_segdef:WORD
EXTERNDEF   ind_tbl_segdef:WORD
EXTERNDEF   segcall_tbl_segdef:WORD
EXTERNDEF   largest_ovl:WORD
EXTERNDEF   second_ovl:WORD
EXTERNDEF   ovl_code_id:WORD
EXTERNDEF   ovl_data_id:WORD
EXTERNDEF   data_ovlblk_ptr:WORD
EXTERNDEF   nonovl_rvect:BYTE
EXTERNDEF   is_anyovls:BYTE
EXTERNDEF   is_clarion:BYTE
EXTERNDEF   is_internal:BYTE
EXTERNDEF   inc_padval:BYTE
EXTERNDEF   is_clpinc:BYTE
EXTERNDEF   is_clip5:BYTE
EXTERNDEF   is_smartmem:BYTE
EXTERNDEF   is_xms:BYTE
EXTERNDEF   is_min_pool:BYTE
EXTERNDEF   is_no_ems:BYTE
EXTERNDEF   is_ems_ovlpool:BYTE
EXTERNDEF   inc_seg_clcode:BYTE
EXTERNDEF   tmp_in_emsxms:BYTE
EXTERNDEF   tmp_in_xms:BYTE
EXTERNDEF   _dt_seg_size:WORD
EXTERNDEF   _dat_seg_size:WORD
EXTERNDEF   _dt_seg_index:WORD
EXTERNDEF   _dat_seg_index:WORD
EXTERNDEF   ems_handle:WORD
EXTERNDEF   ems_base:WORD
EXTERNDEF   ems_pagecount:WORD
EXTERNDEF   ems_currmap:WORD
EXTERNDEF   ems_page_avail:WORD
EXTERNDEF   xms_addr:DWORD
EXTERNDEF   is_ddl:BYTE
EXTERNDEF   use_ddl:BYTE
EXTERNDEF   any_ddl:BYTE
EXTERNDEF   ddldat_filename:BYTE
EXTERNDEF   is_xtstash:BYTE
EXTERNDEF   is_xpstash:BYTE
EXTERNDEF   udl_proc_pass:BYTE
EXTERNDEF	ovl_ohp_size:WORD
EXTERNDEF	ovl_oht_size:WORD
EXTERNDEF	ovl_ohp_alloc:BYTE
EXTERNDEF	ovl_oht_alloc:BYTE
ENDIF

EXTERNDEF   warn_count:WORD
EXTERNDEF   obj_count:WORD
EXTERNDEF   lib_count:WORD
EXTERNDEF   module_count:WORD
EXTERNDEF   seg_count:WORD
EXTERNDEF   segdef_count:WORD
EXTERNDEF   current_obj:WORD
EXTERNDEF   current_lib:WORD
EXTERNDEF   number_reloc:WORD
EXTERNDEF   communal_count:WORD
EXTERNDEF   stack_value:WORD
EXTERNDEF   maxpar_value:WORD

EXTERNDEF   pub_sym_count:DWORD
EXTERNDEF   tot_sym_count:DWORD
EXTERNDEF   highest_exe_write:DWORD
                 
EXTERNDEF   first_objblk_ptr:WORD
EXTERNDEF   last_objblk_ptr:WORD
EXTERNDEF   first_libblk_ptr:WORD
EXTERNDEF   last_libblk_ptr:WORD
EXTERNDEF   first_pdeclblk_ptr:WORD
EXTERNDEF   first_cdeclblk_ptr:WORD
EXTERNDEF   alloc_pdeclblk_ptr:WORD
EXTERNDEF   alloc_cdeclblk_ptr:WORD
EXTERNDEF   alloc_pdnameblk_ptr:WORD
EXTERNDEF   alloc_lnamesblk_ptr:WORD
EXTERNDEF   first_segdefblk_ptr:WORD
EXTERNDEF   alloc_segdefblk_ptr:WORD
EXTERNDEF   first_segpartblk_ptr:WORD
EXTERNDEF   alloc_segpartblk_ptr:WORD
EXTERNDEF   first_grpblk_ptr:WORD
EXTERNDEF   alloc_grpblk_ptr:WORD
EXTERNDEF   first_relblk_ptr:WORD
EXTERNDEF   alloc_relblk_ptr:WORD
EXTERNDEF   first_libent_ptr:WORD
EXTERNDEF   alloc_libent_ptr:WORD
;***EXTERNDEF   first_local_ptr:WORD
EXTERNDEF   first_fixblk_ptr:WORD
EXTERNDEF   alloc_fixblk_ptr:WORD
EXTERNDEF   first_binblk_ptr:WORD
EXTERNDEF   alloc_binblk_ptr:WORD
EXTERNDEF   _edata_pubaddr:WORD
EXTERNDEF   _end_pubaddr:WORD
EXTERNDEF   _edata_segaddr:WORD
EXTERNDEF   _end_segaddr:WORD

EXTERNDEF   exe_name:BYTE
EXTERNDEF   map_name:BYTE

EXTERNDEF   pubdecl_hash:WORD
EXTERNDEF   segdef_hash:WORD
EXTERNDEF   zero_table:WORD

EXTERNDEF   lnames_hash:DWORD

; DATA? variables
EXTERNDEF   ctrlbreak:BYTE
EXTERNDEF   dos_version:BYTE

EXTERNDEF   psp:WORD
EXTERNDEF   image_handle:WORD
EXTERNDEF   image_mem_ptr:WORD
EXTERNDEF   map_handle:WORD
EXTERNDEF   memory_blk_base:WORD
EXTERNDEF   memory_blk_size:WORD
EXTERNDEF   memory_blk_end:WORD
EXTERNDEF   allocation_base:WORD
EXTERNDEF   allocation_top:WORD
EXTERNDEF   buffer_base:WORD
EXTERNDEF   buffer_end:WORD
EXTERNDEF   buffer_head:WORD
EXTERNDEF   buffer_tail:WORD
EXTERNDEF   buffer_size:WORD
EXTERNDEF   read_buff_ptr:WORD
EXTERNDEF   prev_read_ptr:WORD
EXTERNDEF   prev_rec_len:WORD
EXTERNDEF   current_lnames:WORD
EXTERNDEF   current_extdef:WORD
EXTERNDEF   current_segdef:WORD
EXTERNDEF   current_grpdef:WORD
EXTERNDEF   eof_pos:WORD
EXTERNDEF   data_fixup_count:WORD
EXTERNDEF   stack_segval:WORD
EXTERNDEF   stack_offval:WORD
EXTERNDEF   entry_segval:WORD
EXTERNDEF   entry_offval:WORD
EXTERNDEF   master_segblk:WORD
EXTERNDEF   ovl_filepos_blk:WORD

EXTERNDEF   image_size:DWORD
EXTERNDEF   file_pos_adj:DWORD
EXTERNDEF   prev_pos_adj:DWORD
EXTERNDEF   lib_pos_adj:DWORD

EXTERNDEF   cmd_line:BYTE
EXTERNDEF   prev_libname:BYTE
EXTERNDEF   tmod_name:BYTE
EXTERNDEF   ovl_class_name:BYTE

EXTERNDEF   frame_thrd_meth:BYTE
EXTERNDEF   target_thrd_meth:BYTE

EXTERNDEF   seg_partent_indptr:WORD
EXTERNDEF   seg_defent_indptr:WORD
EXTERNDEF   grp_ent_indptr:WORD
EXTERNDEF   ext_defent_indptr:WORD
EXTERNDEF   lib_page_storage:WORD
EXTERNDEF   env_opt_storage:BYTE
EXTERNDEF   data_fixup_flag:WORD
EXTERNDEF   ddl_hold_buff:WORD
EXTERNDEF   frame_thrd_index:WORD
EXTERNDEF   target_thrd_index:WORD

EXTERNDEF   lnames_ent_indptr:DWORD
EXTERNDEF   ddl_symbol_lookup:DWORD
EXTERNDEF   lib_id:DWORD
