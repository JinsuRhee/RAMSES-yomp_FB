;;-----
;; SFH
;;-----
FUNCTION p3_gce_getsfr, set, t
	N	= set.galmass / set.mstar
	a	= N / (set.SFH_tau^2*(1.d - EXP(-set.maxT/set.SFH_tau)) - set.SFH_tau*set.maxT*EXP(-set.maxT / set.SFH_tau))
	RETURN, a * t * EXP(-t / set.SFH_tau)
END

;;-----
;; STAR PTCLs
;;-----
FUNCTION p3_gce_genstar, set
	n_star	= LONG(set.galmass / set.mstar)
	star	= {mass:0.d, Z:0.d, age:0.d, active:-1L, yield:DBLARR(9), snactive:-1L, nSNIa:0L, wind_ml0:0.d, wind_yield0:DBLARR(9), wind_dyield0:DBLARR(2)}
	star	= REPLICATE(star, n_star)
	RETURN, star
END
PRO p3_gce_starin, set, stars, nn, gal
	n0	= set.sind
	n1	= set.sind + nn-1L
	stars(n0:n1).active 	= 1L
	stars(n0:n1).mass	= set.mstar
	stars(n0:n1).Z		= gal.z
	stars(n0:n1).yield 	= REBIN(gal.yield, N_ELEMENTS(gal.yield), n1-n0+1L)
	stars(n0:n1).age	= (DINDGEN(nn+1L)/(nn) * set.delT)[1:nn]
	set.sind	= n1+1L
END

;;-----
;; GAL
;;-----
FUNCTION p3_gce_gengal, set
	n_step	= LONG(set.maxT / set.delT) + 1L
	gprop	= {mass:0.d, Z:0.d, n_star:0L, t:0.d, new_star:0L, gasmass:0.d, sfr:0.d, $
		yield:DBLARR(9), e_wind:0.d, e_snII:0.d, e_snIa:0.d, $
		dyield:DBLARR(2)}
	gprop	= REPLICATE(gprop, n_step)

	gprop(0).gasmass	= set.galmass / (1.0 - set.fgas);set.galmass + set.galmass * set.fgas
	gprop(0).Z		= set.init_Z
	; Asplund 09
	gprop(0).yield(0)	= 1.0 - set.init_Z;0.7500
	gprop(0).yield(1)	= 0.d
	gprop(0).yield(2)	= 10.^(8.43d0-12.) * 12.0 * gprop(0).yield(0) ; C
	gprop(0).yield(3)	= 10.^(7.83d0-12.) * 14.0 * gprop(0).yield(0) ; N
	gprop(0).yield(4)	= 10.^(8.69d0-12.) * 16.0 * gprop(0).yield(0) ; O
	gprop(0).yield(5)	= 10.^(7.60d0-12.) * 24.0 * gprop(0).yield(0) ; Mg
	gprop(0).yield(6)	= 10.^(7.51d0-12.) * 28.0 * gprop(0).yield(0) ; Si
	gprop(0).yield(7)	= 10.^(7.12d0-12.) * 32.0 * gprop(0).yield(0) ; S
	gprop(0).yield(8)	= 10.^(7.50d0-12.) * 57.0 * gprop(0).yield(0) ; Fe

	gprop(0).yield(2:*) = gprop(0).yield(2:*) / TOTAL(gprop(0).yield(2:*)) * (1.0 - gprop(0).yield(0) - gprop(0).yield(1))
	RETURN, gprop
END

