FUNCTION p1_maketbl_rd, settings

	fname	= settings.p1_dust_fname
        nchem   = 9L
        OPENR, 11, fname, /f77_unformatted
        nt = 0L & nz = 0L
        READU, 11, nt, nz

        log_t = DBLARR(nt) & log_z = DBLARR(nz)
        READU, 11, log_t
        READU, 11, log_z

        log_cm  = DBLARR(nt, nz)
        dum     = DBLARR(nt)
        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_cm(*,i)     = dum
        ENDFOR

        log_ce  = DBLARR(nt, nz)
        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_ce(*,i)     = dum
        ENDFOR

        log_cmet= DBLARR(nt, nz)
        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_cmet(*,i)   = dum
        ENDFOR

        log_cy  = DBLARR(nt, nz, nchem)
        FOR n=0L, nchem-1L DO BEGIN
                FOR z=0L, nz-1L DO BEGIN
                        READU, 11, dum
                        log_cy(*,z,n)   = dum
                ENDFOR
        ENDFOR

        log_cmdust      = DBLARR(nt, nz, 3)
        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_cmdust(*,i,0)       = dum
        ENDFOR

        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_cmdust(*,i,1)       = dum
        ENDFOR

        FOR i=0L, nz-1L DO BEGIN
                READU, 11, dum
                log_cmdust(*,i,2)       = dum
        ENDFOR
        CLOSE, 11

        data    = {nt:nt, nz:nz, $
                log_t:log_t, log_z:log_z, log_cm:log_cm, log_ce:log_ce, $
                log_cmet:log_cmet, log_cy:log_cy, $
                log_cmdust:log_cmdust}
        RETURN, data
END

FUNCTION p1_maketbl_int, yy, zz, z=z
        zz      = 10.^zz
        res     = yy(*,0)*0.d
        FOR i=0L, N_ELEMENTS(res)-1L DO BEGIN
                res(i)  = ALOG10(INTERPOL(10.^yy(i,*), zz, z))
        ENDFOR
        RETURN, res
END

FUNCTION p1_maketbl_gendust, settings, ydust, arr;, y, x, zarr, z
	nt	= N_ELEMENTS(arr.t)
	nz	= N_ELEMENTS(arr.z)
	dustarr	= DBLARR(nt, nz, 3)
	FOR ind_d=0L, 2L DO BEGIN
		FOR ind_z=0L, nz-1L DO BEGIN
			;; Interpolation for metallicity first (in linear space)
			IF arr.z(ind_z) LT 10.^ydust.log_z(0) THEN BEGIN
				met_int	= ydust.log_cmdust(*,0,ind_d)
			ENDIF ELSE IF arr.z(ind_z) GT 10.^ydust.log_z(-1) THEN BEGIN
				met_int	= ydust.log_cmdust(*,-1,ind_d)
			ENDIF ELSE BEGIN
				met_int	= p1_maketbl_int(ydust.log_cmdust(*,*,ind_d), ydust.log_z, z=arr.z(ind_z))
			ENDELSE

				;cgDisplay, 800, 800
				;cgPlot, ydust.log_t, ydust.log_cmdust(*,0,ind_d), linestyle=0, xrange=[7., 8.]
				;FOR k=1L, 6L DO cgOplot, ydust.log_t, ydust.log_cmdust(*,k,ind_d), linestyle=0
				;cgOplot, ydust.log_t, met_int, linestyle=0, color='red'
				;PRINT, 10.^ydust.log_z, arr.z(ind_z)
				;STOP

			;; Interpolation for time space (in linear space)
			cut	= WHERE(arr.t LT 10.^ydust.log_t(0), ncut)
			IF ncut GE 1L THEN dustarr(cut,ind_z,ind_d) = met_int(0)

			cut	= WHERE(arr.t GT 10.^ydust.log_t(-1), ncut)
			IF ncut GE 1L THEN dustarr(cut,ind_z,ind_d) = met_int(-1)

			cut	= WHERE(arr.t GE 10.^ydust.log_t(0) AND arr.t LE 10.^ydust.log_t(-1), ncut)
			IF ncut GE 1L THEN BEGIN
				age_int	= INTERPOL(met_int, 10.^ydust.log_t, arr.t(cut));, /spline)
				dustarr(cut,ind_z,ind_d) 	= age_int
			ENDIF

				;IF ind_z EQ 0L THEN cgDisplay, 800, 800
				;IF ind_z EQ 0L THEN cgPlot, ALOG10(arr.t), dustarr(*,ind_z,ind_d), linestyle=0, thick=4, xrange=[7.9, 8.]
				;cgOplot, ALOG10(arr.t), dustarr(*,ind_z,ind_d), linestyle=0, thick=8
				;cgOplot, ydust.log_t, met_int, linestyle=0, color='red'
				;STOP
		ENDFOR
	ENDFOR
	RETURN, dustarr
END

