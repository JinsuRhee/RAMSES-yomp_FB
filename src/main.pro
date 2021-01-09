Pro main

	;;-----
	;; Set the paths
	;;-----

	cd, '.', current=root_path
	root_path	= root_path + '/../'

	!path   = expand_path('+' + root_path + 'src/sub/') + ':' + !path
	!path   = expand_path('+' + root_path + 'test/') + ':' + !path

	;;-----
	;; Read the setting list
	;;-----

	settings = 0. & file_nml = root_path + 'settings.nml'
	read_nml, settings, file=file_nml
	settings = create_struct(settings, 'root_path', root_path)

	;;-----
	;; Main Procedures
	;;-----

	;;-----
	;; Tests
	;;-----
	if Settings.Test1 eq 1L then test1, settings
	STOP	

End