;;-----
;; SET
;;-----
FUNCTION p3_gce_settings, settings

	set	= {$
		delT:1e7, minT:0.d, maxT:1.4e10, delT_log:1.0e9, $
		galmass:1e11, fgas:1e-4, gasmass:0., init_Z:0.001*0.02, $
		mstar:1e6, snII_blastT:50.0d6, snIa_tini:5e7, snIa_tfin:1.37e10, snIa_norm:2.35e-4, $

		;; SFH
		SFH_tau:3.0e9, $

		;; Tables
		tbl_no:[7L, 2L, 1L], $
			;;	[WW(1) / WWCK(2) / CK(3) / Yohan_v0 (4) / Yohan_v300 (5) / Final (6) / Final+Nboost (7)
			;;   MC(1) / NOMC(2),
			;;   DUST(1) / DUSTBOOST(2)]

		;; Others
		dir_lib:'/storage5/jinsu/idl_lib/IDLlib/jinsu/', $
		num_thread:20L, $
		Sind:0L, $
		Nstep:0L, $
		Nlog:0L, $
		elemlist:['H', 'He', 'C', 'N', 'O', 'Mg', 'Si', 'S', 'Fe'] $
	}
	set.Nstep	= set.maxT / set.delT
	set.Nlog	= LONG(DOUBLE(set.Nstep) / (set.maxT / set.delT_log))
	RETURN, set
END

;;-----
;; LOAD TABLE
;;-----
FUNCTION p3_gce_loadtbl, set
	tbl_no	= set.tbl_no
	dir 	= '/storage6/jinsu/var/YOMP_NewFB/sb99_pagb_cb_'
	IF tbl_no(0) EQ 1L THEN dir += 'ww'
	IF tbl_no(0) EQ 2L THEN dir += 'wwck'
	IF tbl_no(0) EQ 3L THEN dir += 'ck'

	IF tbl_no(1) EQ 1L THEN dir += '_'
	IF tbl_no(1) EQ 2L THEN dir += 'nomc_'

	IF tbl_no(2) EQ 1L THEN dir += 'dust/'
	IF tbl_no(2) EQ 2L THEN dir += 'dustboost/'

	IF tbl_no(0) EQ 4L THEN dir = '/storage6/jinsu/var/YOMP_NewFB/yohan_pagb_cb/v0/'
	IF tbl_no(0) EQ 5L THEN dir = '/storage6/jinsu/var/YOMP_NewFB/yohan_pagb_cb/v300/'

	IF tbl_no(0) EQ 6L THEN BEGIN
		IF tbl_no(2) EQ 1L THEN dir = '/storage6/jinsu/var/YOMP_NewFB/final/'
		IF tbl_no(2) EQ 2L THEN dir ='/storage6/jinsu/var/YOMP_NewFB/final_db/'
	ENDIF

	IF tbl_no(0) EQ 7L THEN dir = '/storage6/jinsu/var/YOMP_NewFB/final_nboost/'

	RESTORE, dir + 'table.sav'
	RESTORE, dir + 'sntable.sav'
	PRINT, dir

	table 	= array
	table 	= CREATE_STRUCT(table, 'snII', sntbl)

	;;SNIa
	dum	= [$
		5.08E-02,1.56E-09,3.31E-08,4.13E-07,1.33E-01,3.33E-10,2.69E-10,1.37E-10, $
		2.29E-03,2.81E-08,2.15E-08,1.41E-05,1.58E-02,1.64E-07,1.87E-07,1.13E-04, $
		1.42E-01,5.79E-05,7.12E-05,9.12E-05,9.14E-02,6.07E-05,1.74E-05,3.41E-11, $
		1.06E-05,5.56E-06,1.91E-02,6.60E-07,3.42E-12,1.67E-06,4.83E-07,1.81E-02, $
		1.06E-08,6.17E-08,1.38E-05,1.01E-09,2.47E-09,3.85E-08,3.49E-07,4.08E-07, $
		3.13E-04,2.94E-06,1.04E-04,1.22E-08,4.27E-05,6.65E-05,7.73E-03,5.66E-04, $
		9.04E-04,6.66E-03,7.30E-02,6.80E-01,1.92E-02,2.96E-03,9.68E-04,8.34E-02, $
		1.47E-02,2.15E-04,1.85E-03,1.65E-05,3.00E-06,8.33E-07,7.01E-05,6.26E-06, $
		7.28E-09,1.13E-08]
	SNIa 	= {ml:TOTAL(dum), yield: $
		[0., 0., $
		TOTAL(dum(0L:1L)), TOTAL(dum(2L:3L)), TOTAL(dum(4L:6L)), $ ; C, N, O
		TOTAL(dum(12L:14L)), TOTAL(dum(16L:18L)), $ ; Mg, Si
		TOTAL(dum(20L:23L)), TOTAL(dum(50L:53L))]} ; S

	table 	= CREATE_STRUCT(table, 'snIa', SNIa)
	RETURN, table
