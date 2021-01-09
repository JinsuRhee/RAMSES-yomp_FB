	;'   TIME         H       HE      C       N       O       MG      SI      S      FE         ALL NINE ELEMENTS (H THROUGH FE)'

	szgrid = ['0.0004','0.004','0.008','0.02','0.05']
	zgrid  = double(szgrid)

	@plot_setting
	device,file='SW.eps',/encap,xs=14,ys=14,/color
	xr = [1d5,1d10]
	yr = [0,0.40]
	pos = [0.16,0.12,0.96,0.96]
	xtit = 'age [yr]'
	ytit = 'total ejecta  per SSP'
	
	plot, xr,yr, xr=xr, yr=yr, /xlog, xtit=xtit, ytit=ytit, /nodata, pos=pos

	ctload_kuler,'fbk'	
	icol = [1,2,3,4,5]
	for iz=0,4 do begin
		siz = strtrim(iz+1,2)
		filename = 'm4'+siz+'/standard.yield1'
		readcol,filename,skip=7,time,H,He,C,N,O,Mg,Si,S,Fe,Msw,Msn,format='f,f,f,f,f,f,f,f,f,f,f'

	H  = 10d0^H  
   He = 10d0^He
   C  = 10d0^C 
   N  = 10d0^N 
   O  = 10d0^O 
   Mg = 10d0^Mg
   Si = 10d0^Si
   S  = 10d0^S 
   Fe = 10d0^Fe
	Msw = 10d0^Msw
	Msn = 10d0^Msn

	nn = n_elements(time)
	
	cH  = dblarr(nn)
	cHe = dblarr(nn)
	cC  = dblarr(nn)
	cN  = dblarr(nn)
	cO  = dblarr(nn)
	cMg = dblarr(nn)
	cSi = dblarr(nn)
	cS  = dblarr(nn)
	cFe = dblarr(nn)
	cMsw = dblarr(nn)
	cMsn = dblarr(nn)
	
	cX  = dblarr(nn)	
	cY  = dblarr(nn)
	cZ  = dblarr(nn)

	cZfin = dblarr(5)

	tprev = 0d0
	for i=0L,nn-1L do begin
		dt    = time[i]-tprev
		j     = i-1
		if i eq 0 then j=i
		cH [i] = cH [j] + H [i]*dt
		cHe[i] = cHe[j] + He[i]*dt
		cC [i] = cC [j] + C [i]*dt
		cN [i] = cN [j] + N [i]*dt
		cO [i] = cO [j] + O [i]*dt
		cMg[i] = cMg[j] + Mg[i]*dt
		cSi[i] = cSi[j] + Si[i]*dt
		cS [i] = cS [j] + S [i]*dt
		cFe[i] = cFe[j] + Fe[i]*dt
		cMsw[i] = cMsw[j] + Msw[i]*dt
		cMsn[i] = cMsn[j] + Msn[i]*dt

		cX[i] = cH[i]
		cY[i] = cHe[i]
		cZ[i] = cC[i] + cN[i] + cO[i] + cMg[i] + cSi[i] + cS[i] + cFe[i]	
		tprev = time[i]
	endfor

		oplot, time, cMsw/1d6 , col=icol[iz]
		oplot, time, cMsn/1d6 , col=icol[iz], linestyle=2
		oplot, time, (cMsn+cMsw)/1d6 , col=icol[iz], linestyle=1

		cZfin[iz] = max(cZ/1d6)
		print, max(cMsn)/1d6
	endfor


	item = 'Z='+szgrid
	legend, item, spacing=1.6, color=icol, psym=8,box=0,charsize=1.2
	device,/close
end	
