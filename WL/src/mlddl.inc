
DDL_HEADER_STRUC    STRUC
    dh_sig1 DB  ?           ; DDL file signature bytes
    dh_sig2 DB  ?
    dh_sig3 DB  ?
    dh_sig4 DB  ?
    dh_majorver DB  ?       ; major version number
    dh_minor1   DB  ?       ; minor version number 1
    dh_minor2   DB  ?       ; minor version number 2
    dh_minor3   DB  ?       ; minor version alpha
    dh_hdrsize  DW  ?       ; size of module header
    dh_loadsize DW  ?       ; size of DDL loader
    dh_loadstart    DD  ?   ; file position of start of loader
    dh_flags    DD  ?       ; DDL flags
                            ; bit 0==main module flag
                            ; bit 1==required root modules flag
                            ; bit 2==required overlay modules flag
                            ; bit 3==elective root modules flag
                            ; bit 4==elective overlay modules flag
                            ; bit 5==DOSSEG flag
                            ; bit 6==contains pre-loading routine
    dh_op       DD  ?       ; /op option value
    dh_st       DW  ?       ; /st option value
    dh_as       DW  ?       ; /as option value
    dh_os       DW  ?       ; /os option value
    dh_ol       DW  ?       ; /ol option value
    dh_mem      DB  ?       ; 0==free mem op, nonzero==alloc mem op
    dh_minop    DB  ?       ; 0==normal /op, 1==/op:m
    dh_ox       DB  ?       ; 0==regular memory for op, nonzero==EMS page frame for op
    dh_r        DB  ?       ; /r option setting
    dh_cla      DB  ?       ; /cla option setting
    dh_ou       DB  ?       ; /ou option setting
    dh_ort      DB  ?       ; /ort setting
    dh_orp      DB  ?       ; /orp setting
    dh_modcount DW  ?       ; module count in DDL
    dh_ddlcount DW  ?       ; count of DDL's in dependency list (for main module)
    dh_reqroot  DW  ?       ; count of required root modules in DDL
    dh_reqovl   DW  ?       ; count of required overlay modules in DDL
    dh_elecroot DW  ?       ; count of elective root modules in DDL
    dh_elecovl  DW  ?       ; count of elective overlay modules in DDL
    dh_ddlstart DD  ?       ; file position of start of DDL dependency list
    dh_preload  DD  ?       ; file position of pre-load module
    dh_modstart DD  ?       ; file position of start of DDL module file position dword entries
    dh_dictstart    DD  ?   ; file position of start of DDL dictionary

	dh_ohp3		DB	?		; flag ohp3 use
	dh_ohp_flag	DB	?		; nonzero if /ohp allocate to amount flag set
	dh_oht_flag	DB	?		; nonzero if /oht allocate to amount flag set
	dh_pad		DB	?		; pad value
	dh_ohp		DW	?		; /ohp size in K
	dh_oht		DW	?		; /oht size in K

    dh_reser3   DD  ?       ; reserved for future
    dh_reser4   DD  ?       ; reserved for future
    dh_oxevar   DB  32 DUP (?)  ; specified /ox environment variable
DDL_HEADER_STRUC    ENDS

MOD_HEADER_STRUC    STRUC
    mh_flags    DD  ?       ; module flags
                            ; bit 0==main module flag
                            ; bit 1==required root module flag
                            ; bit 2==required overlay module flag
                            ; bit 3==elective root module flag
                            ; bit 4==elective overlay module flag
                            ; bit 6==pre-load module
                            ; bit 7==contains communal variables (COMDEFs)
    mh_id       DW  ?       ; module identifier
    mh_segcount DW  ?       ; count of segments in module
    mh_grpcount DW  ?       ; count of groups in module
    mh_pubcount DW  ?       ; count of publics
    mh_comcount DW  ?       ; count of communals
    mh_extcount DW  ?       ; count of externals
    mh_lnames   DD  ?       ; file position of start of lnames name block
    mh_segdef   DD  ?       ; file position of start of segment entries
    mh_grpdef   DD  ?       ; file position of start of group entries
    mh_symbols  DD  ?       ; file position of start of symbols (pub/ext/comdef) name block
    mh_pubdef   DD  ?       ; file position of start of pubdef entries
    mh_comdef   DD  ?       ; file position of start of comdef entries
    mh_extdef   DD  ?       ; file position of start of extdef entries
    mh_binary   DD  ?       ; file position of start of binary data
    mh_startup  DB  7 DUP (?)   ; start address if main module in fixup notation
    mh_pad      DB  ?       ; pad to keep at dword boundary
    mh_binfpos  DD  ?       ; file position of each binary entry file position table
    mh_reser2   DD  ?       ; reserved for future
MOD_HEADER_STRUC    ENDS
