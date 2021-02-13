


FUNCTION test8_rd, settings
	RESTORE, settings.dir_save + 'swind_s99org_cb_pagb.sav'
	RETURN, array
END

;;--------------------------------------------------
;; Main
;;--------------------------------------------------
PRO test8, settings

	data	= test8_rd(settings)

	zind	= 0L
	mgind	= 5L
	oind	= 4L

	sunX	= 0.7323
	sunY	= 0.2477
	sunZ	= 0.02
		sunMg	= 0.0486535D0 * sunZ
		sunO	= 0.39389979d0 * sunZ

	W_MgoH	= ALOG10(data.cyield_wn(zind,*,mgind) / data.cyield_wn(zind,*,0) / (sunMg/sunX))
	W_OoH	= ALOG10(data.cyield_wn(zind,*,oind) / data.cyield_wn(zind,*,0) / (sunO/sunX))

	cut	= WHERE(data.cyield_sn(zind,*,mgind) GT 0.)
	S_MgoH	= ALOG10(data.cyield_sn(zind,cut,mgind) / data.cyield_sn(zind,cut,0) / (sunMg/sunX))
	S_OoH	= ALOG10(data.cyield_sn(zind,cut,oind) / data.cyield_sn(zind,cut,0) / (sunO/sunX))

	T_MgoH	= ALOG10($
		(data.cyield_wn(zind,*,mgind) + data.cyield_sn(zind,*,mgind))/$
		(data.cyield_wn(zind,*,0) + data.cyield_sn(zind,*,0))/(sunMg/sunX))

	T_OoH	= ALOG10($
		(data.cyield_wn(zind,*,oind) + data.cyield_sn(zind,*,oind))/$
		(data.cyield_wn(zind,*,0) + data.cyield_sn(zind,*,0))/(sunO/sunX))

	cgPlot, data.t, W_MgoH, linestyle=2, color='orange', $
		/xlog, yrange=[-2, 2], thick=2.0
	cgOplot, data.t, W_OoH, linestyle=2, color='green', thick=2.0

	cgOplot, data.t(cut), S_MgoH, color='orange', linestyle=3, thick=3.0
	cgOplot, data.t(cut), S_OoH, color='green', linestyle=3, thick=3.0

	cgOplot, data.t, T_MgoH, linestyle=0, color='orange', thick=2.0
	cgOplot, data.t, T_OoH, linestyle=0, color='green', thick=2.0

	;cgPlot, data.t(cut), (data.cyield_wn(zind,cut,mgind) + data.cyield_sn(zind,cut,mgind))/ (data.cyield_wn(zind,cut,-1) + data.cyield_sn(zind,cut,-1)), /xlog, /ylog
	;zind	= 4L
	;cgoPlot, data.t(cut), (data.cyield_wn(zind,cut,mgind) + data.cyield_sn(zind,cut,mgind))/ (data.cyield_wn(zind,cut,-1) + data.cyield_sn(zind,cut,-1)), color='red'
	zind	= 0L
	cgPlot, data.t(cut), (data.cyield_sn(zind,cut,oind))/ (data.cyield_sn(zind,cut,-1)), /xlog, /ylog
	zind	= 4L
	cgoPlot, data.t(cut), (data.cyield_sn(zind,cut,oind))/ (data.cyield_sn(zind,cut,-1)), color='red'
	Stop
END
