PRO test2, settings

	;;-----
	;; LOAD DATA
	;;-----
	dir_save	= settings.dir_save
	RESTORE, dir_save + 'swind_s99org_kp_pagb.sav'
	js	= array
	RESTORE, dir_save + 'swind_s99ts_kp_pagb.sav'
	ts	= array
	RESTORE, dir_save + 'swind_s99orgsn_kp_pagb.sav'
	js_sn	= array
	;;-----
	;; DRAW
	;;-----
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
