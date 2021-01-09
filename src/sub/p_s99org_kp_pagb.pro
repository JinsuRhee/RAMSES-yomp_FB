PRO p_s99org_kp_pagb, settings

	;;-----
	;; READ TABLE FIRST
	;;-----

	dir	= settings.dir_s99org_kp_pagb
	suffix	= ['m41', 'm42', 'm43', 'm44', 'm45']
	metal	= settings.Z_s99org_kp_pagb
	IF N_ELEMENTS(suffix) NE N_ELEMENTS(metal) THEN BEGIN
		PRINT, 'metallicity bin are not consistent w/ the data'
		STOP
	ENDIF

	ntime	= FILE_LINES(dir+suffix(0) + '/standard.yield1') - 7L
	nmetal	= N_ELEMENTS(metal)
	nelem	= 9L

	time	= DBLARR(ntime)
	yield_wn= DBLARR(nmetal,ntime,nelem)
	yield_sn= DBLARR(nmetal,ntime,nelem)
	ml_wn	= DBLARR(nmetal,ntime)
	ml_sn	= DBLARR(nmetal,ntime)
	en_wn	= DBLARR(nmetal,ntime)

	FOR i=0L, N_ELEMENTS(metal)-1L DO BEGIN
		;;-----
		;; READ YIELD TABLE
		;;-----
		fname	= dir + suffix(i) + '/standard.yield1'

		readcol, fname, v1, $
			w1, w2, w3, w4, w5, w6, w7, w8, w9, $
			s1, s2, s3, s4, s5, s6, s7, s8, s9, $
			m1, m2, m3, m4, $
			skipline=7L, numline=FILE_LINES(fname), $
			format='D, ' + $
				'D, D, D, D, D, D, D, D, D' + $
				'D, D, D, D, D, D, D, D, D' + $
				'D, D, D'

		time		= v1

		yield_wn(i,*,0)	= w1    ;H
		yield_wn(i,*,1)	= w2    ;He
		yield_wn(i,*,2)	= w3    ;C
		yield_wn(i,*,3)	= w4    ;N
		yield_wn(i,*,4)	= w5    ;O
		yield_wn(i,*,5)	= w6    ;Mg
		yield_wn(i,*,6)	= w7    ;Si
		yield_wn(i,*,7)	= w8    ;S
		yield_wn(i,*,8)	= w9    ;Fe

		yield_sn(i,*,0)	= s1    ;H
		yield_sn(i,*,1)	= s2    ;He
		yield_sn(i,*,2)	= s3    ;C
		yield_sn(i,*,3)	= s4    ;N
		yield_sn(i,*,4)	= s5    ;O
		yield_sn(i,*,5)	= s6    ;Mg
		yield_sn(i,*,6)	= s7    ;Si
		yield_sn(i,*,7)	= s8    ;S
		yield_sn(i,*,8)	= s9    ;Fe

		ml_wn(i,*)	= m1	;mass loss by SW
		ml_sn(i,*)	= m2	;mass loss by SN

		;;-----
		;; READ POWER TABLE
		;;-----
		fname	= dir + suffix(i) + '/standard.power1'
		readcol, fname, v1, $
			p1, p2, p3, p4, p5, $
			e1, $
			m1, m2, m3, m4, m5, $
			skipline=7L, numline=FILE_LINES(fname), $
			format='D, ' + $
				'D, D, D, D, D, ' + $
				'D, ' + $
				'D, D, D, D, D'

		time2	= v1
		IF MAX(ABS(time - time2)) GT 0. THEN STOP

		en_wn(i,*)	= e1
	ENDFOR

	yield_wn	= 10.d^yield_wn
	yield_sn	= 10.d^yield_sn
	ml_wn		= 10.d^ml_wn
	ml_sn		= 10.d^ml_sn

	;;-----
	;; MASS CORRECTION FOR SN
	;;-----
	;;-----
	;; MAKE CUMULATIVE TABLE
	;;-----
	cyield_wn	= yield_wn * 0.d
	cyield_sn	= yield_sn * 0.d
	cml_wn		= ml_wn * 0.d
	cml_sn		= ml_sn * 0.d

	tprev	= 0.d
	FOR i=0L, ntime-1L DO BEGIN
		dt	= time(i) - tprev
		j	= i-1
		IF i EQ 0 THEN j=i

		FOR iz=0L, nmetal - 1L DO FOR ie=0L, nelem - 1L DO BEGIN
			cyield_wn(iz,i,ie)	+= cyield_wn(iz,j,ie)
			IF yield_wn(iz,i,ie) GT 1.0d-29 THEN $
				cyield_wn(iz,i,ie) += yield_wn(iz,i,ie) * dt
		ENDFOR

		FOR iz=0L, nmetal - 1L DO FOR ie=0L, nelem - 1L DO BEGIN
			cyield_sn(iz,i,ie)	+= cyield_sn(iz,j,ie)
			IF yield_sn(iz,i,ie) GT 1.0d-29 THEN $
				cyield_sn(iz,i,ie) += yield_sn(iz,i,ie) * dt
		ENDFOR

 		FOR iz=0L, nmetal - 1L DO BEGIN
			cml_wn(iz,i) += cml_wn(iz,j)
			IF ml_wn(iz,i) GT 1.0d-29 THEN $
				cml_wn(iz,i) += ml_wn(iz,i) * dt
		ENDFOR

 		FOR iz=0L, nmetal - 1L DO BEGIN
			cml_sn(iz,i) += cml_sn(iz,j)
			IF ml_sn(iz,i) GT 1.0d-29 THEN $
	 			cml_sn(iz,i) += ml_sn(iz,i) * dt
		ENDFOR

		tprev	= time(i)
	ENDFOR

	;;-----
	;; NORMALIZATION
	;;-----
	cyield_wn	= cyield_wn / 1.0d4
	cyield_sn	= cyield_sn / 1.0d4
	cml_wn		= cml_wn / 1.0d4
	cml_sn		= cml_sn / 1.0d4
	en_wn		= en_wn - 4.0d
	yield_wn	= yield_wn / 1.0d4
	yield_sn	= yield_sn / 1.0d4
	ml_wn		= ml_wn /1.0d4
	ml_sn		= ml_sn / 1.0d4

	array	= {T:time, Z:metal, cyield_wn:cyield_wn, cyield_sn:cyield_sn, $
		cml_wn:cml_wn, cml_sn:cml_sn, $
		yield_wn:yield_wn, yield_sn:yield_sn, ml_wn:ml_wn, ml_sn:ml_sn, $
		en_wn:en_wn}

	SAVE, filename=settings.dir_save + 'swind_s99org_kp_pagb.sav', array

END
