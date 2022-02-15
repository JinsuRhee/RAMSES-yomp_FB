FUNCTION test9_mass, X
	IF X[0] LT 1. THEN BEGIN
		y	= 0.093 * 1.d / (ALOG(10.d) * X) * $
			EXP(-(ALOG10(x) - ALOG10(0.2))^2 / (2.d * 0.55 ^2))
	ENDIF ELSE IF X[0] GE 1. THEN BEGIN
		y	= 0.041 / ALOG(10.d) * X^(-2.3)
	ENDIF
	RETURN, y*181229.3*X
END

FUNCTION test9_num, X
	IF X[0] LT 1. THEN BEGIN
		y	= 0.093 * 1.d / (ALOG(10.d) * X) * $
			EXP(-(ALOG10(x) - ALOG10(0.2))^2 / (2.d * 0.55 ^2))
	ENDIF ELSE IF X[0] GE 1. THEN BEGIN
		y	= 0.041 / ALOG(10.d) * X^(-2.3)
	ENDIF
	RETURN, y*181229.3;*X
END

PRO test9, settings


	;;-----
	;; Make IMF
	;;-----
	mass	= DINDGEN(1000)/999. * 100. + 0.1
	y	= mass
	cut_l	= WHERE(mass LT 1.)
	cut_h	= WHERE(mass GT 1.)

	y(cut_l)= 0.093 * 1.d / (ALOG(10.d)*mass(cut_l)) * $
		EXP(-(ALOG10(mass(cut_l)) - ALOG10(0.2))^2 / (2.d*0.55^2))
	y(cut_h)= 0.041 / ALOG(10.d) * mass(cut_h)^(-2.3)

	my	= y * 0.10010010
	my	= my / TOTAL(my) * 1d6
	cut1	= WHERE(mass GT 8.)
	cut1	= cut1(0)
	PRINT, (1.d6 - TOTAL(my(0:cut1)))/1.d6
	cgPlot, mass, my, linestyle=0, /xlog, /ylog, xrange=[0.1, 110.]

	mm=[0.d]
	qsimp, 'test9_mass', 8., 50., mm
	qsimp, 'test9_num', 8., 13., nn

	PRINT, mm, nn
	STOP




END
