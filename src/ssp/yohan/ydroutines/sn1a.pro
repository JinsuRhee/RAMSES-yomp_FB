function myfunc,X,P
  return, P[0]+P[1]*sqrt(P[2]+P[3]*X)
end

function tau_m_pado, m
  res = fltarr(n_elements(m))
  
  ;; Padovani & Matteucci (1993)
  ;; mcrit=6.6
  
  mcrit = 10.^(7.764-1.79/0.2232)*1.1
  fd = where(m ge mcrit, nfd)
  if nfd gt 0 then begin
     a0 = (1.338d0 - sqrt(1.79d0-0.2232d0*(7.764d0-alog10(m(fd)))))/0.1116d0
     res(fd) = 10d0^a0 
  endif
  
  fd = where(m lt mcrit, nfd)
  if nfd gt 0 then begin
     res(fd) = 10.^12
  endif
;	fd = where(m lt 6.6, nfd)
;	if nfd gt 0 then begin
;		res(fd) = (1.2*(m(fd))^(-1.85d0) + 0.003)*1e9
;	endif

  return, res
end
;#####################################################################
;#####################################################################
;#####################################################################
function tau_m, m
  res = fltarr(n_elements(m))
  fd  = where(m gt 8, nfd)
  if nfd gt 0 then begin
     res(fd) = 1.2*m(fd)^(-1.85) + 0.003
  endif
  
  fd = where( m le 80, nfd)
  if nfd gt 0 then begin
     res(fd) = 5*m(fd)^(-2.7) + 0.012
  endif
  
  return, res*1e9
end
;#####################################################################
;#####################################################################
;#####################################################################
function tau_m_rood,m
;used in Greggio & Renzini 1983
;derived from Rood (1972) and Becker (1979)
	
  res = fltarr(n_elements(m))
  fd  = where(m le 8, nfd)
  res[fd]=10-4.319*alog10(m[fd])+1.543*alog10(m[fd])^2d0
  
  fd  = where(m gt 8, nfd)
  if nfd gt 0 then begin
     res[fd]=10-4.319*alog10(8)+1.543*alog10(8)^2d0
  endif
  return, 10d0^res
end
;#####################################################################
;#####################################################################
;#####################################################################
function inverse, s, rmu, rml, trynum, iseed=iseed
; f=x^s
  if (rmu lt rml) then begin
     tmp=rmu
     rmu=rml
     rml=tmp
  endif
  ;; inverse method
  b = rmu^(1d0+s)/abs(1d0+s)
  c = rml^(1d0+s)/abs(1d0+s)
  a = abs(c-b)
  
  x = a*randomu(iseed,trynum) + min([b,c])
  randist = (x*abs(1d0+s))^(1d0/(1d0+s))

  return, randist