END

;;-----
;; WIND YIELD
;;-----
PRO p3_gce_wind, set, gprop, stars, array

	IF set.sind EQ 0L THEN RETURN

	lind	= set.sind - 1L
	st_age	= stars(0L:lind).age
	st_met	= stars(0L:lind).Z

	met	= array.z
	age	= array.t

	;ml0	= JS_INTERP2d(array.cml_wn, met, age, st_met, (st_age - set.delt) > 1e-8, num_thread=set.num_thread)*set.mstar
	ml0	= stars(0L:lind).wind_ml0
	ml 	= JS_INTERP2d(array.cml_wn, met, age, st_met, st_age, num_thread=set.num_thread, dir=set.dir_lib)*set.mstar
	stars(0L:lind).wind_ml0 	= ml
	ml 	= ml - ml0

	FOR i=0L, 8L DO BEGIN
		;ejecta0	= JS_INTERP2d(REFORM(array.cyield_wn(*,*,i), N_ELEMENTS(met), N_ELEMENTS(age)), met, age, st_met, (st_age - set.delt) > 1e-8, num_thread=set.num_thread)*set.mstar
		ejecta0	= stars(0L:lind).wind_yield0(i)
		ejecta	= JS_INTERP2d(REFORM(array.cyield_wn(*,*,i), N_ELEMENTS(met), N_ELEMENTS(age)), met, age, st_met, st_age, num_thread=set.num_thread, dir=set.dir_lib)*set.mstar
		stars(0L:lind).wind_yield0(i) 	= ejecta
		ejecta 	= ejecta - ejecta0
		gprop.yield(i)	= (TOTAL(ejecta) + gprop.gasmass*gprop.yield(i)) / (gprop.gasmass + TOTAL(ml))
		;PRINT, (TOTAL(ejecta) + gprop.gasmass*gprop.yield(i)) / (gprop.gasmass + TOTAL(ml))
	ENDFOR

	;; Dust
	FOR i=0L, 1L DO BEGIN
		;ejecta0	= JS_INTERP2d(REFORM(array.cdyield_wn(*,*,i), N_ELEMENTS(met), N_ELEMENTS(age)), met, age, st_met, (st_age - set.delt) > 1e-8, num_thread=set.num_thread)*set.mstar
		ejecta0	= stars(0L:lind).wind_dyield0(i)
		ejecta	= JS_INTERP2d(REFORM(array.cdyield_wn(*,*,i), N_ELEMENTS(met), N_ELEMENTS(age)), met, age, st_met, st_age, num_thread=set.num_thread, dir=set.dir_lib)*set.mstar
		stars(0L:lind).wind_dyield0(i) 	= ejecta
		ejecta 	= ejecta - ejecta0
		gprop.dyield(i) 	= gprop.dyield(i) + TOTAL(ejecta)
	ENDFOR

	gprop.gasmass 	+= TOTAL(ml)
	stars(0L:lind).mass 	-= ml

	gprop.e_wind= TOTAL(ml)
	gprop.z 	= TOTAL(gprop.yield(2L:*))	
END

;;-----
;; SNII YIELD
;;-----
PRO p3_gce_SNII, set, gprop, stars, table
		sntbl 	= table.snII
		lind 	= set.sind - 1L
		cut 	= WHERE(stars.age GT set.snII_blastT AND stars.snactive LT 0L, ncut)
		IF ncut EQ 0L THEN RETURN

		met 	= table.z
		star_Z	= stars(cut).z > met(0)
		star_Z 	= star_Z < met(-1)

		ml 	= 10.^INTERPOL(sntbl.m, met, star_Z) * set.mstar
		g0 	= gprop
		FOR i=1L, 9L DO BEGIN
			ejecta 	= 10.^INTERPOL(sntbl.(i), met, star_Z) * ml
			gprop.yield(i-1) 	= (TOTAL(ejecta) + gprop.gasmass*gprop.yield(i-1)) / (gprop.gasmass + TOTAL(ml))
		ENDFOR

		;;Dust
		FOR i=0L, 1L DO BEGIN
			ejecta 	= 10.^INTERPOL(sntbl.(10+i), met, star_Z) * ml
			gprop.dyield(i)	= gprop.dyield(i) + TOTAL(ejecta)
		ENDFOR

		gprop.e_snII 	= TOTAL(ml)
		gprop.gasmass 	+= TOTAL(ml)
		stars(cut).mass -= ml
		stars(cut).snactive 	= 1L
		gprop.z 	= TOTAL(gprop.yield(2L:*))
