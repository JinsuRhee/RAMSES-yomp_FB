	;'   TIME         H       HE      C       N       O       MG      SI      S      FE         ALL NINE ELEMENTS (H THROUGH FE)'

	readcol,'*yield*',skip=7,time,H,He,C,N,O,Mg,Si,S,Fe,format='f,f,f,f,f,f,f,f,f,f'

	H  = 10d0^H  
   He = 10d0^He
   C  = 10d0^C 
   N  = 10d0^N 
   O  = 10d0^O 
   Mg = 10d0^Mg
   Si = 10d0^Si
   S  = 10d0^S 
   Fe = 10d0^Fe

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
	
	cX  = dblarr(nn)	
	cY  = dblarr(nn)
	cZ  = dblarr(nn)

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


		cX[i] = cH[i]
		cY[i] = cHe[i]
		cZ[i] = cC[i] + cN[i] + cO[i] + cMg[i] + cSi[i] + cS[i] + cFe[i]	
		tprev = time[i]
	endfor


	plot, time, [cX+cY+cZ]/1d6 , /xlog
	oplot, time, cZ/1d6

end	
