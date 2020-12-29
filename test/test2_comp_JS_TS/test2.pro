PRO test2, settings

	;;-----
	;; READ DATA
	;;-----
	RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
	js	= array

	f_ts	= settings.root_path + 'data/starburst99_ts/kp_pagb/b50/swind_krp_pagb_bh50.dat'
	ts	= rd_tableOrg(f_ts, totalmass=1.0d0)

	;;-----
	;; DRAW
	;;-----

	;;CHEMICAL SPECIES
	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, 0, 0, /nodata, xrange=[1e4, 1e12], yrange=[1e-9, 1e0], /xlog, /ylog, $
		xtitle='Time [yr]', ytitle='Cumu- Frac-'

	FOR i=0L, 8L DO BEGIN
		cgOplot, js.t, js.cyield_wn(3,*,i), linestyle=0
		cgOplot, ts.t, ts.cyield_wn(3,*,i), linestyle=0, color='red'
	ENDFOR

	;;MASS LOSS
	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, 0, 0, /nodata, xrange=[1e4, 1e12], yrange=[1e-6, 1e0], /xlog, /ylog, $
		xtitle='Time [yr]', ytitle='Cumu- Frac-'

		cgOplot, js.t, js.cml_wn(3,*), linestyle=0
		cgOplot, ts.t, ts.cml_wn(*,3), linestyle=0, color='red'

	;;ENERGY RELEASE
	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, 0, 0, /nodata, xrange=[1e4, 1e12], yrange=[40, 51], /xlog, $
		xtitle='Time [yr]', ytitle='Mechanical Energy [erg]'

		cgOplot, js.t, js.en_wn(3,*), linestyle=0
		cgOplot, ts.t, ts.en_wn(*,3), linestyle=0, color='red'
	STOP


	iname	= settings.root_path + 'test/test2*/comp.eps'
	cgPS_open, iname, /encapsulated
	!p.charsize=2.0 & !p.font = -1 & !p.charthick=5.
	cgDisplay, 800, 800
	cgPlot, 0, 0, /nodata, xrange=[1e4, 1e11], yrange=[1e-12, 1e0], $
		xtitle='Time [yr]', ytitle='Cumula-', /xlog, /ylog, $
		position=[0.18, 0.18, 0.95, 0.95]

	cgOplot, js.t, js.cyield(3,*,0), linestyle=0, thick=5
	cgOplot, js_sn.t, js_sn.cyield(3,*,0), linestyle=1, thick=5
	cgOplot, ts.t, ts.cyield(3,*,0), linestyle=2, thick=5

	cgOplot, js.t, js.cyield(3,*,3), linestyle=0, color='orange', thick=5
	cgOplot, js_sn.t, js_sn.cyield(3,*,3), linestyle=1, color='orange', thick=5
	cgOplot, ts.t, ts.cyield(3,*,3), linestyle=2, color='orange', thick=5

	cgOplot, js.t, js.cyield(3,*,4), linestyle=0, color='green', thick=5
	cgOplot, js_sn.t, js_sn.cyield(3,*,4), linestyle=1, color='green', thick=5
	cgOplot, ts.t, ts.cyield(3,*,4), linestyle=2, color='green', thick=5

	cgOplot, js.t, js.cyield(3,*,8), linestyle=0, color='blue', thick=5
	cgOplot, js_sn.t, js_sn.cyield(3,*,8), linestyle=1, color='blue', thick=5
	cgOplot, ts.t, ts.cyield(3,*,8), linestyle=2, color='blue', thick=5

	cgText, 1e8, 1e-8, textoidl('Z = Z' + sunsymbol()), /data

	cgLegend, titles=['H', 'N', 'O', 'Fe'], colors=['black', 'orange', 'green', 'blue'], $
		location=[1e8, 1e-9], /data, vspace=2.0, length=0.0, psyms=16, charthick=5.0

	cgLegend, titles=['W/o SN', 'W/ SN'], colors=['black', 'black'], location=[1e9, 1e-9], $
		/data, vspace=2.0, length=0.05, charsize=0.0, linestyles=[0, 2], charthick=5.0

	cgPS_Close


	STOP

END
