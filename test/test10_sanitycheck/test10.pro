FUNCTION test10_int, yy, zz, z=z
	
	zz	= 10.^zz
	res	= yy(*,0)*0.d
	FOR i=0L, N_ELEMENTS(res)-1L DO BEGIN
		res(i)	= ALOG10(INTERPOL(10.^yy(i,*), zz, z))
	ENDFOR
	RETURN, res
END

FUNCTION test10_rd, settings, fname, dust=dust

	nchem	= 9L
	OPENR, 11, fname, /f77_unformatted
	nt = 0L & nz = 0L
	READU, 11, nt, nz

	log_t = DBLARR(nt) & log_z = DBLARR(nz)
	READU, 11, log_t
	READU, 11, log_z
	
	log_cm	= DBLARR(nt, nz)
	dum	= DBLARR(nt)
	FOR i=0L, nz-1L DO BEGIN
		READU, 11, dum
		log_cm(*,i)	= dum
	ENDFOR

	log_ce	= DBLARR(nt, nz)
	FOR i=0L, nz-1L DO BEGIN
		READU, 11, dum
		log_ce(*,i)	= dum
	ENDFOR

	log_cmet= DBLARR(nt, nz)
	FOR i=0L, nz-1L DO BEGIN
		READU, 11, dum
		log_cmet(*,i)	= dum
	ENDFOR

	log_cy	= DBLARR(nt, nz, nchem)
	FOR n=0L, nchem-1L DO BEGIN
		FOR z=0L, nz-1L DO BEGIN
			READU, 11, dum
			log_cy(*,z,n)	= dum
		ENDFOR
	ENDFOR

	log_cmdust	= DBLARR(nt, nz, 3)
	IF KEYWORD_SET(dust) THEN BEGIN
		FOR i=0L, nz-1L DO BEGIN
			READU, 11, dum
			log_cmdust(*,i,0)	= dum
		ENDFOR

		FOR i=0L, nz-1L DO BEGIN
			READU, 11, dum
			log_cmdust(*,i,1)	= dum
		ENDFOR

		FOR i=0L, nz-1L DO BEGIN
			READU, 11, dum
			log_cmdust(*,i,2)	= dum
		ENDFOR
	ENDIF
	CLOSE, 11

	data	= {nt:nt, nz:nz, $
		log_t:log_t, log_z:log_z, log_cm:log_cm, log_ce:log_ce, $
		log_cmet:log_cmet, log_cy:log_cy, $
		log_cmdust:log_cmdust}
	RETURN, data

END

