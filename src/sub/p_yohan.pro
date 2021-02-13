FUNCTION p_yohan_getmetal, file, zsun=zsun, STRING=STRING, VALUE=VALUE

	flist	= FILE_SEARCH(file + '/*.agb')
	zmet	= DBLARR(N_ELEMENTS(flist))
	zstr	= STRARR(N_ELEMENTS(flist))
	FOR i=0L, N_ELEMENTS(flist)-1L DO BEGIN
		dum	= flist(i)
		dum	= STRSPLIT(dum, '/', /extract)
		FOR j=0L, N_ELEMENTS(dum)-1L DO BEGIN
			IF STRPOS(dum(j),'yields_evol') GE 0L THEN BREAK
		ENDFOR
		dum	= dum(j)
		dum	= STRSPLIT(dum, '_', /extract)
		dum	= dum(2)
		dum	= STRMID(dum, 1L, STRLEN(dum))
		zstr(i) = dum
		zmet(i)	= DOUBLE(dum)
	ENDFOR
	zmet	= 10.0d^zmet * zsun
	
	IF KEYWORD_SET(STRING) THEN RETURN, zstr
	IF KEYWORD_SET(VALUE) THEN RETURN, zmet
END

FUNCTION p_yohan_getvrot, file

	vrot	= STRARR(N_ELEMENTS(file))
	FOR i=0L, N_ELEMENTS(file)-1L DO BEGIN
		dum	= file(i)
		dum	= STRSPLIT(dum,'/',/extract)
		dum	= dum(-1)
		vrot(i) = dum
	ENDFOR

	RETURN, vrot
END

PRO p_yohan, settings
IF settings.p_yohan_gen EQ 1L THEN BEGIN
	;;-----
	;; Settings
	;;-----
	dir	= settings.root_path + 'src/ssp/yohan'
	outdir	= dir + '/ResultingYields/'
	mfailed		= 40.d
	failed_fraction = 1.0d
	mass_separatrix	= 8.0d

	;;-----
	;; Run
	;;-----
	CD, dir
	run_all_yield_release, /chabrier,$
		mfailed=mfailed, $
		failed_fraction=failed_fraction, $
		mass_separatrix=mass_separatrix, $
		dir=dir, outdir=outdir
	CD, settings.root_path + 'src'
ENDIF

