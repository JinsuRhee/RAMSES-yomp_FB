FUNCTION test11_rd, settings0

	n_tbl 	= N_ELEMENTS(settings0.tbl_list)
	tbl_list	= settings0.tbl_list

	data	= PTRARR(n_tbl)
	FOR i=0L, n_tbl-1L DO BEGIN
		RESTORE, '/storage6/jinsu/var/YOMP_NewFB/' + tbl_list(i) + '/table.sav'

		data(i)	= PTR_NEW(array)
		;js_stat, array.cyield_sn(1,*,0)
	ENDFOR

	RETURN, data
END

;;----- READ YOHAN's table
FUNCTION test11_yohan_sync, met_org, met_yh, org
	met_org 	= met_org/0.02
	met_yh		= met_yh/0.01345
	;PRINT, met_org
	;PRINT, met_yh

	n_met 	= N_ELEMENTS(met_org)
	n_time 	= N_ELEMENTS(org.t)

	data 	= {T:org.t, Z:met_org*0.02, cyield_wn:DBLARR(n_met, n_time, 9L), cyield_sn:DBLARR(n_met, n_time, 9L), cdyield:DBLARR(n_met, n_time, 2L), $
		cml_wn:DBLARR(n_met, n_time), cml_sn:DBLARR(n_met, n_time), $
		cdyield_wn:DBLARR(n_met, n_time, 2), cdyield_sn:DBLARR(n_met, n_time,2)}
	
	FOR i=0L, N_ELEMENTS(met_org)-1L DO BEGIN

		;; Wind
		FOR j=0L, n_time-1L DO $ ;; H
			data.cyield_wn(i,j,0)	= INTERPOL(org.cyield_wn(*,j,0), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; He
			data.cyield_wn(i,j,1)	= INTERPOL(org.cyield_wn(*,j,1), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; C
			data.cyield_wn(i,j,2)	= INTERPOL(org.cyield_wn(*,j,2), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; N
			data.cyield_wn(i,j,3)	= INTERPOL(org.cyield_wn(*,j,3), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; O
			data.cyield_wn(i,j,4)	= INTERPOL(org.cyield_wn(*,j,4), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Mg
			data.cyield_wn(i,j,5)	= INTERPOL(org.cyield_wn(*,j,7), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Si
			data.cyield_wn(i,j,6)	= INTERPOL(org.cyield_wn(*,j,8), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; S
			data.cyield_wn(i,j,7)	= INTERPOL(org.cyield_wn(*,j,9), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Fe
			data.cyield_wn(i,j,8)	= INTERPOL(org.cyield_wn(*,j,10), met_yh, met_org(i))
		
		;; SN
		FOR j=0L, n_time-1L DO $ ;; H
			data.cyield_sn(i,j,0)	= INTERPOL(org.cyield_sn(*,j,0), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; He
			data.cyield_sn(i,j,1)	= INTERPOL(org.cyield_sn(*,j,1), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; C
			data.cyield_sn(i,j,2)	= INTERPOL(org.cyield_sn(*,j,2), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; N
			data.cyield_sn(i,j,3)	= INTERPOL(org.cyield_sn(*,j,3), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; O
			data.cyield_sn(i,j,4)	= INTERPOL(org.cyield_sn(*,j,4), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Mg
			data.cyield_sn(i,j,5)	= INTERPOL(org.cyield_sn(*,j,7), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Si
			data.cyield_sn(i,j,6)	= INTERPOL(org.cyield_sn(*,j,8), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; S
			data.cyield_sn(i,j,7)	= INTERPOL(org.cyield_sn(*,j,9), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $ ;; Fe
			data.cyield_sn(i,j,8)	= INTERPOL(org.cyield_sn(*,j,10), met_yh, met_org(i))	

		;; Dust
		FOR j=0L, n_time-1L DO $
			data.cdyield(i,j,0)	= INTERPOL(org.cdyield(*,j,0), met_yh, met_org(i))	

		FOR j=0L, n_time-1L DO $ ;; Fe
			data.cdyield(i,j,1)	= INTERPOL(org.cdyield(*,j,1), met_yh, met_org(i))	

		;; Mass Loss
		FOR j=0L, n_time-1L DO $
			data.cml_wn(i,j) = INTERPOL(org.cml_wn(*,j), met_yh, met_org(i))

		FOR j=0L, n_time-1L DO $
			data.cml_sn(i,j) = INTERPOL(org.cml_sn(*,j), met_yh, met_org(i))
	ENDFOR
	
	RETURN, data
END

FUNCTION test11_yohan, settings, data
	RESTORE, '/storage6/jinsu/var/YOMP_NewFB/swind_yohan_cb_pagb.sav'

	data_yh 	= PTRARR(2)

	;; For V0
	v0 	= test11_yohan_sync(settings.metal, array.zmet, array.v0)
	v300= test11_yohan_sync(settings.metal, array.zmet, array.v300)

	data_yh(0)	= PTR_NEW(v0)
	data_yh(1)	= PTR_NEW(v300)
	array 	= v0
	SAVE, filename='/storage6/jinsu/var/YOMP_NewFB/yohan_pagb_cb/v0/table.sav', array
	array 	= v300
	SAVE, filename='/storage6/jinsu/var/YOMP_NewFB/yohan_pagb_cb/v300/table.sav', array
	RETURN, data_yh
END


;;----- Yield Comparison Comparison Figure
FUNCTION test11_yield_pos, ind, wsize, hsize, wg, hg

	pos 	= [0., 0., wsize, hsize] + [wg, hg, wg, hg]
	IF ind LE 2L THEN BEGIN
		pos 	+= [0., 1., 0., 1.] * 2./3
	ENDIF ELSE IF ind LE 5L THEN BEGIN
		pos 	+= [0., 1., 0., 1.] * 1./3
	ENDIF

	IF ind MOD 3L EQ 1L THEN BEGIN
		pos 	+= [1., 0., 1., 0.] * 1./3
	ENDIF ELSE IF ind MOD 3L EQ 2L THEN BEGIN
		pos 	+= [1., 0., 1., 0.] * 2./3 
	ENDIF
	RETURN, pos
END 
PRO test11_yield, settings, data, data_yh, met=met, ycom=ycom

	wsize	= 1./3. * 0.8
	hsize	= wsize
	wgap	= 0.04
	hgap 	= 0.04

	;; Wind Yield Fig	
	zstr 	= STRING((*data(0)).z(met) / 0.02, format='(F4.2)')
	iname	= settings.root_path + 'images/test11_WNyield_' + zstr + 'Zsun'
	IF KEYWORD_SET(ycom) THEN iname += '_ycom'
	iname	+= '.eps'
	cgPS_open, iname, /encapsulated
	cgDisplay, 1200, 1200 ; 3 X 3

	elemlist	= ['H', 'He', 'C', 'N', 'O', 'Mg', 'Si', 'S', 'Fe']
	;; H through Fe
	!p.font = -1 & !p.charsize = 0.5 & !p.charthick= 1.0
	FOR i=0L, 8L DO BEGIN
		dumx	= ALOG10((*data(0)).t)
		dumy	= [(*data(0)).cyield_wn(met, *,i), (*data(2)).cyield_wn(met, *, i), (*data(4)).cyield_wn(met, *, i)]
		dumy	= ALOG10(dumy(WHERE(dumy GT 0.)))
		yr 	= LONG([MIN(dumy), MAX(dumy)]) + [0., 1.]
		xr 	= LONG([MIN(dumx), MAX(dumx)]) + [0., 1.]

		pos 	= test11_yield_pos(i, wsize, hsize, wgap, hgap)
		
		cgPlot, 0, 0, /nodata, /noerase, xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (Cum- Mass / M' + sunsymbol() + ')'), $
			position=pos, xrange=xr, yrange=yr

		;; WW Table
		IF ~KEYWORD_SET(ycom) THEN cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cyield_wn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5 

		;; WW+CK Table
		IF ~KEYWORD_SET(ycom) THEN cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cyield_wn(met, *, i)+1e-32), color='blue', linestyle=0, thick=1.5

		;; CK Table
		cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cyield_wn(met, *, i)+1e-32), color='black', linestyle=0, thick=1.5

		;; Yohan
		IF KEYWORD_SET(ycom) THEN BEGIN
			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cyield_wn(met, *, i)+1e-32), color='cyan', linestyle=0, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cyield_wn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5
		ENDIF

		cgText, pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.9, elemlist(i), charsize=1.0, charthick=3.5, /normal

		;; DUST
		IF i EQ 2L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_wn(met,*,0)+1e-32), color='red', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(1)).t), ALOG10((*data(1)).cdyield_wn(met,*,0)+1e-32), color='red', linestyle=2, thick=3.0

				cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cdyield_wn(met,*,0)+1e-32), color='blue', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(3)).t), ALOG10((*data(3)).cdyield_wn(met,*,0)+1e-32), color='blue', linestyle=2, thick=3.0
			ENDIF

			cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cdyield_wn(met,*,0)+1e-32), color='black', linestyle=1, thick=3.0
			cgOplot, ALOG10((*data(5)).t), ALOG10((*data(5)).cdyield_wn(met,*,0)+1e-32), color='black', linestyle=2, thick=3.0

			IF KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 0)+1e-32), color='cyan', linestyle=2, thick=3.0
				cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 0)+1e-32), color='red', linestyle=2, thick=1.5
			ENDIF

		ENDIF ELSE IF i EQ 6L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_wn(met,*,1)+1e-32), color='red', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(1)).t), ALOG10((*data(1)).cdyield_wn(met,*,1)+1e-32), color='red', linestyle=2, thick=3.0

				cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cdyield_wn(met,*,1)+1e-32), color='blue', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(3)).t), ALOG10((*data(3)).cdyield_wn(met,*,1)+1e-32), color='blue', linestyle=2, thick=3.0
			ENDIF

			cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cdyield_wn(met,*,1)+1e-32), color='black', linestyle=1, thick=3.0
			cgOplot, ALOG10((*data(5)).t), ALOG10((*data(5)).cdyield_wn(met,*,1)+1e-32), color='black', linestyle=2, thick=3.0

			IF KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 1)+1e-32), color='cyan', linestyle=2, thick=3.0
				cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 1)+1e-32), color='red', linestyle=2, thick=1.5
			ENDIF
		ENDIF

		IF i EQ 0L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN $
				cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['CK06', 'WW95+CK06', 'WW95'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'blue', 'red']

			IF KEYWORD_SET(ycom) THEN $
				cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['SB99+CK06', 'Yohan (V0)', 'Yohan (V300)'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'cyan', 'red']
		ENDIF
	ENDFOR
	cgPS_close

	;; SN Yield Fig
	iname	= settings.root_path + 'images/test11_SNyield_' + zstr + 'Zsun'
	IF KEYWORD_SET(ycom) THEN iname += '_ycom'
	iname	+= '.eps'
	cgPS_open, iname, /encapsulated
	cgDisplay, 1200, 1200 ; 3 X 3

	;; H through Fe
	!p.font = -1 & !p.charsize = 0.5 & !p.charthick= 1.0
	FOR i=0L, 8L DO BEGIN
		dumx	= ALOG10((*data(0)).t)
		dumy	= [(*data(0)).cyield_sn(met, *,i), (*data(2)).cyield_sn(met, *, i), (*data(4)).cyield_sn(met, *, i)]
		dumy	= ALOG10(dumy(WHERE(dumy GT 0.)))
		yr 	= LONG([MIN(dumy), MAX(dumy)]) + [0., 1.]
		xr 	= LONG([MIN(dumx), MAX(dumx)]) + [0., 1.]

		pos 	= test11_yield_pos(i, wsize, hsize, wgap, hgap)
		
		cgPlot, 0, 0, /nodata, /noerase, xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (Cum- Mass / M' + sunsymbol() + ')'), $
			position=pos, xrange=xr, yrange=yr

		;; WW Table
		IF ~KEYWORD_SET(ycom) THEN cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cyield_sn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5 

		;; WW+CK Table
		IF ~KEYWORD_SET(ycom) THEN cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cyield_sn(met, *, i)+1e-32), color='blue', linestyle=0, thick=1.5

		;; CK Table
		cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cyield_sn(met, *, i)+1e-32), color='black', linestyle=0, thick=1.5

		;; DUST
		IF i EQ 2L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_sn(met,*,0)+1e-32), color='red', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(1)).t), ALOG10((*data(1)).cdyield_sn(met,*,0)+1e-32), color='red', linestyle=2, thick=3.0

				cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cdyield_sn(met,*,0)+1e-32), color='blue', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(3)).t), ALOG10((*data(3)).cdyield_sn(met,*,0)+1e-32), color='blue', linestyle=2, thick=3.0
			ENDIF

			cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cdyield_sn(met,*,0)+1e-32), color='black', linestyle=1, thick=3.0
			cgOplot, ALOG10((*data(5)).t), ALOG10((*data(5)).cdyield_sn(met,*,0)+1e-32), color='black', linestyle=2, thick=3.0

			IF KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 0)+1e-32), color='cyan', linestyle=2, thick=3.0
				cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 0)+1e-32), color='red', linestyle=2, thick=1.5
			ENDIF

		ENDIF ELSE IF i EQ 6L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN BEGIN
				;cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_sn(met,*,1)+1e-32), color='red', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(1)).t), ALOG10((*data(1)).cdyield_sn(met,*,1)+1e-32), color='red', linestyle=2, thick=3.0

				;cgOplot, ALOG10((*data(2)).t), ALOG10((*data(2)).cdyield_sn(met,*,1)+1e-32), color='blue', linestyle=1, thick=3.0
				cgOplot, ALOG10((*data(3)).t), ALOG10((*data(3)).cdyield_sn(met,*,1)+1e-32), color='blue', linestyle=2, thick=3.0
			ENDIF

			;cgOplot, ALOG10((*data(4)).t), ALOG10((*data(4)).cdyield_sn(met,*,1)+1e-32), color='black', linestyle=1, thick=3.0
			cgOplot, ALOG10((*data(5)).t), ALOG10((*data(5)).cdyield_sn(met,*,1)+1e-32), color='black', linestyle=2, thick=3.0

			IF KEYWORD_SET(ycom) THEN BEGIN
				cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 1)+1e-32), color='cyan', linestyle=2, thick=3.0
				cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 1)+1e-32), color='red', linestyle=2, thick=1.5
			ENDIF
		ENDIF

		;; Yohan
		IF KEYWORD_SET(ycom) THEN BEGIN
			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cyield_sn(met, *, i)+1e-32), color='cyan', linestyle=0, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cyield_sn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5
		ENDIF

		cgText, pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.9, elemlist(i), charsize=1.0, charthick=3.5, /normal
		IF i EQ 0L THEN BEGIN
			IF ~KEYWORD_SET(ycom) THEN $
				cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['CK06', 'WW95+CK06', 'WW95'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'blue', 'red']

			IF KEYWORD_SET(ycom) THEN $
				cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['SB99+CK06', 'Yohan (V0)', 'Yohan (V300)'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'cyan', 'red']
		ENDIF
	ENDFOR
	cgPS_close
