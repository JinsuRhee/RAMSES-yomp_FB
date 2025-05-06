PRO p_tbltypeset, settings

	;; ssptype

	IF settings.ssptype EQ 'sb99' OR settings.ssptype EQ 'yohan' OR settings.ssptype EQ 'final' OR settings.ssptype EQ 'final_nboost' OR settings.ssptype EQ 'final_db' THEN BEGIN
		nelem	= 9L
		elemtype	= 'H, He, C, N, O, Mg, Si, S, Fe'
	ENDIF ELSE BEGIN
		STOP
	ENDELSE
	;; agb
	IF settings.tracktype EQ 'pagb' OR settings.tracktype EQ 'v0' OR settings.tracktype EQ 'v300' THEN BEGIN
		metal	= [0.0004, 0.004, 0.008, 0.020, 0.050]
		sb99_suffix	= ['m41', 'm42', 'm43', 'm44', 'm45']
	ENDIF ELSE BEGIN
		STOP
	ENDELSE
	

	;; snII
	IF settings.sntype EQ 'ww' THEN BEGIN
		sntype 	= 'WW95'
	ENDIF ELSE IF settings.sntype EQ 'wwnomc' THEN BEGIN
		sntype 	= 'WW95 (w/o remnant mass correction)'
	ENDIF ELSE IF settings.sntype EQ 'wwck' THEN BEGIN
		sntype	= 'WW95 + CK06'
	ENDIF ELSE IF settings.sntype EQ 'wwcknomc' THEN BEGIN
		sntype	= 'WW95 + CK06 (w/o remnant mass correction)'
	ENDIF ELSE IF settings.sntype EQ 'ck' THEN BEGIN
		sntype	= 'CK06 only'
	ENDIF ELSE IF settings.sntype EQ 'cknomc' THEN BEGIN
		sntype 	= 'CK06 only (w/o remnant mass correction)'
	ENDIF ELSE BEGIN
		STOP
	ENDELSE
	
	;;-----
	;; DATA DIR
	;;-----
	dir_data 	= settings.dir_save + settings.ssptype + '_' + settings.tracktype + '_' + settings.imftype + '_' + settings.sntype + '_' + settings.dusttype + '/'

	IF settings.ssptype EQ 'yohan' THEN BEGIN
		dir_data	= settings.dir_save + 'yohan_pagb_cb/' + STRTRIM(settings.tracktype,2) + '/'
	ENDIF ELSE IF settings.ssptype EQ 'final' THEN BEGIN
		dir_data	= settings.dir_save + 'final/'
	ENDIF ELSE IF settings.ssptype EQ 'final_nboost' THEN BEGIN
		dir_data	= settings.dir_save + 'final_nboost/'
	ENDIF ELSE IF settings.ssptype EQ 'final_db' THEN BEGIN
		dir_data	= settings.dir_save + 'final_db/'
	ENDIF

	;;-----
	;; MERGE
	;;-----
	settings 	= CREATE_STRUCT(settings, 'metal', metal, 'dir_data', dir_data, 'sb99_suffix', sb99_suffix, $
		'nelem', nelem)

	;;-----
	;; Make Log
	;;-----
	PRINT, '%123123-------------------'
	PRINT, '		Table Type set log'
	PRINT, ' '
	PRINT, '	SSP model		: ', STRTRIM(settings.ssptype,2)
	PRINT, '	SSP mass 		: ', 1e4, 'Msun (should be check through input files'
	PRINT, '	N_CHEMelem		: ', STRTRIM(nelem,2)
	PRINT, '	ElemType 		: ', STRTRIM(elemtype,2)
	PRINT, '	'
	PRINT, '	Stellar track 	: ', STRTRIM(settings.tracktype, 2)
	PRINT, '	Metallicity bin	: ', STRTRIM(settings.metal,2)
	PRINT, '		(Zsun = 0.02)'
	PRINT, '	'
	PRINT, '	IMF 			: ', STRTRIM(settings.imftype,2)
	PRINT, ' 	SNII yield 		: ', STRTRIM(sntype,2)
	PRINT, '	dust model 		: ', STRTRIM(settings.dusttype,2)
	PRINT, '	'
	PRINT, '%123123-------------------'
	


END
