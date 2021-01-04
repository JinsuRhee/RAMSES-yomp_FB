PRO test4_epsopen, iname, close=close, open=open
	IF KEYWORD_SET(open) THEN cgPS_open, iname, /encapsulated
	IF KEYWORD_SET(close) THEN cgPS_close
END

;;;;;;

PRO test4_draw_fr, xr, yr

	cgDisplay, 800, 800
	!p.font = -1 & !p.charsize=1.7 & !p.charthick=3.0;1.5;3.0

	cgPlot, xr, yr, xrange=xr, yrange=yr, /xlog, /ylog, $
		xtitle='Time [yr]', ytitle='Cum- Frac-', /nodata, $
		position=[0.15, 0.15, 0.95, 0.95]
END

;;;;;

PRO test4_draw_act, x_sb, y_sb_wn, y_sb_sn, x_yd_v0, y_yd_wn_v0, y_yd_sn_v0, $
	x_yd_v300, y_yd_wn_v300, y_yd_sn_v300

	cgOplot, x_sb, y_sb_wn + y_sb_sn, linestyle=0, thick=5
	cgOplot, x_sb, y_sb_wn, linestyle=1, thick=5
	cgOplot, x_sb, y_sb_sn, linestyle=2, thick=5

	cgOplot, x_yd_v0, y_yd_wn_v0 + y_yd_sn_v0, linestyle=0, thick=5, color='red'
	cgOplot, x_yd_v0, y_yd_wn_v0, linestyle=1, thick=10, color='red'
	cgOplot, x_yd_v0, y_yd_sn_v0, linestyle=2, thick=5, color='red'

	cgOplot, x_yd_v300, y_yd_wn_v300 + y_yd_sn_v300, linestyle=0, thick=5, color='blue'
	cgOplot, x_yd_v300, y_yd_wn_v300, linestyle=1, thick=10, color='blue'
	cgOplot, x_yd_v300, y_yd_sn_v300, linestyle=2, thick=5, color='blue'
END

;;;;;

PRO test4_draw_leg, xr, yr
	xr	= ALOG10(xr)
	yr	= ALOG10(yr)
	pos	= [xr(0) + (xr(1) - xr(0))*0.6, yr(0) + (yr(1) - yr(0))*0.4]
	pos2	= [xr(0) + (xr(1) - xr(0))*0.6, yr(0) + (yr(1) - yr(0))*0.2]
	pos	= 10^pos
	pos2	= 10^pos2
	xr	= 10^xr
	yr	= 10^yr
	cgLegend, location=pos, $
		titles=['SB99', 'YD_v0', 'YD_v300'], $
		color=['black', 'red', 'blue'], length=0.05, symsize=0., /center_sym, $
		/data, charsize=2.0, vspace=2.5, charthick=3.0
	cgLegend, location=pos2, $
		titles=['All', 'Wind', 'SN'], length=0.05, symsize=0., /center_sym, $
		vspace=2.5, linestyles=[0, 1, 2], /data, charsize=2.0, charthick=3.0
END

;;;;;

PRO test4_draw, settings, YD, SB, $
	mass=mass, eps=eps, elem=elem

IF KEYWORD_SET(mass) THEN BEGIN
	iname	= settings.root_path + 'test/test4*/massloss.eps'
	xr	= [1e4, 1e12]
	yr	= [1e-5, 1e0]
	x_sb	= sb.t
	y_sb_wn = sb.cml_wn(3,*)
	y_sb_sn = sb.cml_sn(3,*)

	x_yd_v0		= yd.v0.t
	y_yd_wn_v0	= (yd.v0.cml_wn(5,*) + yd.v0.cml_wn(6,*))/2.
	y_yd_sn_v0	= (yd.v0.cml_sn(5,*) + yd.v0.cml_sn(6,*))/2.

	x_yd_v300		= yd.v300.t
	y_yd_wn_v300	= (yd.v300.cml_wn(5,*) + yd.v300.cml_wn(6,*))/2.
	y_yd_sn_v300	= (yd.v300.cml_sn(5,*) + yd.v300.cml_sn(6,*))/2.
	IF KEYWORD_SET(eps) THEN test4_epsopen, iname, /open

		test4_draw_fr, xr, yr
		test4_draw_act, x_sb, y_sb_wn, y_sb_sn, x_yd_v0, y_yd_wn_v0, y_yd_sn_v0, $
			x_yd_v300, y_yd_wn_v300, y_yd_sn_v300

		test4_draw_leg, xr, yr
	IF KEYWORD_SET(eps) THEN test4_epsopen, /close
ENDIF

IF KEYWORD_SET(elem) THEN BEGIN
	elemlist	= ['H', 'He', 'C', 'N', 'O', 'Mg', 'Si', 'S', 'Fe']

	i=-1L
	elemstart:
	i++

	iname	= settings.root_path + 'test/test4*/' + $
		STRTRIM(elemlist(i),2) + '.eps'
	xr	= [1e4, 1e12]
	yr	= [1e-5, 1e0]
		IF elemlist(i) EQ 'C' THEN yr = [1e-6, 1e-1]
		IF elemlist(i) EQ 'N' THEN yr = [1e-7, 1e-2]
		IF elemlist(i) EQ 'O' THEN yr = [1e-6, 1e-1]
		IF elemlist(i) EQ 'Mg' THEN yr = [1e-7, 1e-2]
		IF elemlist(i) EQ 'Si' THEN yr = [1e-7, 1e-2]
		IF elemlist(i) EQ 'S' THEN yr = [1e-7, 1e-2]
		IF elemlist(i) EQ 'Fe' THEN yr = [1e-7, 1e-2]

	x_sb	= sb.t
	y_sb_wn = sb.cyield_wn(3,*,i)
	y_sb_sn = sb.cyield_sn(3,*,i)

	cut	= WHERE(settings.p_yohan_elemlist EQ elemlist(i))
	x_yd_v0		= yd.v0.t
	y_yd_wn_v0	= (yd.v0.cyield_wn(5,*,cut) + yd.v0.cyield_wn(6,*,cut))/2.
	y_yd_sn_v0	= (yd.v0.cyield_sn(5,*,cut) + yd.v0.cyield_sn(6,*,cut))/2.

	x_yd_v300		= yd.v300.t
	y_yd_wn_v300	= (yd.v300.cyield_wn(5,*,cut) + yd.v300.cyield_wn(6,*,cut))/2.
	y_yd_sn_v300	= (yd.v300.cyield_sn(5,*,cut) + yd.v300.cyield_sn(6,*,cut))/2.

	IF KEYWORD_SET(eps) THEN test4_epsopen, iname, /open

		test4_draw_fr, xr, yr
		test4_draw_act, x_sb, y_sb_wn, y_sb_sn, x_yd_v0, y_yd_wn_v0, y_yd_sn_v0, $
			x_yd_v300, y_yd_wn_v300, y_yd_sn_v300

		test4_draw_leg, xr, yr
	IF KEYWORD_SET(eps) THEN test4_epsopen, /close

	IF KEYWORD_SET(elem) AND i LT N_ELEMENTS(elemlist)-1 THEN GOTO, elemstart
ENDIF
END
