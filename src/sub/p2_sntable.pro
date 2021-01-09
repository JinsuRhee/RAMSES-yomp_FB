PRO p2_sntable, settings

	IF settings.p2_tbltype EQ 's99org_kp' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_s99org_kp_pagb.sav'
	ENDIF ELSE IF settings.p2_tbltype EQ 's99org_cb' THEN BEGIN
		RESTORE, settings.dir_save + 'swind_s99org_cb_pagb.sav'
	ENDIF ELSE BEGIN
		PRINT, 'TABLE HAS NOT BEEN IMPLEMENTED YET'
		DOC_LIBRARY, 'p2_sntable'
		STOP
	ENDELSE

	log_SNII_m	= ALOG10(array.cml_sn(*,-1))
	log_Zgrid	= ALOG10(array.z)

		cyield_sn	= array.cyield_sn(*,-1,2:*)
	log_SNII_z	= ALOG10(TOTAL(cyield_sn,3)) - log_SNII_m

	log_SNII_H	= ALOG10(array.cyield_sn(*,-1,0)) - log_SNII_m
	log_SNII_He	= ALOG10(array.cyield_sn(*,-1,1)) - log_SNII_m
	log_SNII_C	= ALOG10(array.cyield_sn(*,-1,2)) - log_SNII_m
	log_SNII_N	= ALOG10(array.cyield_sn(*,-1,3)) - log_SNII_m
	log_SNII_O	= ALOG10(array.cyield_sn(*,-1,4)) - log_SNII_m
	log_SNII_Mg	= ALOG10(array.cyield_sn(*,-1,5)) - log_SNII_m
	log_SNII_Si	= ALOG10(array.cyield_sn(*,-1,6)) - log_SNII_m
	log_SNII_S	= ALOG10(array.cyield_sn(*,-1,7)) - log_SNII_m
	log_SNII_Fe	= ALOG10(array.cyield_sn(*,-1,8)) - log_SNII_m

	dum	= [ 'log_SNII_m =(/', $
		 'log_Zgrid  =(/', $
		 'log_SNII_Z =(/', $
		 'log_SNII_H =(/', $
		 'log_SNII_He=(/', $
		 'log_SNII_C =(/', $
		 'log_SNII_N =(/', $
		 'log_SNII_O =(/', $
		 'log_SNII_Mg=(/', $
		 'log_SNII_Si=(/', $
		 'log_SNII_S =(/', $
		 'log_SNII_Fe=(/']

	PRINT, '--------------------------------------------------------------------------'
	PRINT, '-------------------------------  SN TABLE  -------------------------------'
	PRINT, '--------------------------------------------------------------------------'
	dum2	= [',',',',',',',','/)']
	FOR i=0L, N_ELEMENTS(log_Zgrid)-1L DO BEGIN
		dum(0)	= dum(0) + STRING(log_SNII_m(i),format='(F11.8)') + dum2(i)
		dum(1)	= dum(1) + STRING(log_Zgrid(i),format='(F11.8)') + dum2(i)
		dum(2)	= dum(2) + STRING(log_SNII_z(i),format='(F11.8)') + dum2(i)
		dum(3)	= dum(3) + STRING(log_SNII_H(i),format='(F11.8)') + dum2(i)
		dum(4)	= dum(4) + STRING(log_SNII_He(i),format='(F11.8)') + dum2(i)
		dum(5)	= dum(5) + STRING(log_SNII_C(i),format='(F11.8)') + dum2(i)
		dum(6)	= dum(6) + STRING(log_SNII_N(i),format='(F11.8)') + dum2(i)
		dum(7)	= dum(7) + STRING(log_SNII_O(i),format='(F11.8)') + dum2(i)
		dum(8)	= dum(8) + STRING(log_SNII_Mg(i),format='(F11.8)') + dum2(i)
		dum(9)	= dum(9) + STRING(log_SNII_Si(i),format='(F11.8)') + dum2(i)
		dum(10)	= dum(10)+ STRING(log_SNII_S(i),format='(F11.8)') + dum2(i)
		dum(11)	= dum(11)+ STRING(log_SNII_Fe(i),format='(F11.8)') + dum2(i)
	ENDFOR

	FOR j=0L, N_ELEMENTS(dum)-1L DO PRINT, dum(j)
	PRINT, ' '
	PRINT, ' '
	PRINT, '--------------------------------------------------------------------------'
	STOP
END