END

;;-----
;; SNIa YIELD
;;-----
PRO p3_gc3_SNIa, set, gprop, stars, table
	lind 	= set.sind-1L

	cut 	= WHERE(stars.age GT set.snIa_tini AND stars.age LT set.snIa_tfin, ncut)
	IF ncut EQ 0L THEN RETURN

	
	nSNIa 	= LONG(set.snIa_norm * (ALOG(stars(cut).age / set.snIa_tini)) * set.mstar)
	cut2 	= WHERE(stars(cut).nSNIa NE nSNIa, ncut2)
	IF ncut2 EQ 0L THEN RETURN

	ind 	= cut(cut2)
	nSNIa	= nSNIa(cut2)
	dN 		= nSNIa - stars(ind).nSNIa
	ml 		= dN * table.snIa.ml
	;;-----
	FOR i=0L, 8L DO BEGIN
		ejecta 	= dN * table.snIa.yield(i)
		gprop.yield(i)	= (TOTAL(ejecta) + gprop.gasmass*gprop.yield(i)) / (gprop.gasmass + TOTAL(ml))
	ENDFOR

	gprop.e_snIa 	= TOTAL(ml)
	gprop.gasmass 	+= TOTAL(ml)
	stars(ind).mass -= ml
	stars(ind).nSNIa = nSNIa
	gprop.z 	= TOTAL(gprop.yield(2L:*))
END


;;-----
;; MAIN
;;-----
PRO p3_gce, settings

	set	= p3_gce_settings(settings)

	;;----- 
	;; TABLE
	;;-----
	table 	= p3_gce_loadtbl(set)
	;RESTORE, settings.dir_data + 'table.sav'

	;;-----
	;; GEN GAL & STARS
	;;-----	
	gprop	= p3_gce_gengal(set)
	stars	= p3_gce_genstar(set)

	;; Run
	t_curr	= set.minT
	sf	= 0.d
	FOR i=1L, set.Nstep-1L DO BEGIN
		;; Update
		gprop(i)	= gprop(i-1)

		;; Time related
		t_curr	+= set.delT
		gprop(i).t	= t_curr

		

		;; Age update
		stars(0L:set.sind).age	+= set.delt

		;; STAR FORMATION