PRO test10_evolcheck, new, dust, mass=mass, met=met, elem=elem, type=type, ddust=ddust, checkdust=checkdust

	cgPS_open, '~/scratch/tmpfb.eps', /encapsulated
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.charthick = 3.5

	IF KEYWORD_SET(mass) THEN BEGIN
		PRINT, 'cmass'
		cgPlot, new.log_t, new.log_cm(*,0), /nodata, /noerase, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (mass)')

		cm1	= test10_int(new.log_cm, new.log_z, z=0.1 * 0.02)
		cm2	= test10_int(new.log_cm, new.log_z, z=1. * 0.02)
		cm3	= test10_int(new.log_cm, new.log_z, z=1.5 * 0.02)

		cgOplot, new.log_t, cm1, color='red', linestyle=0
		cgOplot, new.log_t, cm2, color='green', linestyle=0
		cgOplot, new.log_t, cm3, color='blue', linestyle=0

		cm1	= test10_int(dust.log_cm, dust.log_z, z=0.1 * 0.01345)
		cm2	= test10_int(dust.log_cm, dust.log_z, z=1. * 0.01345)
		cm3	= test10_int(dust.log_cm, dust.log_z, z=1.5 * 0.01345)

		cgOplot, dust.log_t, cm1, color='red', linestyle=2
		cgOplot, dust.log_t, cm2, color='green', linestyle=2
		cgOplot, dust.log_t, cm3, color='blue', linestyle=2
	ENDIF ELSE IF KEYWORD_SET(met) THEN BEGIN
		PRINT, 'cmet'
		cgPlot, new.log_t, new.log_cmet(*,4), /nodata, /noerase, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (mass)')

		cm1	= test10_int(new.log_cmet, new.log_z, z=0.1 * 0.02)
		cm2	= test10_int(new.log_cmet, new.log_z, z=1. * 0.02)
		cm3	= test10_int(new.log_cmet, new.log_z, z=1.5 * 0.02)

		cgOplot, new.log_t, cm1, color='red', linestyle=0
		cgOplot, new.log_t, cm2, color='green', linestyle=0
		cgOplot, new.log_t, cm3, color='blue', linestyle=0

		cm1	= test10_int(dust.log_cmet, dust.log_z, z=0.1 * 0.01345)
		cm2	= test10_int(dust.log_cmet, dust.log_z, z=1. * 0.01345)
		cm3	= test10_int(dust.log_cmet, dust.log_z, z=1.5 * 0.01345)

		cgOplot, dust.log_t, cm1, color='red', linestyle=2
		cgOplot, dust.log_t, cm2, color='green', linestyle=2
		cgOplot, dust.log_t, cm3, color='blue', linestyle=2
	ENDIF ELSE IF KEYWORD_SET(elem) THEN BEGIN
		PRINT, 'elem'
		IF type EQ 'C' THEN ind = 2L
		IF type EQ 'N' THEN ind = 3L
		IF type EQ 'O' THEN ind = 4L
		IF type EQ 'Mg' THEN ind = 5L
		IF type EQ 'Si' THEN ind = 6L
		IF type EQ 'S' THEN ind = 7L
		IF type EQ 'Fe' THEN ind = 8L

		cgPlot, new.log_t, new.log_cy(*,4,ind), /nodata, /noerase, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (mass)')

		cm1	= test10_int(new.log_cy(*,*,ind), new.log_z, z=0.1 * 0.02)
		cm2	= test10_int(new.log_cy(*,*,ind), new.log_z, z=1. * 0.02)
		cm3	= test10_int(new.log_cy(*,*,ind), new.log_z, z=1.5 * 0.02)

		cgOplot, new.log_t, cm1, color='red', linestyle=0
		cgOplot, new.log_t, cm2, color='green', linestyle=0
		cgOplot, new.log_t, cm3, color='blue', linestyle=0

		cm1	= test10_int(dust.log_cy(*,*,ind), dust.log_z, z=0.1 * 0.01345)
		cm2	= test10_int(dust.log_cy(*,*,ind), dust.log_z, z=1. * 0.01345)
		cm3	= test10_int(dust.log_cy(*,*,ind), dust.log_z, z=1.5 * 0.01345)

		cgOplot, dust.log_t, cm1, color='red', linestyle=2
		cgOplot, dust.log_t, cm2, color='green', linestyle=2
		cgOplot, dust.log_t, cm3, color='blue', linestyle=2
	ENDIF ELSE IF KEYWORD_SET(ddust) THEN BEGIN
		PRINT, 'dust'
		cgPlot, dust.log_t, dust.log_cmdust(*,3,0L), /nodata, /noerase, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (mass)')

		cm1	= test10_int(dust.log_cmdust(*,*,0), dust.log_z, z=1.5 * 0.01345)
		cm2	= test10_int(dust.log_cmdust(*,*,1), dust.log_z, z=1.5 * 0.01345)
		cm3	= test10_int(dust.log_cmdust(*,*,2), dust.log_z, z=1.5 * 0.01345)

		cgOplot, dust.log_t, cm1, color='black', linestyle=0, thick=16
		cgOplot, dust.log_t, cm2, color='green', linestyle=0
		cgOplot, dust.log_t, cm3, color='blue', linestyle=0
	ENDIF ELSE IF KEYWORD_SET(checkdust) THEN BEGIN
		ind	= 2L
		PRINT, checkdust
		cgPlot, new.log_t, new.log_cmdust(*,-1,ind), /nodata, /noerase, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (mass)'), yrange=[-12., -2.]

		cgOplot, new.log_t, new.log_cmdust(*,0,ind), thick=8, color='red', linestyle=0
		cgOplot, new.log_t, new.log_cmdust(*,1,ind), thick=8, color='green', linestyle=0
		cgOplot, new.log_t, new.log_cmdust(*,2,ind), thick=8, color='blue', linestyle=0
		cgOplot, new.log_t, new.log_cmdust(*,3,ind), thick=8, color='purple', linestyle=0
		cgOplot, new.log_t, new.log_cmdust(*,4,ind), thick=8, color='orange', linestyle=0

		cm1	= test10_int(dust.log_cmdust(*,*,ind), dust.log_z, z=10.^new.log_z(0))
		cm2	= test10_int(dust.log_cmdust(*,*,ind), dust.log_z, z=10.^new.log_z(1))
		cm3	= test10_int(dust.log_cmdust(*,*,ind), dust.log_z, z=10.^new.log_z(2))
		cm4	= test10_int(dust.log_cmdust(*,*,ind), dust.log_z, z=10.^new.log_z(3))
		cm5	= test10_int(dust.log_cmdust(*,*,ind), dust.log_z, z=10.^new.log_z(4))

		cgOplot, dust.log_t, cm1, color='red', linestyle=2
		cgOplot, dust.log_t, cm2, color='green', linestyle=2
		cgOplot, dust.log_t, cm3, color='blue', linestyle=2
		cgOplot, dust.log_t, cm4, color='purple', linestyle=2
		cgOplot, dust.log_t, cm5, color='orange', linestyle=2

	ENDIF

	cgPS_close
	js_makepng, epsname='~/scratch/tmpfb.eps', density=1000.
	img	= READ_IMAGE('~/scratch/tmpfb.png')
	cgDisplay, 1200, 1200
	cgImage, img
	STOP
END
PRO test10, settings
	;fnew	= settings.dir_save + 's99org_cb_pagb.dat'
	fnew	= settings.dir_save + 's99org_cb_pagb_ydust.dat'
	fold	= '/storage6/hansan/ramses-yomp/s99org_cb_pagb.dat'
	fdust	= '/storage6/hansan/testruns/smbht/16th/ramses_swind_Sikey.dat'

	data_new	= test10_rd(settings, fnew, /dust)
	data_old	= test10_rd(settings, fold)
	data_dust	= test10_rd(settings, fdust, /dust)

	PRINT, '%123123 -----'
	PRINT, '	Time bins [log]'
	PRINT, '	SB99	: ', data_new.log_t(0), ' - ', data_new.log_t(-1)
	PRINT, '	Yohan	: ', data_dust.log_t(0), ' - ', data_dust.log_t(-1)
	PRINT, '	'
	PRINT, '	Metal bins'
	PRINT, '	SB99	: ', 10.^data_new.log_z(0)/0.02, ' - ', 10.^data_new.log_z(-1)/0.02
	PRINT, '	Yohan	: ', 10.^data_dust.log_z(0)/0.01345, ' - ', 10.^data_dust.log_z(-1)/0.01345

	;test10_evolcheck, data_new, data_dust, /mass
	;test10_evolcheck, data_new, data_dust, /met
	;test10_evolcheck, data_new, data_dust, /elem, type='Fe'
	;test10_evolcheck, data_new, data_dust, /ddust
	test10_evolcheck, data_new, data_dust, /checkdust

	;cgDisplay, 800, 800

	STOP
END
