PRO sb99_cktblgen

	;z=0

	z0	= [1.57, 6.60, 4.01,0.074,0.001830,0.450,0.086,0.083,0.024,0.072]	;z=0 in Zsun
	z1	= [1.65, 6.44, 3.86,0.107,0.009,0.506,0.066,0.093,0.038,0.076]		;z=0.05
	z2	= [1.61, 6.37,4.040,0.088,0.009,0.387,0.046,0.062,0.027,0.075]		;z=0.2
	z3	= [1.60,6.160,4.300,0.108,0.048,0.222,0.030,0.078,0.039,0.087]		;z=1

	PRINT, '%123213	Z = 0 Zsun'
	PRINT, ' '
	PRINT, ' Mprog = 10. Msun'
	a	= z0(1L:*) * (10. - z0(0)) / TOTAL(z0(1L:*))
	PRINT, a
	PRINT, ' '
	PRINT, ' Mprog = 8 Msun'
	b	= z0(1L:*) * (8. - z0(0)) / TOTAL(z0(1L:*))
	PRINT, b
	PRINT, ' '


	PRINT, '%123213	Z = 0.05 Zsun'
	PRINT, ' '
	PRINT, ' Mprog = 10. Msun'
	a	= z1(1L:*) * (10. - z1(0)) / TOTAL(z1(1L:*))
	PRINT, a
	PRINT, ' '
	PRINT, ' Mprog = 8 Msun'
	b	= z1(1L:*) * (8. - z1(0)) / TOTAL(z1(1L:*))
	PRINT, b
	PRINT, ' '

	PRINT, '%123213	Z = 0.2 Zsun'
	PRINT, ' '
	PRINT, ' Mprog = 10. Msun'
	a	= z2(1L:*) * (10. - z2(0)) / TOTAL(z2(1L:*))
	PRINT, a
	PRINT, ' '
	PRINT, ' Mprog = 8 Msun'
	b	= z2(1L:*) * (8. - z2(0)) / TOTAL(z2(1L:*))
	PRINT, b
	PRINT, ' '

	PRINT, '%123213	Z = 1 Zsun'
	PRINT, ' '
	PRINT, ' Mprog = 10. Msun'
	a	= z3(1L:*) * (10. - z3(0)) / TOTAL(z3(1L:*))
	PRINT, a
	PRINT, ' '
	PRINT, ' Mprog = 8 Msun'
	b	= z3(1L:*) * (8. - z3(0)) / TOTAL(z3(1L:*))
	PRINT, b
	PRINT, ' '

END