;		sf0	= p3_gce_getsfr(set, t_curr) * set.delT
;		IF sf0 LT 10. THEN BEGIN
;			sf	+= sf0
;		ENDIF ELSE BEGIN
;			sf	= sf0
;		ENDELSE
;
;		IF sf GT 10. THEN BEGIN
;			n_newstar	= LONG(sf)
;			sf	= 0.d
;			p3_gce_starin, set, stars, n_newstar, gprop(i-1)
;
;			;gprop(i).mass		+= n_newstar * set.mstar
;			gprop(i).gasmass	+= (- n_newstar * set.mstar)
;			gprop(i).new_star	= n_newstar
;		ENDIF

		sfr 	= p3_gce_getsfr(set, t_curr)
		n_star 	= LONG(sfr * set.delT)
		IF n_star GE 1L THEN BEGIN
			p3_gce_starin, set, stars, n_star, gprop(i)
			gprop(i).gasmass 	+= (-n_star * set.mstar)
			gprop(i).new_star 	= n_star
			gprop(i).sfr 		= sfr
		ENDIF

		;; STELLAR WIND YIELD
		gdum 	= gprop(i)
		p3_gce_wind, set, gdum, stars, table
		gprop(i)	= gdum

		;; SNII YIELD
		gdum 	= gprop(i)
		p3_gce_SNII, set, gdum, stars, table
		gprop(i)	= gdum

		;; SNIa Yield
		gdum 	= gprop(i)
		p3_gc3_SNIa, set, gdum, stars, table
		gprop(i)	= gdum

		;; galaxy mass
		gprop(i).mass 	= TOTAL(stars.mass)
		;; LOG
		IF i MOD set.Nlog EQ 0L THEN BEGIN
			PRINT, '%123123'
			PRINT, ' T = ', t_curr
			PRINT, ' Gal Mass = ', gprop(i).mass
			PRINT, ' Gas Mass = ', gprop(i).gasmass
			PRINT, ' f_gas 	  = ', gprop(i).gasmass / (gprop(i).mass + gprop(i).gasmass)
		ENDIF
	ENDFOR

	;; EXTRACT
	cut	= WHERE(gprop.t GE 1e7)
	gprop	= gprop(cut)

	cut	= WHERE(stars.active GE 0L)
	stars	= stars(cut)

	;; SAVE
	sunX 	= 0.7438
	sunY 	= 0.2423
	sunC	= 10.^(8.43d0-12.) * 12.0 * sunX ; C
	sunN	= 10.^(7.83d0-12.) * 14.0 * sunX ; N
	sunO	= 10.^(8.69d0-12.) * 16.0 * sunX ; O
	sunMg	= 10.^(7.60d0-12.) * 24.0 * sunX ; Mg
	sunSi	= 10.^(7.51d0-12.) * 28.0 * sunX ; Si
	sunS	= 10.^(7.12d0-12.) * 32.0 * sunX ; S
	sunFe	= 10.^(7.50d0-12.) * 57.0 * sunX ; Fe
	sun 	= {X:sunX, Y:sunY, C:sunC, N:sunN, O:sunO, Mg:sunMg, Si:sunSi, S:sunS, Fe:sunFe}

	FeoH	= ALOG10(gprop.yield(-1) / gprop.yield(0) / (sunFe / sunX))
	OoFe	= ALOG10(gprop.yield(4) / gprop.yield(-1) / (sunO / sunFe))
	MgoFe 	= ALOG10(gprop.yield(5) / gprop.yield(-1) / (sunMg/ sunFe))
	cgPlot, FeoH, OoFe, linestyle=0, color='blue', yrange=[-0.5, 0.5]
	cgOplot, FeoH, MgoFe, linestyle=0, color='red'

	;STOP
	SAVE, filename='/storage6/jinsu/var/YOMP_NewFB/gcetest/g_' + STRING(set.tbl_no(0),format='(I1.1)') + $
		'_' + STRING(set.tbl_no(1),format='(I1.1)') + $
		'_' + STRING(set.tbl_no(2),format='(I1.1)') + '.sav', gprop, stars, sun

	;cgPlot, gprop.t, gprop.mass, /xlog, /ylog, linestyle=0
	;cgPlot, gprop.t, gprop.new_star, /xlog, /ylog, linestyle=0
	;cgHistoplot, ALOG10(stars.age)
	;cgPlot, gprop.t, ALOG10(gprop.z/0.02), linestyle=0, /xlog
	;cgPlot, gprop.t, gprop.e_wind+1e-32, /xlog, /ylog, linestyle=0
	;cgOplot, gprop.t, gprop.e_snII+1e-32, linestyle=0, color='red'
	;cgOplot, gprop.t, gprop.e_snIa+1e-32, linestyle=0, color='blue'
	;STOP


	;sunO 	= 0.02 * 0.39389979
	;sunMg 	= 0.02 * 0.0486535
	;sunFe 	= 0.02 * 0.0884559
		


	;; fortran replicate table to (# of threads)
	STOP

	cgPlot, gprop.t, gprop.dyield(0), linestyle=0, /xlog, /ylog
	cgOplot, gprop.t, gprop.dyield(1), linestyle=0, color='red'
	STOP

END