end
;#####################################################################
;#####################################################################
;#####################################################################
pro sn1a,chabrier=chabrier,revisedchabrier=revisedchabrier,bound_slope=bound_slope,alpha_slope=alpha_slope,stop=stop,nbin=nbin

  if not keyword_set(bound_slope)then begin
     bound_slope=[0.1,100.0]
     print,'Slope boundaries not specified'
     print,'-> Use: [',bound_slope(0),',',bound_slope(1),'] Msun by default',format='(A,f8.2,A,f8.2,A)'
  endif
  if not keyword_set(alpha_slope)then begin
     alpha_slope=[-2.3d0]
     print,'Slope not specified'
     print,'-> Use: ',alpha_slope(0),' by default',format='(A,f8.2,A)'
  endif
  if n_elements(bound_slope) ne n_elements(alpha_slope)+1L then begin
     print,'bound_slope must have as many elements as alpha_slope +1'
     stop
  endif
  nbslope=n_elements(bound_slope)
  mu   = bound_slope(nbslope-1L)
  ml   = bound_slope(0L)
  if not keyword_set(nbin)then nbin = 1000L
  
  ;; #####################
  M_BMa  = 16
  M_Bmi  = 3
  A_Ia   = 1
  ;; #####################

  mb   = findgen(nbin+1)*(alog10(M_BMa)-alog10(M_Bmi))/float(nbin) + alog10(M_Bmi)
  mb   = 10d0^mb
  
  if keyword_set(chabrier)then begin
     ;; Chabrier 2003
     msampling=ml+findgen(nbin)/double(nbin)*(mu-ml)
     xi_chabrier=dblarr(nbin)
     ind=where(msampling lt 1.0d0,nind)
     lmm=alog10(msampling(ind))
     xi_chabrier(ind)=0.158d0/(alog(10d0)*msampling(ind))*exp(-(lmm-alog10(0.079d0))^2d0/(2d0*0.69d0^2d0))
     mi=0.5d0*msampling(ind(nind-1L))
     ind=where(msampling ge 1.0d0)
     mi=mi+0.5d0*msampling(ind(0L))
     lmm=alog10(mi)
     xii=0.158d0/(alog(10d0)*mi)*exp(-(lmm-alog10(0.079d0))^2d0/(2d0*0.69d0^2d0)) 
     xi_chabrier(ind)=msampling(ind)^(alpha_slope(0))*(xii/mi^(alpha_slope(0)))
     renorm=int_tabulated(msampling,msampling*xi_chabrier)
     phi=dblarr(nbin)
     ind=where(mb lt 1.0d0,nind)
     if(nind ge 1L)then begin
        lmm2=alog10(mb(ind))
        phi(ind)=0.158d0/(alog(10d0)*mb(ind))*exp(-(lmm2-alog10(0.079d0))^2d0/(2d0*0.69d0^2d0))
        mi=0.5d0*mb(ind(nind-1L))
     endif
     ind=where(mb ge 1.0d0)
     phi(ind)=mb(ind)^(alpha_slope(0))*(xii/mi^(alpha_slope(0)))
     phi=phi/renorm
  endif else if keyword_set(revisedchabrier)then begin
     ;; Chabrier 2005
     msampling=ml+findgen(nbin)/double(nbin)*(mu-ml)
     xi_chabrier=dblarr(nbin)
     ind=where(msampling lt 1.0d0,nind)
     lmm=alog10(msampling(ind))
     xi_chabrier(ind)=0.093d0/(alog(10d0)*msampling(ind))*exp(-(lmm-alog10(0.200d0))^2d0/(2d0*0.55d0^2d0))
     mi=0.5d0*msampling(ind(nind-1L))
     ind=where(msampling ge 1.0d0)
     mi=mi+0.5d0*msampling(ind(0L))
     lmm=alog10(mi)
     xii=0.093d0/(alog(10d0)*mi)*exp(-(lmm-alog10(0.200d0))^2d0/(2d0*0.55d0^2d0)) 
     xi_chabrier(ind)=msampling(ind)^(alpha_slope(0))*(xii/mi^(alpha_slope(0)))
     renorm=int_tabulated(msampling,msampling*xi_chabrier)
     phi=dblarr(nbin)
     ind=where(mb lt 1.0d0,nind)
     if(nind ge 1L)then begin
        lmm2=alog10(mb(ind))
        phi(ind)=0.093d0/(alog(10d0)*mb(ind))*exp(-(lmm2-alog10(0.200d0))^2d0/(2d0*0.55d0^2d0))
        mi=0.5d0*mb(ind(nind-1L))
     endif
     ind=where(mb ge 1.0d0)
     phi(ind)=mb(ind)^(alpha_slope(0))*(xii/mi^(alpha_slope(0)))
     phi=phi/renorm
  endif else if (nbslope gt 2L) then begin
     ;; Broken power law
     msampling=ml+findgen(nbin)/double(nbin)*(mu-ml)
     xi=dblarr(nbin)
     prefactor=dblarr(nbin)
     prefactor(0L:nbin-1L)=1.0d0
     for j=0L,nbslope-2L do begin
        ind=where(msampling ge bound_slope(j) and msampling lt bound_slope(j+1),nind)
        xi(ind)=msampling(ind)^alpha_slope(j)
        if(j gt 0L)then begin
           prefactor(j)=last_xi/mm^alpha_slope(j)
           xi(ind)=prefactor(j)*xi(ind)
        endif
        if(j lt nbslope-2L)then begin
           ii=ind(nind-1L)
           mm=0.5d0*(msampling(ii)+msampling(ii+1L))
           last_xi=prefactor(j)*mm^alpha_slope(j)
        endif
        if(j eq nbslope-2L)then begin
           xi(nbin-1L)=prefactor(j)*msampling(nbin-1L)^alpha_slope(j)
        endif
     endfor
     renorm=int_tabulated(msampling,msampling*xi)
     phi=dblarr(nbin)
     for j=0L,nbslope-2L do begin
        ind=where(mb ge bound_slope(j) and mb lt bound_slope(j+1),nind)
        if(nind ge 1)then begin
           phi(ind)=prefactor(j)*mb(ind)^alpha_slope(j)
        endif
     endfor
     phi=phi/renorm
  endif else begin
     ;; Salpeter
     print,'Salpeter'
     ssal = alpha_slope(0)
     Asal = (2+ssal)/(mu^(ssal+2)-ml^(ssal+2))
     phi  = Asal*mb^ssal
  endelse

  trynum = 10000L

  nbint = 100L
  mint  = 7d0
  maxt  = 10.6d0
  logt  = findgen(nbint+1)/nbint*(maxt-mint)+mint 
  tsize = (maxt-mint)/nbint
  RIa   = dblarr(nbint+1)

  mprev = M_Bmi
  for i=0L,nbin-1L do begin
     m2    = inverse(2d0,0.,mb[i]/2d0,trynum)
     dm    = mb[i]-mprev
     logtb = alog10(tau_m_pado(m2))
     hi    = histogram(logtb,min=mint,max=maxt,binsize=tsize)
     RIa  += double(hi)*phi[i]/float(trynum)*dm
     mprev = mb[i]
  endfor
  
  
  t1 = 0d0
  for i=0L,nbint-1L do begin
     t2 = 10d0^logt[i]
     RIa[i]=RIa[i]/(t2-t1)
     t1 = t2
  endfor

  RIa = (RIa+1d-49)*1d9         ; per gigayear
	
