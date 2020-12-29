PRO ts_test
; This routine requires the Starburst99 outputs generated with galaxy_extra_field.f
	; for five different metallicities. 



	; starburst99 output prefix (ex. m41, m42, m43..)
	;------------------------------------------
	output_prefix  = 'm4'
	output_suffix  = ' '
	;------------------------------------------
	szgrid = ['0.0004','0.004','0.008','0.02','0.05']
	zgrid  = double(szgrid)
	nz     = n_elements(zgrid)
	nt_tar = 250L ; number of time bin we would to print out


	; output file
	output_file = 'swind_krp_pagb'+output_suffix+'.dat'
	;------------------------------------------
	openw,11,output_file,/f77_unform
	;------------------------------------------


	; If the mass of the indivual species is correct, we will be using those values
	; However, the summation of H-Fe yield from SNII is not the same as the total mass field from SNII.
	; Make sure which one to use.
	individual_species_correct = 0 



	spec = ['H','He','C','N','O','Mg','Si','S','Fe']
	nspec = n_elements(spec)


	for iz=0,4 do begin
		siz = strtrim(iz+1,2)
		filename = output_prefix+siz+'/standard.yield1'
		readcol,filename,skip=7,time,H1,He1,C1,N1,O1,Mg1,Si1,S1,Fe1,$
		                             H2,He2,C2,N2,O2,Mg2,Si2,S2,Fe2,Msw,Msn,Mall,/silent


		;----------------------------------------
		; Starburst99 is normalised to 10^6 Msun
		;----------------------------------------
		Msw -= 6d0
		Msn -= 6d0
		Mall -= 6d0
		for ispec = 0, nspec-1 do begin
			atom   = spec[ispec]
			; for stellar winds
			command = atom+'1 -= 6d0' ; H1 -= 6d0
			dum    = execute(command)
			; for SNII
			command = atom+'2 -= 6d0' ; H2 -= 6d0
			dum    = execute(command)
			
		endfor


		;----------------------------------------
		; make log scale to non-log
		;----------------------------------------
		Msw = 10d0^Msw
		Msn = 10d0^Msn
		Mall = 10d0^Mall

		for ispec = 0, nspec-1 do begin
			atom   = spec[ispec]
			; for stellar winds
			command = atom+'1 = 10d0^'+atom+'1' ; H1 =  10d0^H1
			dum    = execute(command)
			; for SNII
			command = atom+'2 = 10d0^'+atom+'2' ; H2 =  10d0^H2
			dum    = execute(command)
		endfor



		;----------------------------------------
		; create array for cumulative numbers
		;----------------------------------------
		nn = n_elements(time)
		cMsw = dblarr(nn)
		cMsn = dblarr(nn)
		cMall = dblarr(nn)

		cX1  = dblarr(nn)	
		cY1  = dblarr(nn)
		cZ1  = dblarr(nn)

		cX2  = dblarr(nn)	
		cY2  = dblarr(nn)
		cZ2  = dblarr(nn)

		for ispec = 0, nspec-1 do begin
			atom   = spec[ispec]
			; for stellar winds
			command = 'c'+atom+'1 = dblarr(nn)' ; cH1 = dblarr(nn)
			dum    = execute(command)
			; for SNII
			command = 'c'+atom+'2 = dblarr(nn)' ; cH2 = dblarr(nn)
			dum    = execute(command)
		endfor


		;----------------------------------------
		; collect data
		;----------------------------------------
		if iz eq 0 then begin
			; for stellar winds
			cMsw_data = dblarr(nn,nz)
			cEsw_data = dblarr(nn,nz)
			cMZsw_data = dblarr(nn,nz)
			for ispec = 0, nspec-1 do begin
				atom   = spec[ispec]
				; stellar winds
				command = 'cM'+atom+'sw_data = dblarr(nn,nz)' ; cMHsw_data = dblarr(nn,nz)
				dum    = execute(command)
				; SNII
				command = 'cM'+atom+'sn_data = dblarr(nn,nz)' ; cMHsn_data = dblarr(nn,nz)
				dum    = execute(command)
			endfor

			; for SNII
			cMsn_data = dblarr(nn,nz)
			cMZsn_data = dblarr(nn,nz)
		endif

		;----------------------------------------
		; time integration
		;----------------------------------------
		tprev = 0d0
		for i=0L,nn-1L do begin
			dt    = time[i]-tprev
			j     = i-1
			if i eq 0 then j=i

			cMsw[i] = cMsw[j] + Msw[i]*dt
			cMsn[i] = cMsn[j] + Msn[i]*dt
			cMall[i] = cMall[j] + Mall[i]*dt

			for ispec = 0, nspec-1 do begin
				atom   = spec[ispec]

				; stellar winds
				command = 'c'+atom+'1[i] = c'+atom+'1[j] + '+atom+'1[i]*dt' ; cH1 [i] = cH1 [j] + H1 [i]*dt
				dum    = execute(command)
	
				; SNII
				command = 'c'+atom+'2[i] = c'+atom+'2[j] + '+atom+'2[i]*dt' ; cH2 [i] = cH2 [j] + H2 [i]*dt
				dum    = execute(command)
			
			endfor

			cX1[i] = cH1[i]
			cY1[i] = cHe1[i]
			cZ1[i] = cC1[i] + cN1[i] + cO1[i] + cMg1[i] + cSi1[i] + cS1[i] + cFe1[i]	

			cX2[i] = cH2[i]
			cY2[i] = cHe2[i]
			cZ2[i] = cC2[i] + cN2[i] + cO2[i] + cMg2[i] + cSi2[i] + cS2[i] + cFe2[i]

				
			tprev = time[i]
		endfor


		cMZsw = cZ1

		if individual_species_correct then begin
			cMsn  = cX2 + cY2 + cZ2
			cMZsn = cZ2
			correction_factor = 1
		endif else begin
			n0 = n_elements(cMsn)
			correction_factor = cMsn[n0-1]/(cX2[n0-1] + cY2[n0-1] + cZ2[n0-1])
			cMZsn = cZ2*correction_factor

			fd = where(cMZsn gt cMZsn[n_elements(cMZsn)-1], nfd)
			if nfd gt 0 then cMZsn[fd] = cMZsn[n_elements(cMZsn)-1]
		endelse


		;----------------------------------------
		; collect the cumulative data
		;----------------------------------------
		cMsw_data[*,iz] = cMsw
		cMZsw_data[*,iz] = cMZsw
		cMsn_data[*,iz] = cMsn
		cMZsn_data[*,iz] = cMZsn
		for ispec = 0, nspec-1 do begin
			atom   = spec[ispec]

			; stellar winds
			command = 'cM'+atom+'sw_data[*,iz] = c'+atom+'1' ; cMHsw_data[*,iz] = cH1
			dum    = execute(command)
	
			; SN II
			command = 'cM'+atom+'sn_data[*,iz] = c'+atom+'2 * correction_factor' ; cMHsn_data[*,iz] = cH2 * correction_factor
			dum    = execute(command)

		endfor

		filename = output_prefix+siz+output_suffix+'/standard.power1'
		readcol,filename,skip=7,dum,dum,dum,dum,dum,dum,cEsw,/silent
		cEsw = 10d0^cEsw/1d6

		cEsw_data[*,iz] = cEsw

		;print, max(cMsn)/1d6


	endfor

	;----------------------------------------
	; make logarithmic scale 
	;----------------------------------------
	cMsw_data = alog10(cMsw_data)
	cEsw_data  = alog10(cEsw_data)
	cMZsw_data = alog10(cMZsw_data)
	cMsn_data = alog10(cMsn_data)
	cMZsn_data = alog10(cMZsn_data)
	for ispec = 0, nspec-1 do begin
		atom   = spec[ispec]

		; stellar winds
		command = 'cM'+atom+'sw_data = alog10(cM'+atom+'sw_data)' ; cMHsw_data = alog10(cMHsw_data)
		dum    = execute(command)
	
		; SNII
		command = 'cM'+atom+'sn_data = alog10(cM'+atom+'sn_data)' ; cMHsn_data = alog10(cMHsn_data) 
		dum    = execute(command)

	endfor

	time = alog10(time)
	tmin = min(time)
	tmax = max(time)
	tbin = (tmax-tmin)/double(nt_tar)
	logt = dindgen(nt_tar)*tbin + tmin

	;----------------------------------------
	; prepare data for output
	;----------------------------------------
	; only for SW
	log_cm_sw   = dblarr(nt_tar, nz)
	log_ce_sw   = dblarr(nt_tar, nz)
	log_cmz_sw   = dblarr(nt_tar, nz)
	for ispec = 0, nspec-1 do begin
		atom   = spec[ispec]

		; stellar winds
		command = 'log_cm'+atom+'_sw = dblarr(nt_tar,nz)' ; log_cmH_sw = dblarr(nt_tar,nz)
		dum    = execute(command)
	
		; SNII
		command = 'log_cm'+atom+'_sn = dblarr(nt_tar,nz)' ; log_cmH_sn = dblarr(nt_tar,nz)
		dum    = execute(command)

	endfor

	;----------------------------------------
	; linear interpolation
	;----------------------------------------
	for iz=0,nz-1 do begin
		log_cm_sw[*,iz] = interpol(cMsw_data[*,iz],time,logt)
		log_ce_sw[*,iz] = interpol(cEsw_data[*,iz],time,logt)
		log_cmz_sw[*,iz] = interpol(cMZsw_data[*,iz],time,logt)

		for ispec = 0, nspec-1 do begin
			atom   = spec[ispec]

			; stellar winds
			; log_cmH_sw[*,iz] = interpol(cMHsw_data[*,iz],time,logt)
			command  = 'log_cm'+atom+'_sw[*,iz] = '
			command += 'interpol(cM'+atom+'sw_data[*,iz],time,logt)' 
			dum    = execute(command)
	
			; SN2
			; log_cmH_sn[*,iz] = interpol(cMHsn_data[*,iz],time,logt)
			command  = 'log_cm'+atom+'_sn[*,iz] = '
			command += 'interpol(cM'+atom+'sn_data[*,iz],time,logt)' 
			dum    = execute(command)
		endfor
	endfor

	ngrid_z = n_elements(zgrid)
	ngrid_t = n_elements(logt)
	writeu,11, long(ngrid_t),long(ngrid_z)
	writeu,11, double(logt)
	writeu,11, double(alog10(zgrid))
	for iz=0,ngrid_z-1 do writeu,11, double(log_cm_sw[*,iz])
	for iz=0,ngrid_z-1 do writeu,11, double(log_ce_sw[*,iz])
	for iz=0,ngrid_z-1 do writeu,11, double(log_cmz_sw[*,iz])

	for ispec = 0, nspec-1 do begin
		atom   = spec[ispec]

		; stellar winds
		; for iz=0,ngrid_z-1 do writeu,11, double(log_cmH_sw[*,iz])
		command  = 'for iz=0,ngrid_z-1 do writeu, 11, '
		command += ' double(log_cm'+atom+'_sw[*,iz])'
		dum    = execute(command)
	endfor
	
	close, 11


	;----------------------------------------
	; sanity check
	;---------------------------------------
end	
