Pro main

	;;-----
	;; Set the paths
	;;-----

	cd, '.', current=root_path
	root_path	= root_path + '/../'

	!path	= expand_path('+' + root_path + 'src/ssp/') + ':' + !path
	!path   = expand_path('+' + root_path + 'src/sub/') + ':' + !path
	!path   = expand_path('+' + root_path + 'test/') + ':' + !path

	;;-----
	;; Read the setting list
	;;-----

	settings = 0. & file_nml = root_path + 'settings.nml'
	read_nml, settings, file=file_nml
	settings = create_struct(settings, 'root_path', root_path)

	;;-----
	;; Data processing
	;;-----
	IF settings.p_s99org_kp_pagb EQ 1L THEN p_s99org_kp_pagb, settings
	IF settings.p_s99org_cb_pagb EQ 1L THEN p_s99org_cb_pagb, settings
	IF settings.p_s99orgsn_kp_pagb EQ 1L THEN p_s99orgsn_kp_pagb, settings
	IF settings.p_s99ts_kp_pagb EQ 1L THEN p_s99ts_kp_pagb, settings
	IF settings.p_yohan EQ 1L THEN p_yohan, settings

	;;-----
	;; Main Procedures
	;;-----
	IF settings.p1_maketbl EQ 1L THEN p1_maketbl, settings
	IF settings.p2_sntable EQ 1L THEN p2_sntable, settings

	;;-----
	;; Tests
	;;-----
	IF Settings.Test1 EQ 1L THEN test1, settings
	IF Settings.Test2 EQ 1L THEN test2, settings
	IF Settings.Test3 EQ 1L THEN test3, settings
	IF Settings.Test4 EQ 1L THEN test4, settings
	IF Settings.Test5 EQ 1L THEN test5, settings
	IF Settings.Test6 EQ 1L THEN test6, settings
	IF Settings.Test7 EQ 1L THEN test7, settings
	STOP	

End