END

;;-----
;; Yield FInal
;;-----
PRO test11_yield_final, settings, data_yh, met=met

	RESTORE, settings.dir_save + 'final/table.sav'
	data 	= PTRARR(1)
	data(0)	= PTR_NEW(array)
	wsize	= 1./3. * 0.8
	hsize	= wsize
	wgap	= 0.04
	hgap 	= 0.04

	;; Wind Yield Fig	
	zstr 	= STRING((*data(0)).z(met) / 0.02, format='(F4.2)')
	iname	= settings.root_path + 'images/final_WNyield_' + zstr + 'Zsun'
	IF KEYWORD_SET(ycom) THEN iname += '_ycom'
	iname	+= '.eps'
	cgPS_open, iname, /encapsulated
	cgDisplay, 1200, 1200 ; 3 X 3

	elemlist	= ['H', 'He', 'C', 'N', 'O', 'Mg', 'Si', 'S', 'Fe']
	;; H through Fe
	!p.font = -1 & !p.charsize = 0.5 & !p.charthick= 1.0
	FOR i=0L, 8L DO BEGIN
		dumx	= ALOG10((*data(0)).t)
		dumy	= [(*data(0)).cyield_wn(met, *,i)]
		dumy	= ALOG10(dumy(WHERE(dumy GT 0.)))
		yr 	= LONG([MIN(dumy), MAX(dumy)]) + [0., 1.]
		xr 	= LONG([MIN(dumx), MAX(dumx)]) + [0., 1.]

		pos 	= test11_yield_pos(i, wsize, hsize, wgap, hgap)
		
		cgPlot, 0, 0, /nodata, /noerase, xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (Cum- Mass / M' + sunsymbol() + ')'), $
			position=pos, xrange=xr, yrange=yr

		cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cyield_wn(met, *, i)+1e-32), color='black', linestyle=0, thick=1.5

		;; Yohan
		cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cyield_wn(met, *, i)+1e-32), color='cyan', linestyle=0, thick=3.0
		cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cyield_wn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5

		cgText, pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.9, elemlist(i), charsize=1.0, charthick=3.5, /normal

		;; DUST
		IF i EQ 2L THEN BEGIN
			cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_wn(met,*,0)+1e-32), color='black', linestyle=1, thick=3.0

			;; Yohan
			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 0)+1e-32), color='cyan', linestyle=2, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 0)+1e-32), color='red', linestyle=2, thick=1.5

		ENDIF ELSE IF i EQ 6L THEN BEGIN
			cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_wn(met,*,1)+1e-32), color='black', linestyle=1, thick=3.0

			;; Yohan
			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 1)+1e-32), color='cyan', linestyle=2, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 1)+1e-32), color='red', linestyle=2, thick=1.5
		ENDIF

		IF i EQ 0L THEN BEGIN
			cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['Final', 'Yohan (V0)', 'Yohan (V300)'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'cyan', 'red']
		ENDIF
	ENDFOR
	cgPS_close

	;; SN Yield Fig
	iname	= settings.root_path + 'images/final_SNyield_' + zstr + 'Zsun'
	IF KEYWORD_SET(ycom) THEN iname += '_ycom'
	iname	+= '.eps'
	cgPS_open, iname, /encapsulated
	cgDisplay, 1200, 1200 ; 3 X 3

	;; H through Fe
	!p.font = -1 & !p.charsize = 0.5 & !p.charthick= 1.0
	FOR i=0L, 8L DO BEGIN
		dumx	= ALOG10((*data(0)).t)
		dumy	= [(*data(0)).cyield_sn(met, *,i)]
		dumy	= ALOG10(dumy(WHERE(dumy GT 0.)))
		yr 	= LONG([MIN(dumy), MAX(dumy)]) + [0., 1.]
		xr 	= LONG([MIN(dumx), MAX(dumx)]) + [0., 1.]

		pos 	= test11_yield_pos(i, wsize, hsize, wgap, hgap)
		
		cgPlot, 0, 0, /nodata, /noerase, xtitle=textoidl('log (T / yr)'), ytitle=textoidl('log (Cum- Mass / M' + sunsymbol() + ')'), $
			position=pos, xrange=xr, yrange=yr

		cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cyield_sn(met, *, i)+1e-32), color='black', linestyle=0, thick=1.5

		;; DUST
		IF i EQ 2L THEN BEGIN
			cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_sn(met,*,0)+1e-32), color='black', linestyle=1, thick=3.0


			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 0)+1e-32), color='cyan', linestyle=2, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 0)+1e-32), color='red', linestyle=2, thick=1.5

		ENDIF ELSE IF i EQ 6L THEN BEGIN
			cgOplot, ALOG10((*data(0)).t), ALOG10((*data(0)).cdyield_sn(met,*,1)+1e-32), color='black', linestyle=2, thick=3.0

			cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cdyield(met, *, 1)+1e-32), color='cyan', linestyle=2, thick=3.0
			cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cdyield(met, *, 1)+1e-32), color='red', linestyle=2, thick=1.5
		ENDIF

		cgOplot, ALOG10((*data_yh(0)).t), ALOG10((*data_yh(0)).cyield_sn(met, *, i)+1e-32), color='cyan', linestyle=0, thick=3.0
		cgOplot, ALOG10((*data_yh(1)).t), ALOG10((*data_yh(1)).cyield_sn(met, *, i)+1e-32), color='red', linestyle=0, thick=1.5

		cgText, pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.9, elemlist(i), charsize=1.0, charthick=3.5, /normal
		IF i EQ 0L THEN BEGIN
			cgLegend, location=[pos(0) + (pos(2)-pos(0))*0.05, pos(1) + (pos(3)-pos(1))*0.8], titles=['Final', 'Yohan (V0)', 'Yohan (V300)'], $
				linestyle=0L, /center_sym, symsize=0., length=0.015, vspace=1.2, colors=['black', 'cyan', 'red']
		ENDIF
	ENDFOR
	cgPS_close