PRO p1_maketbl, settings

	;;-----
	;; LOAD TABLE
	;;-----
	IF settings.p1_tbltype EQ 's99org_kp' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
		suffix	= 's99org_kp_pagb.dat'
	ENDIF ELSE IF settings.p1_tbltype EQ 's99org_cb' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_s99org_cb_pagb.sav'
		suffix	= 's99org_cb_pagb.dat'
		IF settings.p1_dust EQ 'on' THEN suffix	= 's99org_cb_pagb_ydust2.dat'
	ENDIF ELSE IF settings.p1_tbltype EQ 'yohan_cb' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_yohan_cb_pagb.sav'
		tmp     = 'array = array.' + STRTRIM(settings.p1_tbltype_vrot,2)
		void	= EXECUTE(tmp)
		suffix	= 'yohan_cb_pagb_' + STRTRIM(settings.p1_tbltype_vrot,2) + '.dat'
	ENDIF ELSE BEGIN
		PRINT, 'TABLE HAS NOT BEEN IMPLEMENTED YET'
		DOC_LIBRARY, 'p1_maketbl'
		STOP
	ENDELSE

	;;-----
	;; Time Range
	;;-----
	zr	= N_ELEMENTS(array.cyield_wn(*,0,0))
	er	= N_ELEMENTS(array.cyield_wn(0,0,*))
	tcut	= LINDGEN(N_ELEMENTS(array.t))
	FOR i=0L, zr-1L DO BEGIN
		FOR j=0L, er-1L DO BEGIN
			tcut_dum	= WHERE(array.cyield_wn(i,*,j) GT 0., ncut)
			IF ncut LE N_ELEMENTS(tcut) THEN tcut = tcut_dum
		ENDFOR
	ENDFOR
	array	= {t:array.t(tcut), $
		z:array.z, $
		cyield_wn:array.cyield_wn(*,tcut,*), $
		cml_wn:array.cml_wn(*,tcut), $
		en_wn:array.en_wn(*,tcut)}

	;;-----
	;; MAKE DUST TABLE
	;;-----
	IF settings.p1_dust EQ 'on' THEN BEGIN
		ydust	= p1_maketbl_rd(settings)
		dust	= p1_maketbl_gendust(settings, ydust, array)

		;; Set upper limits to dust not to exceed wind yield
		;;	Dust yield cannot be greater than 99% of stellar wind
		FOR i=0L, N_ELEMENTS(array.z)-1L DO BEGIN
			;; For C dust
			dust(*,i,1)	= ALOG10( 10.^dust(*,i,1) < array.cyield_wn(i,*,2)*0.99 )

			;; For Si dust
			;; 	TODO
			;PRINT, i, MIN(array.cyield_wn(i,*,2) - 10.^dust(*,i,1))
			;PRINT, i, MIN(array.cyield_wn(i,*,5) - 10.^dust(*,i,2)*0.141d)
			;PRINT, i, MIN(array.cyield_wn(i,*,8) - 10.^dust(*,i,2)*0.324d)
			;PRINT, i, MIN(array.cyield_wn(i,*,6) - 10.^dust(*,i,2)*0.163d)
			;PRINT, i, MIN(array.cyield_wn(i,*,4) - 10.^dust(*,i,2)*0.372d)
		ENDFOR

		;; Reduce the original yield with the amount of dust
		;; 	RAMSES does treat chemical yield including dust
		;;
		;js_stat, array.cyield_wn
		;t1	= TOTAL(array.cyield_wn(2,*,*),3)
		;FOR i=0L, N_ELEMENTS(array.z)-1L DO BEGIN
		;	;; C From C dust
		;	array.cyield_wn(i,*,2)	-= 10.d^dust(*,i,1)

		;	;; Mg From Si dust (14.1%)
		;        array.cyield_wn(i,*,5)	-= 10.d^dust(*,i,2) * 0.141d

		;	;; Fe From Si dust (32.4%)
		;	array.cyield_wn(i,*,8)	-= 10.d^dust(*,i,2) * 0.324d

		;	;; Si From Si dust (16.3%)
		;	array.cyield_wn(i,*,6)	-= 10.d^dust(*,i,2) * 0.163d

		;	;; O From Si dust (37.2%)
		;	array.cyield_wn(i,*,4)	-= 10.d^dust(*,i,2) * 0.372d
		;ENDFOR
		;t2	= TOTAL(array.cyield_wn(2,*,*),3) + 10.d^dust(*,2,1) + 10.d^dust(*,2,2)
		;js_stat, array.cyield_wn
		;STOP
	ENDIF
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
	log_ceSW= DOUBLE(array.en_wn)
	FOR i=0L, nz_SW - 1L DO WRITEU, 10, log_ceSW(i,*)

	;;CUMULATIVE METAL MASS FROM WINDS
	FOR i=0L, nz_SW - 1L DO BEGIN
		log_cmzSW	= DOUBLE(array.cyield_wn(i,*,*))
		log_cmzSW	= REFORM(log_cmzSW, nt_SW, nchem)
		log_cmzSW	= log_cmzSW(*,2:*)
		log_cmzSW	= ALOG10(TOTAL(log_cmzSW,2))
		WRITEU, 10, log_cmzSW
	ENDFOR

	;;YIELD TABLE
	FOR ichem=0L, nchem-1L DO BEGIN	;; H THROUGH FE
		FOR i=0L, nz_SW - 1L DO BEGIN
			dum	= DOUBLE(ALOG10(array.cyield_wn(i,*,ichem)))
			WRITEU, 10, dum
		ENDFOR
	ENDFOR

	;;Dust TABLE
	IF settings.p1_dust EQ 'on' THEN BEGIN
		;ydust	= p1_maketbl_rd(settings)
		;dust	= p1_maketbl_gendust(settings, ydust, array)

		FOR i=0L, nz_SW - 1L DO BEGIN ;; Total dust mass
			WRITEU, 10, dust(*,i,0)
		ENDFOR

		FOR i=0L, nz_SW - 1L DO BEGIN ;; Total C dust mass 
			WRITEU, 10, dust(*,i,1)
		ENDFOR	

		FOR i=0L, nz_SW - 1L DO BEGIN ;; Total Si dust mass 
			WRITEU, 10, dust(*,i,2)
		ENDFOR
	ENDIF
	CLOSE, 10

END
