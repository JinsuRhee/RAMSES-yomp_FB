PRO test3_corsn, settings

	;GOTO, pass
	metal   = settings.Z_s99org_kp_pagb
	fname	= settings.root_path + 'test/test3*/standard.yield1_old'

	ntime	= FILE_LINES(fname) - 7L
	nmetal  = N_ELEMENTS(metal)
	nelem   = 9L

        time    = DBLARR(ntime)
        yield_wn= DBLARR(nmetal,ntime,nelem)
        yield_sn= DBLARR(nmetal,ntime,nelem)
        ml_wn   = DBLARR(nmetal,ntime)
        ml_sn   = DBLARR(nmetal,ntime)
        en_wn   = DBLARR(nmetal,ntime)


	FOR i=0L, 0L DO BEGIN
                readcol, fname, v1, $
                        w1, w2, w3, w4, w5, w6, w7, w8, w9, $
                        s1, s2, s3, s4, s5, s6, s7, s8, s9, $
                        m1, m2, m3, m4, $
                        skipline=7L, numline=FILE_LINES(fname), $
                        format='D, ' + $
                                'D, D, D, D, D, D, D, D, D' + $
                                'D, D, D, D, D, D, D, D, D' + $
                                'D, D, D'

                time            = v1

                yield_wn(i,*,0) = w1    ;H
                yield_wn(i,*,1) = w2    ;He
                yield_wn(i,*,2) = w3    ;C
                yield_wn(i,*,3) = w4    ;N
                yield_wn(i,*,4) = w5    ;O
                yield_wn(i,*,5) = w6    ;Mg
                yield_wn(i,*,6) = w7    ;Si
                yield_wn(i,*,7) = w8    ;S
                yield_wn(i,*,8) = w9    ;Fe

                yield_sn(i,*,0) = s1    ;H
                yield_sn(i,*,1) = s2    ;He
                yield_sn(i,*,2) = s3    ;C
                yield_sn(i,*,3) = s4    ;N
                yield_sn(i,*,4) = s5    ;O
                yield_sn(i,*,5) = s6    ;Mg
                yield_sn(i,*,6) = s7    ;Si
                yield_sn(i,*,7) = s8    ;S
                yield_sn(i,*,8) = s9    ;Fe

                ml_wn(i,*)      = m1    ;mass loss by SW
                ml_sn(i,*)      = m2    ;mass loss by SN	
	ENDFOR

	nt	= ntime
	metal_wn        = DBLARR(nt)
        mass_wn         = DBLARR(nt)

        metal_sn        = DBLARR(nt)
        mass_sn         = DBLARR(nt)

	array	= {t:time, ml_wn:10^ml_wn/1e4, ml_sn:10^ml_sn/1e4, $
		yield_wn:10^yield_wn/1e4, yield_sn:10^yield_sn/1e4}
        tprev   = 0.d
	iz = 0L
        FOR i=0L, nt-1L DO BEGIN
                dt      = array.t(i) - tprev
                j       = i-1
                IF i EQ 0 THEN j=i

                mass_wn(i)      += mass_wn(j)
                IF array.ml_wn(iz,i) GT 1.0d-29 THEN $
                        mass_wn(i)      += array.ml_wn(iz,i) * dt

                metal_wn(i)     = metal_wn(j)
                FOR k=0L, 8L DO $
                        IF array.yield_wn(iz,i,k) GT 1.0d-29 THEN $
                        metal_wn(i)     += array.yield_wn(iz,i,k) * dt

                mass_sn(i)      += mass_sn(j)
                IF array.ml_sn(iz,i) GT 1.0d-29 THEN $
                        mass_sn(i)      += array.ml_sn(iz,i) * dt
                metal_sn(i)     = metal_sn(j)
                FOR k=0L, 8L DO $
                        IF array.yield_sn(iz,i,k) GT 1.0d-29 THEN $
                        metal_sn(i)     += array.yield_sn(iz,i,k) * dt

                tprev   = array.t(i)
        ENDFOR

	SAVE, filename=settings.root_path + 'test/test3*/old.sav', $
		array, metal_wn, mass_wn, metal_sn, mass_sn


	metal   = settings.Z_s99org_kp_pagb
	fname	= settings.root_path + 'test/test3*/standard.yield1_new'

	ntime	= FILE_LINES(fname) - 7L
	nmetal  = N_ELEMENTS(metal)
	nelem   = 9L

        time    = DBLARR(ntime)
        yield_wn= DBLARR(nmetal,ntime,nelem)
        yield_sn= DBLARR(nmetal,ntime,nelem)
        ml_wn   = DBLARR(nmetal,ntime)
        ml_sn   = DBLARR(nmetal,ntime)
        en_wn   = DBLARR(nmetal,ntime)


	FOR i=0L, 0L DO BEGIN
                readcol, fname, v1, $
                        w1, w2, w3, w4, w5, w6, w7, w8, w9, $
                        s1, s2, s3, s4, s5, s6, s7, s8, s9, $
                        m1, m2, m3, m4, $
                        skipline=7L, numline=FILE_LINES(fname), $
                        format='D, ' + $
                                'D, D, D, D, D, D, D, D, D' + $
                                'D, D, D, D, D, D, D, D, D' + $
                                'D, D, D'

                time            = v1

                yield_wn(i,*,0) = w1    ;H
                yield_wn(i,*,1) = w2    ;He
                yield_wn(i,*,2) = w3    ;C
                yield_wn(i,*,3) = w4    ;N
                yield_wn(i,*,4) = w5    ;O
                yield_wn(i,*,5) = w6    ;Mg
                yield_wn(i,*,6) = w7    ;Si
                yield_wn(i,*,7) = w8    ;S
                yield_wn(i,*,8) = w9    ;Fe

                yield_sn(i,*,0) = s1    ;H
                yield_sn(i,*,1) = s2    ;He
                yield_sn(i,*,2) = s3    ;C
                yield_sn(i,*,3) = s4    ;N
                yield_sn(i,*,4) = s5    ;O
                yield_sn(i,*,5) = s6    ;Mg
                yield_sn(i,*,6) = s7    ;Si
                yield_sn(i,*,7) = s8    ;S
                yield_sn(i,*,8) = s9    ;Fe

                ml_wn(i,*)      = m1    ;mass loss by SW
                ml_sn(i,*)      = m2    ;mass loss by SN	
	ENDFOR

	nt	= ntime
	metal_wn        = DBLARR(nt)
        mass_wn         = DBLARR(nt)

        metal_sn        = DBLARR(nt)
        mass_sn         = DBLARR(nt)

	array	= {t:time, ml_wn:10^ml_wn/1e4, ml_sn:10^ml_sn/1e4, $
		yield_wn:10^yield_wn/1e4, yield_sn:10^yield_sn/1e4}
        tprev   = 0.d
	iz = 0L
        FOR i=0L, nt-1L DO BEGIN
                dt      = array.t(i) - tprev
                j       = i-1
                IF i EQ 0 THEN j=i

                mass_wn(i)      += mass_wn(j)
                IF array.ml_wn(iz,i) GT 1.0d-29 THEN $
                        mass_wn(i)      += array.ml_wn(iz,i) * dt

                metal_wn(i)     = metal_wn(j)
                FOR k=0L, 8L DO $
                        IF array.yield_wn(iz,i,k) GT 1.0d-29 THEN $
                        metal_wn(i)     += array.yield_wn(iz,i,k) * dt

                mass_sn(i)      += mass_sn(j)
                IF array.ml_sn(iz,i) GT 1.0d-29 THEN $
                        mass_sn(i)      += array.ml_sn(iz,i) * dt
                metal_sn(i)     = metal_sn(j)
                FOR k=0L, 8L DO $
                        IF array.yield_sn(iz,i,k) GT 1.0d-29 THEN $
                        metal_sn(i)     += array.yield_sn(iz,i,k) * dt

                tprev   = array.t(i)
        ENDFOR

	SAVE, filename=settings.root_path + 'test/test3*/new.sav', $
		array, metal_wn, mass_wn, metal_sn, mass_sn
	PASS:
        ;;----- Wind
        ;cgDisplay, 800, 800
        ;!p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
        ;cgPlot, array.t, metal_wn, linestyle=2, color='red', /xlog, /ylog, thick=3, $
        ;        xtitle='Time [yr]', ytitle='Cumu- Frac-'
        ;cgOplot, array.t, mass_wn, linestyle=1, color='blue', thick=3

        ;STOP
        ;;----- SN

	RESTORE, settings.root_path + 'test/test3*/new.sav'
        cgDisplay, 800, 800
        !p.charsize=2.2 & !p.font = -1 & !p.charthick=1.5
        cgPlot, array.t, metal_sn, linestyle=0, color='black', /xlog, /ylog, thick=3, yrange=[1e-6, 1e0], $
                xtitle='Time [yr]', ytitle='Cumu- Frac-'
        cgOplot, array.t, mass_sn, linestyle=2, color='blue', thick=3

	STOP
	RESTORE, settings.root_path + 'test/test3*/old.sav'

        ;cgOplot, array.t, metal_sn, linestyle=2, color='orange', thick=3
        cgOplot, array.t, mass_sn, linestyle=2, color='dodger blue', thick=3
        STOP
END
