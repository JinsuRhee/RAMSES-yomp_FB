PRO test4, settings

	RESTORE, settings.dir_save + 'swind_yohan_cb_pagb.sav'
	YD	= array
	RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
	SB	= array

	test4_draw, settings, YD, SB, $
		/elem, $
		/mass, $
		/eps
	STOP
	cgPlot, sb.t, sb.cyield_wn(3,*,0), linestyle=0, /xlog, /ylog
	cgOplot, yd.v0.t, yd.v0.cyeld_wn(5,*,0), linestyle=0
	STOP
END
