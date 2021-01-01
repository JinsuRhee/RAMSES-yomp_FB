PRO test3_mft, settings

	file	= settings.root_path + 'test/test3*/snr_nucleo.dat'
	readcol, file, snr_t, snr_m, format='F, F', numline=FILE_LINES(file)

		x	= snr_t(0)
		nn	= 0L
		nold	= N_ELEMENTS(snr_t)
		st	= DBLARR(1000)
		sm	= DBLARR(1000,3)
		ii	= 0L
		REPEAT BEGIN
			cut	= WHERE(snr_t EQ x, n1)
			nn	+= n1
			st(ii)	= snr_t(cut(0))
			sm(ii,0)= MIN(snr_m(cut))
			sm(ii,1)= MEDIAN(snr_m(cut))
			sm(ii,2)= MAX(snr_m(cut))
			ii++
			IF(N_ELEMENTS(snr_t) NE n1) THEN BEGIN
				snr_t	= snr_t(n1:*)
				snr_m	= snr_m(n1:*)
				x	= snr_t(0)
			ENDIF
		ENDREP UNTIL nn EQ nold
		st	= st(0L:ii-1)
		sm	= sm(0L:ii-1,*)

	file	= settings.root_path + 'test/test3*/wind_nucleo.dat'
	readcol, file, wind_t, wind_m, format='F, F', numline=FILE_LINES(file)

		x	= wind_t(0)
		nn	= 0L
		nold	= N_ELEMENTS(wind_t)
		wt	= DBLARR(1001)
		wm	= DBLARR(1001,3)
		ii	= 0L
		REPEAT BEGIN
			cut	= WHERE(wind_t EQ x, n1)
			nn	+= n1
			wt(ii)	= wind_t(cut(0))
			wm(ii,0)= MIN(wind_m(cut))
			wm(ii,1)= MEDIAN(wind_m(cut))
			wm(ii,2)= MAX(wind_m(cut))
			ii++
			IF(N_ELEMENTS(wind_t) NE n1) THEN BEGIN
				wind_t	= wind_t(n1:*)
				wind_m	= wind_m(n1:*)
				x	= wind_t(0)
			ENDIF
		ENDREP UNTIL nn EQ nold
		wt	= wt(0L:ii-1)
		wm	= wm(0L:ii-1,*)

	file	= settings.root_path + 'test/test3*/snr.dat'
	readcol, file, v1, v2, v3, v4, v5, v6, v7, prog_m, skipline=7, format='F, F, F, F, F, F, F, F', $
		numline=FILE_lines(file)
	prog_m	= prog_m(1L:*)

	imffile	= settings.root_path + 'test/test3*/imftable.dat'
	readcol, imffile, imf_m, imf_n, format='F, F', numline=FILE_LINES(imffile)

	file	= settings.root_path + 'test/test3*/sntest.dat'
	nline	= FILE_LINES(file)
	OPENR, 10, file

	str	= ' '
	time	= DBLARR(1000)
	mass_i	= DBLARR(1000,1500)
	mass_n	= DBLARR(1000,1500)
	num	= DBLARR(1000,1500)
	j	= -1L
	k	= 0L
	FOR i=0L, nline-1L DO BEGIN
		READF, 10, str
		IF STRPOS(str,'*') GE 0L THEN BEGIN
			k = 0
			j ++
			time(j)	= DOUBLE(STRMID(str,2,STRLEN(str)))
			str	= ' '
			CONTINUE
		ENDIF
		str	= STRSPLIT(str, '/', /extract)
		mass_i(j,k)	= DOUBLE(str(0))
		mass_n(j,k)	= DOUBLE(str(1))
		num(j,k)	= DOUBLE(str(2))

		k++
		str	= ' '

	ENDFOR
	;timeind	= [0L, 10L, 20L, 30L, 40L, 50L, 60L, 70L, 80L, 90L]*10L
	timeind	= FINDGEN(20)/19 * 400L + 590
	timeind	= LONG(timeind)
	timeind	= [0L, timeind]

	cgDisplay, 800, 800
	!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
	cgPlot, 0, 0, xrange=[0.1, 110.], yrange=[1e-8, 1e3], /ylog, /xlog, $
		xtitle='Mass', ytitle='dN / dM'
	FOR i=0L, N_ELEMENTS(timeind)-1L DO BEGIN
		cut	= WHERE(num(timeind(i),*) GT 0.)
		xx	= mass_i(timeind(i),cut)
		xx_n	= mass_n(timeind(i),cut)
		yy	= num(timeind(i),cut)
		;yy	= yy / max(yy)
		cgOplot, xx, yy, linestyle=0, color='black'
		cgOplot, xx_n, yy, linestyle=0, color='blue'
		cgOplot, [prog_m[timeind(i)], prog_m[timeind(i)]], [1e-8, 1e3], linestyle=2
		cgText, 20, 100, STRING(time(timeind(i))/1e6, format='(F8.3)') + ' Myr', $
			/data, charthick=1.5
		PRINT, time(timeind(i)), 0.334d7
			cut	= WHERE(wt GE time(timeind(i)))
			IF MAX(cut) GE 0L THEN BEGIN
				t0	= MIN(cut)
				cgOplot, [wm(t0,0), wm(t0,0)], [1e-8, 1e3], linestyle=1, color='blue'
				cgOplot, [wm(t0,1), wm(t0,1)], [1e-8, 1e3], linestyle=1, color='blue'
				cgOplot, [wm(t0,2), wm(t0,2)], [1e-8, 1e3], linestyle=1, color='blue'
			ENDIF
		STOP
		cgOplot, xx, yy, linestyle=0, color='white'
		cgOplot, xx_n, yy, linestyle=0, color='white'
		cgOplot, [prog_m[timeind(i)], prog_m[timeind(i)]], [1e-8, 1e3], linestyle=0, color='white'
		cgText, 20, 100, STRING(time(timeind(i))/1e6, format='(F8.3)') + ' Myr', $
			/data, charthick=1.5, color='white'
			IF MAX(cut) GE 0L THEN BEGIN
				t0	= MIN(cut)
				cgOplot, [wm(t0,0), wm(t0,0)], [1e-8, 1e3], linestyle=1, color='white'
				cgOplot, [wm(t0,1), wm(t0,1)], [1e-8, 1e3], linestyle=1, color='white'
				cgOplot, [wm(t0,2), wm(t0,2)], [1e-8, 1e3], linestyle=1, color='white'
			ENDIF
	ENDFOR
	STOP

END