END
;;-----
;; Yield GCE
;;-----
PRO test11_yieldgce, settings

	RESTORE, settings.dir_save + '/gcetest/g_7_2_1.sav' ;; CK + Dust no boost
	mstar 	= 1e6
	gprop 	= gprop(1L:*)
	;;----- Mass Evolution
	cgPS_open, settings.root_path + 'images/gce_mass.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[0., 14.], yrange=[1e8, 3e12], /ylog
	cgOplot, gprop.t / 1e9, gprop.mass, linestyle=2, thick=12, color='red'
	cgOplot, gprop.t / 1e9, gprop.gasmass, linestyle=0, thick=12, color='red'
	ejecta 	= gprop.e_wind + gprop.e_snii+gprop.e_snia
	ejecta	= TOTAL(ejecta, /cumulative)
	cgOplot, gprop.t / 1e9, ejecta, linestyle=4, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[0., 14.], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save
	cgAxis, yaxis=0, ystyle=1, yrange=[1e8, 3e12], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save, /ylog
	cgPS_close

	;;----- Mass rate
	delT 	= gprop(1).t - gprop(0).t
	cgPS_open, settings.root_path + 'images/gce_massrate.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[0., 14.], yrange=[1e-1, 1e3], /ylog, $
		xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10)
	;sfr 	= (gprop.New_star*1.d) * 1e6 / delT
	ejecta 	= gprop.e_wind + gprop.e_snii+gprop.e_snia
	erate 	= ejecta / delT
	cgOplot, gprop.t / 1e9, gprop.sfr*mstar, linestyle=2, thick=12, color='red'
	cgOplot, gprop.t / 1e9, erate, linestyle=4, thick=12, color='red'
	;cgOplot, gprop.t / 1e9, gprop.e_wind / delT, linestyle=0, color='green'
	;cgOplot, gprop.t / 1e9, gprop.e_snii / delT, linestyle=0, color='blue'
	;cgOplot, gprop.t / 1e9, gprop.e_snia / delT, linestyle=0, color='orange'
	cgAxis, xaxis=0, xstyle=1, xrange=[0., 14.], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save
	cgAxis, yaxis=0, ystyle=1, yrange=[1e-1, 1e3], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save, /ylog
	cgPS_close

	;;----- Metallicity
	cgPS_open, settings.root_path + 'images/gce_metal.eps', /encapsulated
	;cgDisplay, 800, 800
	;cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[0., 14.], yrange=[1e-3, 4e0], /ylog, $
	;	xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10)
	;cgOplot, gprop.t / 1e9, gprop.Z/0.02, linestyle=2, thick=12, color='blue'
	;cgAxis, xaxis=0, xstyle=1, xrange=[0., 14.], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save
	;cgAxis, yaxis=0, ystyle=1, yrange=[1e-3, 4e0], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save, /ylog
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.charthick=3.5
	cgPlot, 0, 0, /nodata, /noerase, xstyle=1, ystyle=1, xrange=[0., 14.], yrange=[1e-3, 4e0], /ylog, position=[0.2, 0.2, 0.9, 0.9], xtitle=textoidl('Time [Gyr]'), ytitle=textoidl('Z / Z' + sunsymbol() + '')
	cgOplot, gprop.t / 1e9, gprop.Z/0.02, linestyle=0, thick=12, color='black'
	;cgAxis, xaxis=0, xstyle=1, xrange=[0., 14.], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save
	;cgAxis, yaxis=0, ystyle=1, yrange=[1e-3, 4e0], xtickn=REPLICATE(' ',10), ytickn=REPLICATE(' ',10), /save, /ylog
	cgPS_close


	FeoH	= ALOG10(gprop.yield(-1) / gprop.yield(0) / (sun.Fe / sun.X))
	CoFe 	= ALOG10(gprop.yield(2) / gprop.yield(-1) / (sun.C / sun.Fe))
	NoFe 	= ALOG10(gprop.yield(3) / gprop.yield(-1) / (sun.N / sun.Fe))
	OoFe	= ALOG10(gprop.yield(4) / gprop.yield(-1) / (sun.O / sun.Fe))
	MgoFe 	= ALOG10(gprop.yield(5) / gprop.yield(-1) / (sun.Mg/ sun.Fe))
	SioFe 	= ALOG10(gprop.yield(6) / gprop.yield(-1) / (sun.Si/ sun.Fe))
	SoFe 	= ALOG10(gprop.yield(7) / gprop.yield(-1) / (sun.S/ sun.Fe))

	CoO 	= ALOG10(gprop.yield(2) / gprop.yield(4) / (sun.C/ sun.O))
	NoO 	= ALOG10(gprop.yield(3) / gprop.yield(4) / (sun.N/ sun.O))
	OoH 	= ALOG10(gprop.yield(4) / gprop.yield(0) / (sun.O/ sun.X))
	;;----- [C/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_CoFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, CoFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [N/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_NoFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, NoFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [O/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_OoFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, OoFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [Mg/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_MgoFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, MgoFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [Si/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_SioFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, SioFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [S/Fe] vs. [Fe/H]
	cgPS_open, settings.root_path + 'images/gce_SoFe_FeoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, FeoH, SoFe, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [N/O] vs. [O/H]
	cgPS_open, settings.root_path + 'images/gce_NoO_OoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, OoH, NoO, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- [C/O] vs. [O/H]
	cgPS_open, settings.root_path + 'images/gce_CoO_OoH.eps', /encapsulated
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, xstyle=4, ystyle=4, xrange=[-3., 1.], yrange=[-1.3, 1.3]
	cgOplot, OoH, CoO, linestyle=0, thick=12, color='red'
	cgAxis, xaxis=0, xstyle=1, xrange=[-3., 1.], /save
	cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- Dust Evolution
	cgPS_open, settings.root_path + 'images/gce_dustmass2.eps', /encapsulated
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.charthick=3.5
	cgPlot, 0, 0, /nodata, /noerase, xstyle=1, ystyle=1, xrange=[0., 14.], yrange=[1e6, 1e10], position=[0.15, 0.15, 0.95, 0.95], /ylog, $
		xtitle=textoidl('Time [Gyr]'), ytitle=textoidl('Mass [M' + sunsymbol() + ']')

	cgOplot, gprop.t/1e9, gprop.dyield(0)+1e-32, linestyle=0, thick=12, color='red'
	cgOplot, gprop.t/1e9, gprop.dyield(1)+1e-32, linestyle=0, thick=12, color='blue'
	;cgAxis, xaxis=0, xstyle=1, xrange=[0., 1.], /save
	;cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close

	;;----- Dust Fraction
	cgPS_open, settings.root_path + 'images/gce_dustfrac.eps', /encapsulated
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 1.5 & !p.charthick=3.5
	cgPlot, 0, 0, /nodata, /noerase, xstyle=1, ystyle=1, xrange=[0., 14.], yrange=[1e-4, 1e0], position=[0.15, 0.15, 0.95, 0.95], /ylog, $
		xtitle=textoidl('Time [Gyr]'), ytitle=textoidl('f_{dust}')

	cgOplot, gprop.t/1e9, (gprop.dyield(0)+1e-32) / gprop.mass, linestyle=0, thick=12, color='red'
	cgOplot, gprop.t/1e9, (gprop.dyield(1)+1e-32) / gprop.mass, linestyle=0, thick=12, color='blue'
	;cgAxis, xaxis=0, xstyle=1, xrange=[0., 1.], /save
	;cgAxis, yaxis=0, ystyle=1, yrange=[-1.3, 1.3], /save
	cgPS_close
	PRINT, '^-^'
	STOP
END
PRO test11_yield_dust, settings, met=met

	RESTORE, '/storage6/jinsu/var/YOMP*/final/table.sav'
	org	= array
	RESTORE, '/storage6/jinsu/var/YOMP*/final_db/table.sav'
	db	= array

	cgPS_open, settings.root_path + 'images/final_dust_' + STRTRIM(met,2) + '.eps', /encapsulated
	!p.font = -1 & !p.charsize = 1.5 & !p.charthick = 3.5
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, /noerase, position=[0.18, 0.18, 0.95, 0.95], $
		xtitle=textoidl('log (Time / Gyr)'), ytitle=textoidl('log (Cum- Mass / M' + sunsymbol() + ')'), $
		xrange=[4., 11.], yrange=[-10., -2.]
	cgOplot, ALOG10(org.t), ALOG10(org.cdyield_wn(met,*,0)+1e-32), linestyle=0, thick=4
	cgOplot, ALOG10(db.t), ALOG10(db.cdyield_wn(met,*,0)+1e-32), linestyle=2, thick=4, color='red'
	cgPS_close
END
PRO test11_yieldCO, settings, data

	;array	= *data(4)
	RESTORE, '/storage6/jinsu/var/YOMP*/final/table.sav'
	
	FOR i=0L, N_ELEMENTS(array.z)-1L DO BEGIN
		iname	= settings.root_path + 'images/pagb_CoO_' + STRING(array.z(i)/0.02,format='(F4.2)') + '.eps'
		cgPS_open, iname, /encapsulated
		cgDisplay, 800, 800
		!p.font = -1 & !p.charsize = 1.5 & !p.charthick = 3.5
		cgPlot, 0, 0, /nodata, xrange=[1e6, 1.4e10], yrange=[-1., 1.], /xlog, position=[0.15, 0.15, 0.95, 0.95], $
			xtitle=textoidl('Time [Gyr]'), ytitle=textoidl('log N_{C}/N_{O}')
		cgOplot, array.t, ALOG10((array.cyield_wn(i,*,2) / 12.0) / (array.cyield_wn(i,*,4) / 16.0)), linestyle=0, thick=10
		cgOplot, [1e6, 2e10], [0., 0.], linestyle=1, thick=5
		cgPS_Close
	ENDFOR
	STOP
	;cgPS_open, 
END
PRO test11, settings

	;;-----
	;; TBL LIST
	;;-----
	tbl_list	= [$
		'sb99_pagb_cb_ww_dust', $
		'sb99_pagb_cb_ww_dustboost', $
		'sb99_pagb_cb_wwck_dust', $
		'sb99_pagb_cb_wwck_dustboost', $
		'sb99_pagb_cb_ck_dust', $
		'sb99_pagb_cb_ck_dustboost' $
		]

	settings 	= CREATE_STRUCT(settings, 'tbl_list', tbl_list)

	;;-----
	;;
	;;-----
	data 	= test11_rd(settings)
	data_yh = test11_yohan(settings)

	
	;;-----
	;; Yield Comparison Figure (SSP)
	;;-----

	;FOR i=0L, 4L DO test11_yield, settings, data, data_yh, met=i
	;FOR i=0L, 4L DO test11_yield, settings, data, data_yh, met=i, /ycom
	;FOR i=0L, 4L DO test11_yield_final, settings, data_yh, met=i
	;FOR i=0L, 4L DO test11_yield_dust, settings, met=i
	;STOP
	;test11_yieldCO, settings, data
	;STOP
	;;-----
	;; Yield Comparison Figure (GCE)
	;;-----
	test11_yieldgce, settings

	STOP
	;;-----
	;; Fig Set
	;;-----
	cgDisplay, 1200, 800
	wsize	= 0.85 * 0.9
	hsize	= wsize * 2./3
	wgap	= 0.02
	hgap	= 0.02
	color	= STRARR(N_ELEMENTS(tbl_list))
		color(0)	= 'red'
		color(1)	= 'blue'
		color(2)	= 'green'

	FOR i=0L, settings.nelem + 2L - 1L DO BEGIN

		x 	= PTRARR(N_ELEMENTS(tbl_list))
		y1 	= PTRARR(N_ELEMENTS(tbl_list))
		y2 	= PTRARR(N_ELEMENTS(tbl_list))

		minx = 1e10 & maxx = -1e10 & miny = minx & maxy = maxx
		FOR j=0L, N_ELEMENTS(tbl_list)-1L DO BEGIN
			x(j)	= PTR_NEW((*data(j)).t)
			y1(j)	= PTR_NEW((*data(j)).cyield_wn(1,*,i))
			y2(j)	= PTR_NEW((*data(j)).cyield_wn(3,*,i))
			minx = MIN([minx, MIN(*x(j))]) & maxx = MAX([maxx, MAX(*x(j))])
			miny = MIN([miny, MIN(*y1(j)), MIN(*y2(j))])
			maxy = MAX([maxy, MAX(*y1(j)), MAX(*y2(j))])

		ENDFOR
		minx	= LONG(ALOG10(minx))-1.
		maxx	= LONG(ALOG10(maxx))+1.
		miny	= LONG(ALOG10(miny))-1.
		maxy	= LONG(ALOG10(maxy))+1.

		JS_STAT, *y1(0) - *y1(1)

		JS_STAT, *y1(0) - *y1(2)
		CONTINUE
		cgPlot, ALOG10(*x(0)), ALOG10(*y2(0)+1e-32), linestyle=0, thick=2, color=color(0), $
			xrange=[minx, maxx], yrange=[miny, maxy], xtitle=textoidl('log (Time / yr)'), ytitle=textoidl('log (M / M' + sunsymbol() + ')'), /noerase

		cgOplot, ALOG10(*x(0)), ALOG10(*y1(0)+1e-32), linestyle=2, thick=2, color=color(0)

		FOR j=1L, N_ELEMENTS(tbl_list)-1L DO BEGIN
			cgOplot, ALOG10(*x(j)), ALOG10(*y2(j)+1e-32), linestyle=0, thick=2, color=color(j)
			cgOplot, ALOG10(*x(j)), ALOG10(*y1(j)+1e-32), linestyle=2, thick=2, color=color(j)
		ENDFOR
			STOP
	ENDFOR
	STOP
END
