PRO p1_maketbl, settings

	;;-----
	;; LOAD TABLE
	;;-----
	IF settings.p1_tbltype EQ 's99org' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
		suffix	= 's99org_kp_pagb.dat'
	ENDIF ELSE BEGIN
		PRINT, 'TABLE HAS NOT BEEN IMPLEMENTED YET'
		DOC_LIBRARY, 'p1_maketbl'
		STOP
	ENDELSE

	;;-----
	;; MAKE TABLE IN A RAMSES-NEEDED FORMAT
	;;-----
	nchem	= N_ELEMENTS(array.cyield_wn(0,0,*))

	fname	= settings.dir_save + suffix
	OPENW, 10, fname, /f77_unformatted

	;;HEADER
	nt_SW	= LONG(N_ELEMENTS(array.t))
	nz_SW	= LONG(N_ELEMENTS(array.z))
	WRITEU, 10, nt_SW, nz_SW

	;;AGE & METALLICITY GRIDs
	log_tSW	= DOUBLE(ALOG10(array.t))
	log_zSW	= DOUBLE(ALOG10(array.z))
	WRITEU, 10, log_tSW
	WRITEU, 10, log_zSW

	;;CUMULATIVE STELLAR MASS LOSS BY STELLAR WIND
	log_cmSW= DOUBLE(ALOG10(array.cml_wn))
	FOR i=0L, nz_SW - 1L DO WRITEU, 10, log_cmSW(i,*)

	;;CUMULATIVE MECHANICAL ENERGY BY STELLAR WIND
	log_ceSW= DOUBLE(ALOG10(array.en_wn))
	FOR i=0L, nz_SW - 1L DO WRITEU, 10, log_ceSW(i,*)

	;;CUMULATIVE METAL MASS FROM WINDS
	FOR i=0L, nz_SW - 1L DO BEGIN
		log_cmzSW	= DOUBLE(array.cyield_wn(i,*,*))
		log_cmzSW	= REFORM(log_cmzSW, nt_SW, nchem)
		log_cmzSW	= log_cmzSW(*,2:*)
		log_cmzSW	= TOTAL(log_cmzSW,2)
		WRITEU, 10, log_cmzSW
	ENDFOR

	;;YIELD TABLE
	FOR ichem=0L, nchem-1L DO BEGIN	;; H THROUGH FE
		FOR i=0L, nz_SW - 1L DO BEGIN
			dum	= DOUBLE(ALOG10(array.cyield_wn(i,*,ichem)))
			WRITEU, 10, dum
		ENDFOR
	ENDFOR
	CLOSE, 10

	STOP
END