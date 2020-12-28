PRO p_s99orgsn_kp_pagb, settings

	;;-----
	;; READ TABLE FIRST
	;;-----

	dir	= settings.dir_s99orgsn_kp_pagb
	suffix	= ['m41_sn', 'm42_sn', 'm43_sn', 'm44_sn', 'm45_sn']
	metal	= settings.Z_s99orgsn_kp_pagb
	IF N_ELEMENTS(suffix) NE N_ELEMENTS(metal) THEN BEGIN
		PRINT, 'metallicity bin are not consistent w/ the data'
		STOP
	ENDIF

	ntime	= FILE_LINES(dir+suffix(0) + '/standard.yield1') - 7L
	nmetal	= N_ELEMENTS(metal)
	nelem	= 9L

	time	= DBLARR(ntime)
	yield	= DBLARR(nmetal,ntime, nelem)
	ml	= DBLARR(nmetal,ntime)

	FOR i=0L, N_ELEMENTS(metal)-1L DO BEGIN
		fname	= dir + suffix(0) + '/standard.yield1'

		readcol, fname, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, skipline=7L, $
			numline=FILE_LINES(fname), format='D, D, D, D, D,  D, D, D, D, D,  D, D, D'

		time		= v1
		yield(i,*,0)	= v2	;H
		yield(i,*,1)	= v3	;He
		yield(i,*,2)	= v4	;C
		yield(i,*,3)	= v5	;N
		yield(i,*,4)	= v6	;O
		yield(i,*,5)	= v7	;Mg
		yield(i,*,6)	= v8	;Si
		yield(i,*,7)	= v9	;S
		yield(i,*,8)	= v10	;Fe
		ml(i,*)		= v13	;mass loss
	ENDFOR

	yield	= 10.d^yield
	ml	= 10.d^ml
	;;-----
	;; MAKE CUMULATIVE TABLE
	;;-----
	cyield	= yield * 0.
	cml	= ml * 0.

	tprev	= 0.d
	FOR i=0L, ntime-1L DO BEGIN
		dt	= time(i) - tprev
		j	= i-1
		IF i EQ 0 THEN j=i
		FOR iz=0L, nmetal - 1L DO FOR ie=0L, nelem - 1L DO $
		       cyield(iz,i,ie) = cyield(iz,j,ie) + yield(iz,i,ie) * dt

 		FOR iz=0L, nmetal - 1L DO $
	 		cml(iz,i) = cml(iz,j) + ml(iz,i)

		tprev	= time(i)
	ENDFOR

	cyield	= cyield / 1.0d4
	cml	= cml / 1.0d4



	array	= {T:time, Z:metal, cyield:cyield, cmassloss:cml}

	SAVE, filename=settings.dir_save + 'swind_s99orgsn_kp_pagb.sav', array

	STOP

END
