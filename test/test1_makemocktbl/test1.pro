PRO test1, settings

	;;-----
	;; READ ORG TABLE FIRST
	;;----

	fname	= settings.root_path + 'test/test1*/swind_krp_pagb.dat'
	OPENR, 10, fname, /f77_unformatted
	nt_SW = 0L & nz_SW = 0L

	READU, 10, nt_SW, nz_SW

	;; ALLOCATE
	log_tSW		= DBLARR(nt_SW)
	log_zSW		= DBLARR(nz_SW)
	log_cmSW	= DBLARR(nt_SW, nz_SW)
	log_ceSW        = DBLARR(nt_SW, nz_SW)
	log_cmzSW       = DBLARR(nt_SW, nz_SW)

	log_cmHSW       = DBLARR(nt_SW, nz_SW)
	log_cmHeSW	= DBLARR(nt_SW, nz_SW)
	log_cmCSW       = DBLARR(nt_SW, nz_SW)
	log_cmNSW       = DBLARR(nt_SW, nz_SW)
	log_cmOSW       = DBLARR(nt_SW, nz_SW)
	log_cmMgSW      = DBLARR(nt_SW, nz_SW)
	log_cmSiSW      = DBLARR(nt_SW, nz_SW)
	log_cmSSW       = DBLARR(nt_SW, nz_SW)
	log_cmFeSW      = DBLARR(nt_SW, nz_SW)

	READU, 10, log_tSW
	READU, 10, log_zSW

	dum1d	= DBLARR(nt_SW)
	READU, 10, dum1d
		log_cmSW(*,0)	= dum1d
	READU, 10, dum1d
		log_cmzSW(*,0)	= dum1d
	READU, 10, dum1d
		log_ceSW(*,0)	= dum1d
	CLOSE, 10

	;;-----
	;; DERIVE METALLICITY DEPENDENCY
	;;-----
	dum_log_z	= ALOG10($
		[0.02, 0.0166, 0.0142, 0.0134, 0.01, 0.005, $
		0.0047, 0.0021, 0.001, 0.0005, 0.0002, 0.0001])
	dum_log_mrate	= [-6.58, -6.6, -6.63, -6.64, -6.68, -6.8, $
		-6.81, -6.95, -7.09, -7.21, -8.26, -8.4]

	cut_st	= SORT(dum_log_z)
	dum_log_z = dum_log_z(cut_st) & dum_log_mrate = dum_log_mrate(cut_st)

	log_zdep	= SPLINE(dum_log_z, dum_log_mrate, log_zsw)
	;; MODIFY FOR EXTRAPOLATION
	log_zdep(-1)	= (log_zdep(-2) - log_zdep(-3)) / (log_zsw(-2) - log_zsw(-3)) * $
		(log_zsw(-1) - log_zsw(-3)) + log_zdep(-3)

	;;-----
	;; MAKE MOCK TABLE
	;;-----
	comp_tbl	= [71., 27.1, 0.97, 0.40, 0.096, 0.076, 0.099, 0.040, 0.14]
		;H, He, C, N, O, Mg, Si, S, Fe
	comp_frac	= comp_tbl / total(comp_tbl(2:*))
	FOR i=0L, nz_SW-1L DO BEGIN
		log_cmSW(*,i)	= log_cmSW(*,0) + (log_zdep(i) - log_zdep(0))
		log_cmzSW(*,i)	= log_cmzSW(*,0) + (log_zdep(i) - log_zdep(0))
		log_ceSW(*,i)	= log_ceSW(*,0); + (log_zdep(i) - log_zdep(0))

		log_cmHSW(*,i)	= log_cmSW(*,i)		* comp_tbl(0)/100.d
		log_cmHeSW(*,i)	= log_cmSW(*,i)		* comp_tbl(1)/100.d
		log_cmCSW(*,i)	= log_cmZSW(*,i)	* comp_frac(2)
		log_cmNSW(*,i)	= log_cmZSW(*,i)	* comp_frac(3)
		log_cmOSW(*,i)	= log_cmZSW(*,i)	* comp_frac(4)
		log_cmMgSW(*,i)	= log_cmZSW(*,i)	* comp_frac(5)
		log_cmSiSW(*,i)	= log_cmZSW(*,i)	* comp_frac(6)
		log_cmSSW(*,i)	= log_cmZSW(*,i)	* comp_frac(7)
		log_cmFeSW(*,i)	= log_cmZSW(*,i)	* comp_frac(8)

	ENDFOR

	;;-----
	;; WRITE
	;;-----
	fname	= settings.root_path + 'test/test1*/swind_mocktbl.dat'
	OPENW, 10, fname, /f77_unformatted
	
	;; HEADER
	WRITEU, 10, nt_SW, nz_SW

	;; AGE & METALLICITY ARRAY
	WRITEU, 10, log_tSW
	WRITEU, 10, log_zSW

	;; CUMULATIVE STELLAR MASS LOSS
	FOR i=0L, nz_SW - 1L DO WRITEU, 10, log_cmSW(*,i)

	;; CUMULATIVE MECHANICAL ENERGY FROM WINDS
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_ceSW(*,i);*0.0d

	;; CUMULATIVE METAL MASS FROM WINDS
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmzSW(*,i)

	;; YIELD TABLE
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmHSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmHeSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmCSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmNSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmOSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmMgSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmSiSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmSSW(*,i)
	FOR i=0L, nz_SW -1L DO WRITEU, 10, log_cmFeSW(*,i)
	CLOSE, 10

	STOP
END
