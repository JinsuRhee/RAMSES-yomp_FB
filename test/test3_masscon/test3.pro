PRO test3, settings

	;test3_corsn, settings
	;STOP
	;test3_rmtable, settings

	;STOP
	;test3_mft, settings

	;STOP
	iz	= 4L
	;;-----
	;; LOAD TABLE
	;;-----
	fname	= settings.dir_save + 'swind_s99org_kp_pagb.sav'
	RESTORE, fname

	nt	= N_ELEMENTS(array.cyield_wn(0,*,0))
	nz	= N_ELEMENTS(array.cyield_wn(*,0,0))
	;;----
	;; SUM
	;;----
	;metal_wn	= array.cyield_wn(iz,*,*)
	;metal_wn	= REFORM(metal_wn, nt, 9)
	;metal_wn	= TOTAL(metal_wn,2)
	;mass_wn	= array.cml_wn(iz,*)
	metal_wn	= DBLARR(nt)
	mass_wn		= DBLARR(nt)

	metal_sn	= DBLARR(nt)
	mass_sn		= DBLARR(nt)

	tprev	= 0.d
	FOR i=0L, nt-1L DO BEGIN
		dt	= array.t(i) - tprev
		j	= i-1
		IF i EQ 0 THEN j=i

		mass_wn(i)	+= mass_wn(j)
		IF array.ml_wn(iz,i) GT 1.0d-29 THEN $
			mass_wn(i)	+= array.ml_wn(iz,i) * dt

		metal_wn(i)	= metal_wn(j)
		FOR k=0L, 8L DO $
			IF array.yield_wn(iz,i,k) GT 1.0d-29 THEN $
			metal_wn(i)	+= array.yield_wn(iz,i,k) * dt

		mass_sn(i)	+= mass_sn(j)
		IF array.ml_sn(iz,i) GT 1.0d-29 THEN $
			mass_sn(i)	+= array.ml_sn(iz,i) * dt
		metal_sn(i)	= metal_sn(j)
		FOR k=0L, 8L DO $
			IF array.yield_sn(iz,i,k) GT 1.0d-29 THEN $
			metal_sn(i)	+= array.yield_sn(iz,i,k) * dt

		tprev	= array.t(i)
	ENDFOR



	;;----- Wind
	;cgDisplay, 800, 800
	;!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	;cgPlot, array.t, metal_wn, linestyle=2, color='red', /xlog, /ylog, thick=3, $
	;	xtitle='Time [yr]', ytitle='Cumu- Frac-'
	;cgOplot, array.t, mass_wn, linestyle=1, color='blue', thick=3

	;STOP
	;;----- SN
	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, array.t, metal_sn, linestyle=2, color='red', /xlog, /ylog, thick=3, yrange=[1e-10, 1.], $
		xtitle='Time [yr]', ytitle='Cumu- Frac-'
	cgOplot, array.t, mass_sn, linestyle=1, color='blue', thick=3
	STOP

END
