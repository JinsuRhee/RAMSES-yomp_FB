PRO test5, settings

	;;-----
	;; File
	;;----
	;file	= settings.root_path + 'test/test5*/imf2.dat'
	file	= settings.root_path + 'test/test5*/imf1.dat'

	;;-----
	;; READ
	;;-----
	readcol, file, m1, d_org, d_js, format='(F, F, F)', numline=FILE_LINES(file), /silent

	m1	= REVERSE(m1)
	d_org	= REVERSE(d_org)
	d_js	= REVERSE(d_js)

	;;-----
	;; ANALYSIS
	;;-----
	dx	= m1*0.d
	FOR i=0L, N_ELEMENTS(m1)-1L DO BEGIN
		IF i EQ 0L OR I EQ N_ELEMENTS(m1)-1L THEN CONTINUE
		dx(i)	= (m1(i+1) - m1(i-1))/2.
	ENDFOR
	dx(0) = (m1(1)+m1(0))*0.5 - m1(0)
	dx(-1) = m1(-1) - (m1(-1)+m1(-2))*0.5

	;;-----
	;; Chabrier IMF Test
	;;-----
	mass	= DINDGEN(1000)/999. * 100. + 0.1
	y	= mass
	cut_low	= WHERE(mass LT 1.)
	cut_high= WHERE(mass GE 1.)
	;y(cut_low)	= 0.158 * 1.d/(ALOG(10.d)*mass(cut_low))*$
	;	EXP(-(ALOG10(mass(cut_low)) -ALOG10(0.08))^2 / (2.d*0.69^2))
	;y_k	= 0.158 * 1.d/(ALOG(10.d)*1.d) * $
	;	EXP(-(-ALOG10(0.08))^2 / (2.d*0.69^2))
	;y(cut_high)	= y_k * mass(cut_high)^(-2.3)
	y(cut_low)	= 0.093 * 1.d/(ALOG(10.d)*mass(cut_low))*$
		EXP(-(ALOG10(mass(cut_low)) - ALOG10(0.2))^2 / (2.d*0.55^2))
	y(cut_high)	= 0.041 / ALOG(10.d) * mass(cut_high)^(-2.3)

	y	= y/TOTAL(y*mass) * 10000.d
	;y	= y* 1000.d / TOTAL(y* (100./1000.) * mass)

	;;-----
	;; Kroupa
	;;-----
	y2	= y
	cut_low	= WHERE(mass LT 0.5)
	cut_high= WHERE(mass GE 0.5)
	y2(cut_low)	= mass(cut_low)^(-1.3)
	y2(cut_high)	= mass(cut_high)^(-2.3) * 0.5
	y2	= y2/TOTAL(y2*mass) * 10000.d
	;;-----
	;; DRAW
	;;-----

	cgPlot, mass, y2, linestyle=0, /xlog, /ylog, xrange=[0.1, 110]
	cgOplot, mass, y, linestyle=0, color='red'
	;cgOplot, m1, d_js/dx, linestyle=0, color='red'
	;cgOplot, m1, d_js*1000.d, linestyle=0, color='red'
	;cgOplot, m1, d_js/dx, linestyle=0, color='red'

	;cgOplot, mass, y/0.1, linestyle=0, color='blue'
	STOP
END
