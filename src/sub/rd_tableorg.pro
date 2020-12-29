FUNCTION rd_tableorg, fname, totalmass=totalmass, nelem=nelem

	IF ~KEYWORD_SET(totalmass) THEN totalmass = 1.0d0
	IF ~KEYWORD_SET(nelem) THEN nelem=9L

	;fname	= 'swind_krp_pagb.dat'
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

	cyield_wn	= DBLARR(nz_SW,nt_SW,nelem)
	;log_cmHSW	= DBLARR(nt_SW, nz_SW)
	;log_cmCSW	= DBLARR(nt_SW, nz_SW)
	;log_cmNSW	= DBLARR(nt_SW, nz_SW)
	;log_cmOSW	= DBLARR(nt_SW, nz_SW)
	;log_cmMgSW	= DBLARR(nt_SW, nz_SW)
	;log_cmSiSW	= DBLARR(nt_SW, nz_SW)
	;log_cmSSW	= DBLARR(nt_SW, nz_SW)
	;log_cmFeSW	= DBLARR(nt_SW, nz_SW)

	READU, 10, log_tSW

	READU, 10, log_zSW

	;;-- cumulative stellar mass loss
	dum1d	= DBLARR(nt_sW)
	FOR i=0L, nz_SW -1L DO BEGIN
		READU, 10, dum1d
		log_cmSW(*,i)	= dum1d
	ENDFOR

	;;-- cumulative mechanical energy from winds
	dum1d	= DBLARR(nt_sW)
	FOR i=0L, nz_SW -1L DO BEGIN
		READU, 10, dum1d
		log_ceSW(*,i)	= dum1d
	ENDFOR

	;;-- cumulative metal mass from winds
	FOR i=0L, nz_SW -1L DO BEGIN
		READU, 10, dum1d
		log_cmzSW(*,i)	= dum1d
	ENDFOR

	;;--
	FOR ie=0L, nelem-1L DO BEGIN
		FOR iz=0L, nz_SW - 1L DO BEGIN
			READU, 10, dum1d
			cyield_wn(iz,*,ie) = 10.0d^dum1d
		ENDFOR
	ENDFOR

	print, totalmass
	cyield_wn	= cyield_wn / totalmass
	cml_wn		= 10.0d^log_cmSW / totalmass
	en_wn		= log_ceSW - ALOG10(totalmass)

	array	= {T:10.0d^log_tSW, z:10.0d^log_zSW, $
		cyield_wn:cyield_wn, cml_wn:cml_wn, en_wn:en_wn}

	CLOSE, 10

	RETURN, array

END
