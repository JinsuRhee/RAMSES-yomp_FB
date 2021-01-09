#------------------------------------------------------
# Makefile for the code GALAXY
# - version Sun Solaris (1997)
#------------------------------------------------------
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
SOURCES = galaxy.f#_wonly_js.f
=======
SOURCES = galaxy_wonly_js.f
>>>>>>> 02036fc... src dir & sb99 codes
=======
SOURCES = galaxy.f#_wonly_js.f
>>>>>>> fecffcf... test
=======
SOURCES = galaxy_sntest.f#_wonly_js.f
>>>>>>> d4d10c6... sntest
=======
SOURCES = galaxy.f#_wonly_js.f
>>>>>>> 9a71537... starburst99 code updated to cover chabrier IMF and SN mass correction

OBJECTS = $(SOURCES:.f=.o)

#INCLUDES = implic.inc \
#consts_iso.inc

#------------------------------------------------------

.KEEP_STATE:
# Some more exotic compiler options:
#  -Nl350 allows for 350 continuation marks 
#  -sb    prepares database for tool SourceBrowser. Try typing 'sbrowser'...
# for debugging:
#FFLAGS = -c -g -C -sb -Nl350
#LFLAGS = -g
# for fast run:
FFLAGS = -c -O2 -ffree-line-length-none #-Nl350
LFLAGS = -O2

LIBS   = #-lV77
LINK   = gfortran 
.f.o: ; $(LINK) $(FFLAGS) $*.f

#------------------------------------------------------
galaxy: $(OBJECTS) Makefile
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy $(LIBS)
=======
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy_wonly_js $(LIBS)
>>>>>>> 02036fc... src dir & sb99 codes
=======
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy $(LIBS)
>>>>>>> fecffcf... test
=======
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy_sntest $(LIBS)
>>>>>>> d4d10c6... sntest
=======
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy $(LIBS)
>>>>>>> 9a71537... starburst99 code updated to cover chabrier IMF and SN mass correction

$(OBJECTS): $(INCLUDES)