IF settings.p_yohan_pp EQ 1L THEN BEGIN
	;;-----
	;; Settings
	;;-----
	dir	= settings.root_path + 'data/yohan/'

	f_vrotls= FILE_SEARCH(dir + 'v*')
	nrot	= N_ELEMENTS(f_vrotls)
	nmetal	= N_ELEMENTS(FILE_SEARCH(f_vrotls(0) + '/*.agb'))
	ntime	= FILE_LINES(f_vrotls(0) + '/*z0*.agb') - 3L
	nelem	= N_ELEMENTS(settings.p_yohan_elemlist)

	;;-----
	;; GET VROT array
	;;-----
	vrot	= p_yohan_getvrot(f_vrotls)

	;;-----
	;; Get Metallicity array
	;;-----
	
	zmet	= p_yohan_getmetal(f_vrotls(0), zsun=0.01345, /VALUE)
	zstr	= p_yohan_getmetal(f_vrotls(0), zsun=0.01345, /STRING)
	
	;;-----
	;; ALLOCATE
	;;-----
	time	= DBLARR(ntime)
	yield_wn= DBLARR(nrot,nmetal,ntime,nelem)
	yield_sn= DBLARR(nrot,nmetal,ntime,nelem)
	ml_wn	= DBLARR(nrot,nmetal,ntime)
	ml_sn	= DBLARR(nrot,nmetal,ntime)
	en_wn	= DBLARR(nrot,nmetal,ntime)
	en_sn	= DBLARR(nrot,nmetal,ntime)


	;;-----
	;; READ
	;;-----
	zind	= SORT(zmet)
	FOR ri=0L, nrot-1L DO BEGIN
		FOR zi=0L, nmetal-1L DO BEGIN
			zi2	= zind(zi)
			;;-----
			;; READ SN Yield?
			;;-----

			file	= f_vrotls(ri) + '/*_z' + STRTRIM(zstr(zi2),2) + '_*.txt'
			file	= FILE_SEARCH(file)

			str	= 'readcol, file, t1, m1'
			FOR i=0L, nelem-1L DO str = str + ', e' + STRTRIM(i,2)
			str	= str + ', format="(D, D' 
			FOR i=0L, nelem-1L DO str = str + ', D'
			str	= str + ')", numline=FILE_LINES(file), skipline=3L'
			void	= EXECUTE(str)

			IF ri EQ 0L AND zi EQ 0L THEN BEGIN
				time = t1
			ENDIF ELSE BEGIN
				dum = ABS(time - t1)
				IF MAX(dum) NE 0. AND MIN(dum) NE 0. THEN BEGIN
					PRINT, 'time array is different', ri, zi
					DOC_LIBRARY, 'p_yohan'
					STOP
				ENDIF
			ENDELSE

			FOR ei=0L, nelem-1L DO BEGIN
				ml_sn(ri,zi,*)	= m1
				str	= 'yield_sn(ri,zi,*,ei) = ' + 'e' + STRTRIM(ei,2)
				void	= EXECUTE(str)
			ENDFOR

			;;-----
			;; READ WN YIELD
			;;-----

			file	= f_vrotls(ri) + '/*_z' + STRTRIM(zstr(zi2),2) + '_*.txt.agb'
			file	= FILE_SEARCH(file)

			str	= 'readcol, file, t1, m1'
			FOR i=0L, nelem-1L DO str = str + ', e' + STRTRIM(i,2)
			str	= str + ', format="(D, D' 
			FOR i=0L, nelem-1L DO str = str + ', D'
			str	= str + ')", numline=FILE_LINES(file), skipline=3L'
			void	= EXECUTE(str)

			;; Time Array Check
			dum = ABS(time - t1)
			IF MAX(dum) NE 0. AND MIN(dum) NE 0. THEN BEGIN
				PRINT, 'time array is different', ri, zi
				DOC_LIBRARY, 'p_yohan'
				STOP
			ENDIF
			

			FOR ei=0L, nelem-1L DO BEGIN
				ml_wn(ri,zi,*)	= m1
				str	= 'yield_wn(ri,zi,*,ei) = ' + 'e' + STRTRIM(ei,2)
				void	= EXECUTE(str)
			ENDFOR

			;;-----
			;; READ SN ENERGY
			;;-----

			file	= f_vrotls(ri) + '/*_z' + STRTRIM(zstr(zi2),2) + '_*.txt.esnII'
			file	= FILE_SEARCH(file)

			readcol, file, t1, e1, e2, format='D, D, D', numline=FILE_LINES(file)

			;; Time Array Check
			dum = ABS(time - t1)
			IF MAX(dum) NE 0. AND MIN(dum) NE 0. THEN BEGIN
				PRINT, 'time array is different', ri, zi
				DOC_LIBRARY, 'p_yohan'
				STOP
			ENDIF
			
			en_sn(ri,zi,*)	= e1
			en_wn(ri,zi,*)	= e2
		ENDFOR

	ENDFOR


	;cyield_wn	= REFORM(yield_wn(0,*,*,*)*0.d,nmetal,ntime,nelem)
	;cyield_sn	= REFORM(yield_sn(0,*,*,*)*0.d,nmetal,ntime,nelem)
	;cml_wn		= REFORM(ml_wn(0,*,*)*0.d,nmetal,ntime)
	;cml_sn		= REFORM(ml_sn(0,*,*)*0.d,nmetal,ntime)

	metal_rearr	= SORT(zmet)
	zmet	= zmet(metal_rearr)
	array	= {zmet:zmet, vrot:vrot, elemlist:settings.p_yohan_elemlist}
	tprev	= 0.d
	FOR ri=0L, nrot-1L DO BEGIN
		cyield_wn	= REFORM(yield_wn(ri,*,*,*),nmetal,ntime,nelem)
		cyield_sn	= REFORM(yield_sn(ri,*,*,*),nmetal,ntime,nelem)
		cyield_sn	= cyield_sn - cyield_wn

		cml_wn	= REFORM(ml_wn(ri,*,*),nmetal,ntime)
		cml_sn	= REFORM(ml_sn(ri,*,*),nmetal,ntime)
		cml_sn	= cml_sn - cml_wn

		cyield_wn	= cyield_wn(metal_rearr,*,*)
		cyield_sn	= cyield_sn(metal_rearr,*,*)
		cml_wn		= cml_wn(metal_rearr,*)
		cml_sn		= cml_sn(metal_rearr,*)

		cen_wn	= REFORM(en_wn(ri,*,*),nmetal,ntime)
		cen_sn	= REFORM(en_sn(ri,*,*),nmetal,ntime)

		cen_wn	= cen_wn(metal_rearr,*)
		cen_sn	= cen_sn(metal_rearr,*)
		;FOR ti=0L, ntime-1L DO BEGIN
		;	dt	= time(ti) - tprev
		;	j	= ti - 1
		;	IF ti EQ 0L THEN j=ti
		;	FOR iz=0L,nmetal-1L DO FOR ie=0L,nelem-1L DO $
		;		cyield_wn(iz,ti,ie) = cyield_wn(iz,j,ie) + $
		;		yield_wn(ri,iz,ti,ie) * dt

		;	FOR iz=0L,nmetal-1L DO FOR ie=0L,nelem-1L DO $
		;		cml_wn(iz,ti) = cml_wn(iz,j) + ml_wn(ri,iz,ti) * dt

		;	FOR iz=0L,nmetal-1L DO FOR ie=0L,nelem-1L DO $
		;		cml_sn(iz,ti) = cml_sn(iz,j) + ml_sn(ri,iz,ti) * dt

		;	tprev	= time(ti)
		;ENDFOR
		dumstr	= {T:time, Z:zmet, cyield_wn:cyield_wn, cyield_sn:cyield_sn, $
			;yield_wn:REFORM(yield_wn(ri,*,*,*),nmetal,ntime,nelem), $
			;yield_sn:REFORM(yield_sn(ri,*,*,*),nmetal,ntime,nelem), $
			cml_wn:cml_wn, cml_sn:cml_sn, $
			;ml_wn:REFORM(ml_wn(ri,*,*),nmetal,ntime), $
			;ml_sn:REFORM(ml_sn(ri,*,*),nmetal,ntime), $
			en_wn:cen_wn, $
			en_sn:cen_sn}

		array	= CREATE_STRUCT(array,STRTRIM(vrot(ri),2),dumstr)
	ENDFOR

	SAVE, filename=settings.dir_save + 'swind_yohan_cb_pagb.sav', array
ENDIF

END
