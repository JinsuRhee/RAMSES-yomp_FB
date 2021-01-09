PRO test6, settings

	RESTORE, '/storage6/jinsu/var/YOMP*/swind_s99org_kp_pagb.sav'
	kp	= array

	RESTORE, '/storage6/jinsu/var/YOMP*/swind_s99org_cb_pagb.sav'
	cb	= array

	iz	= 3L
	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize = 2.0
	cgPlot, kp.t, kp.cyield_wn(iz,*,8), linestyle=0, /xlog, /ylog
	cgOplot, cb.t, cb.cyield_wn(iz,*,8), linestyle=0, color='red'

	cgPlot, kp.t, kp.cml_sn(iz,*), linestyle=0, /xlog, /ylog
	STOP
	cgOplot, cb.t, cb.cml_sn(iz,*), color='red', linestyle=0
	STOP

END
