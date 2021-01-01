PRO test3_rmtable, settings

	z=[1.0, 0.1, 0.01, 1e-4, 0.] * 0.02
	m=[12., 13., 15., 18., 20., $
		22., 25., 30., 35., 40.]

	rm	= DBLARR(N_ELEMENTS(z), N_ELEMENTS(m))

	rm(0,*)	= [1.32, 1.46, 1.43, 1.76, 2.06, 2.02, 2.07, 4.24, 7.38, 10.34]
	rm(1,*)	= [1.38, 1.31, 1.49, 1.69, 1.97, 2.12, 1.99, 2.76, 6.69, 9.13]
	rm(2,*)	= [1.40, 1.44, 1.56, 1.58, 1.98, 2.04, 1.87, 3.22, 5.41, 9.08]
	rm(3,*)	= [1.28, 1.44, 1.63, 1.61, 1.97, 2.01, 1.87, 2.89, 10.1, 13.7]
	rm(4,*)	= [1.35, 1.28, 1.53, 3.40, 4.12, 1.49, 6.36, 8.17, 12.8, 16.6]

	zdum	= [2.0] * 0.02
	FOR i=0L, N_ELEMENTS(m)-1L DO BEGIN
		x	= INTERPOL(rm(*,i), z, zdum)
		PRINT, m(i), x, format='(F5.2, 3X, F5.2)'
	ENDFOR
	STOP
	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, 0, 0, /nodata, xrange=[10., 40.], yrange=[0., 15.], $
		xtitle=['Initial Mass'], ytitle=['Remnant Mass']

	col	= ['red', 'orange', 'yellow', 'green', 'blue']

	FOR i=0L, N_ELEMENTS(z)-1L DO $
		cgOplot, m, rm(i,*), linestyle=0, color=col(i)

	cgLegend, location=[12., 13.], /data, titles=STRING(z/0.02,format='(F7.5)'), vspace=2.0, $
		symsize=0, length=0.05, color=col
	STOP

END
