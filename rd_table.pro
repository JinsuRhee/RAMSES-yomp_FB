PRO rd_table

	fname	= 'swind_krp_pagb.dat'
	OPENR, 10, fname, /f77_unformatted
	nt_SW = 0L & nz_SW = 0L

	READU, 10, nt_SW, nz_SW

	;;;;;
	;; ALLOCATE
	;;;;;

	log_tSW		= DBLARR(nt_SW)
	log_zSW		= DBLARR(nz_SW)
	log_cmSW	= DBLARR(nt_SW, nz_SW)
	log_ceSW	= DBLARR(nt_SW, nz_SW)
	log_cmzSW	= DBLARR(nt_SW, nz_SW)

	log_cmHSW	= DBLARR(nt_SW, nz_SW)
	log_cmCSW	= DBLARR(nt_SW, nz_SW)
	log_cmNSW	= DBLARR(nt_SW, nz_SW)
	log_cmOSW	= DBLARR(nt_SW, nz_SW)
	log_cmMgSW	= DBLARR(nt_SW, nz_SW)
	log_cmSiSW	= DBLARR(nt_SW, nz_SW)
	log_cmSSW	= DBLARR(nt_SW, nz_SW)
	log_cmFeSW	= DBLARR(nt_SW, nz_SW)

	;log_cmSW_spec	= 
	READU, 10, log_tSW

	READU, 10, log_zSW

	;;-- cumulative stellar mass loss
	dum1d	= DBLARR(nt_sW)
	FOR i=0L, nz_SW -1L DO BEGIN
		READU, 10, dum1d
		log_cmSW(*,i)	= dum1d
		STOP
	ENDFOR

	STOP
	;;-- cumulative mechanical energy from winds
	FOR i=0L, nz_SW -1L DO READU, 10, log_ceSW(*,i)

	;;-- cumulative metal mass from winds
	FOR i=0L, nz_SW -1L DO READU, 10, log_ceSW(*,i)

	;;--
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmHSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmHeSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmCSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmNSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmOSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmMgSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmSiSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmSSW(*,i)
	FOR i=0L, nz_SW -1L DO READU, 10, log_cmFeW(*,i)


	CLOSE, 10
	STOP


END