;	window,xs=600,ys=600
;	plot, logt, alog10(RIa/max(RIa)),yr=[-4,0.2],/ys,xr=[mint,maxt],/xs
;	oplot, [10,10],[-4,1],linestyle=1	
;	oplot, [7,11],[-2,-2],linestyle=1	
		




;###### for the same time spacing with stellar wind
;	readcol, '~/Population/starburst99/swind_lookup_cmloss.dat', time, format='f'
  time =[10000.0,13183.0,17378.0,19953.0,22909.0,26303.0,30200.0,34674.0,39811.0,$
	       45709.0,52481.0,60257.0,69184.0,79434.0,91202.0,104710.,120230.,138040.,$
	       158490.,181970.,208930.,239890.,275430.,316240.,363090.,416880.,478640.,$
	       549560.,630980.,724460.,831790.,955020.,1.09650e+06,1.25900e+06,1.44550e+06,$
	       1.65960e+06,1.90550e+06,2.18780e+06,2.51200e+06,2.88410e+06,3.31140e+06,$
	       3.80210e+06,4.36530e+06,5.01210e+06,5.75470e+06,6.60720e+06,7.58610e+06,$
	       8.71000e+06,1.00000e+07,1.14820e+07,1.31830e+07,1.51360e+07,1.73790e+07,$
	       1.99540e+07,2.29100e+07,2.63040e+07,3.02010e+07,3.46760e+07,3.98130e+07,$
	       4.57120e+07,5.24840e+07,6.02600e+07,6.91870e+07,7.94380e+07,9.12070e+07,$
	       1.04720e+08,1.20230e+08,1.38040e+08,1.58490e+08,1.81970e+08,2.08930e+08,$
	       2.39880e+08,2.75420e+08,3.16220e+08,3.63070e+08,4.16850e+08,4.78610e+08,$
	       5.49510e+08,6.30910e+08,7.24380e+08,8.31690e+08,9.54900e+08,1.09640e+09,$
	       1.25880e+09,1.44530e+09,1.65940e+09,1.90520e+09,2.18740e+09,2.51150e+09,$
	       2.88350e+09,3.31070e+09,3.80110e+09,4.36420e+09,5.01080e+09,5.75310e+09,$
	       6.60530e+09,7.58390e+09,8.70740e+09,9.99730e+09,1.4e+10]
  logtref = alog10(time)

  RIa_new = interpol(alog10(RIa), logt, logtref)
  RIa_new = 10d0^RIa_new
  fd      = where(RIa_new lt 0, nfd)
  if nfd gt 0 then RIa_new(fd) = 0
  
  openw, 1, 'RIa_ssp.dat'
  nn    = n_elements(RIa_new)
  tprev = 0d0
  Rprev = 0d0
  Rcum  = 0d0
  cRIa_new = dblarr(nn)
  for i=0L, n_elements(RIa_new)-1L do begin
     if RIa_new[i] le 1d-30 then RIa_new[i]=0d0
     Rcum += (time(i)-tprev)/1d9*(RIa_new(i)+Rprev)/2d0
     if i ne 1 and i ne 3 then printf, 1, time(i), RIa_new(i), Rcum
     tprev = time(i)
     Rprev = RIa_new(i)
     cRIa_new(i) = Rcum
  endfor
  close,1
  
  window,xs=600,ys=600
  plot, time, cRIa_new,yr=[1d-5,1d-1],/ys,/xlog,/xs,/ylog,xr=[1d7,2d10],xtitle='time (yr)',ytitle='SNIa cumulative rate'
;	oplot, [10,10],[-4,1],linestyle=1	
;	oplot, [7,11],[-2,-2],linestyle=1	

  ok  = where(time ge 4d7)
  x   =  alog10(time[ok])
  y   =  alog10(cRIa_new[ok])
  ndeg =  3
  Afit = poly_fit(x,y,ndeg)
;
;	err = dblarr(n_elements(y))+1	
;	initial_guess = [-4.,1,1,1]
;	Afit = mpfitfun('myfunc',x,y,err,initial_guess,/quite)
  x   =  alog10(time)
  y = dblarr(n_elements(x))
  for ideg=0,ndeg do begin
     y[*] += Afit[ideg]*x^double(ideg)
  endfor
  oplot, 10d0^x,10d0^y ;;,color=getcolor('red',2)	
  
  if keyword_set(stop)then stop

end
