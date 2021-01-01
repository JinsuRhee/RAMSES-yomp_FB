PRO test3_mft, settings

	imffile	= settings.root_path + 'test/test3*/imftable.dat'
	readcol, imffile, imf_m, imf_n, format='F, F', numline=FILE_LINES(imffile)

	file	= settings.root_path + 'test/test3*/sntest.dat'
	nline	= FILE_LINES(file)
	OPENR, 10, file

	str	= ' '
	time	= DBLARR(1000)
	mass	= DBLARR(1000,1500)
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
		mass(j,k)	= DOUBLE(str(0))
		num(j,k)	= DOUBLE(str(1))

		k++
		str	= ' '

	ENDFOR
	;timeind	= [0L, 10L, 20L, 30L, 40L, 50L, 60L, 70L, 80L, 90L]*10L
	timeind	= FINDGEN(20)/19 * 400L + 590
	timeind	= LONG(timeind)
	timeind	= [0L, timeind]

	cgPlot, 0, 0, xrange=[0.1, 110.], yrange=[1e-8, 1e3], /ylog, /xlog
	FOR i=0L, N_ELEMENTS(timeind)-1L DO BEGIN
		cut	= WHERE(num(timeind(i),*) GT 0.)
		xx	= mass(timeind(i),cut)
		yy	= num(timeind(i),cut)
		;yy	= yy / max(yy)
		cgOplot, xx, yy, linestyle=0, color='red'
		PRINT, time(timeind(i))
		STOP
		cgOplot, xx, yy, linestyle=0, color='black'
	ENDFOR
	STOP

END
