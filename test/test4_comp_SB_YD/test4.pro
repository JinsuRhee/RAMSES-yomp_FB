PRO test4, settings

	RESTORE, settings.dir_save + 'swind_yohan_cb_pagb.sav'
	YD	= array
	RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
	SB	= array

	;test4_draw, settings, YD, SB, $
	;	/elem, $
	;	/mass, $
	;	/eps
	ind1	= 8L
	ind2	= 10L
	cgPlot, sb.t, sb.cyield_wn(3,*,ind1), linestyle=0, /xlog, /ylog
	cgOplot, yd.v0.t, yd.v0.cyield_wn(5,*,ind2), linestyle=0, color='red'

	cgOplot, sb.t, sb.cyield_sn(3,*,ind1), linestyle=2
	cgOplot, yd.v0.t, yd.v0.cyield_sn(5,*,ind2), linestyle=2, color='red'
	STOP
END
