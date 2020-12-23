#------------------------------------------------------
# Makefile for the code GALAXY
# - version Sun Solaris (1997)
#------------------------------------------------------
<<<<<<< HEAD
SOURCES = galaxy.f#_wonly_js.f
=======
SOURCES = galaxy_wonly_js.f
>>>>>>> 02036fc... src dir & sb99 codes

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
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy $(LIBS)
=======
	$(LINK) $(LFLAGS) $(OBJECTS) -o galaxy_wonly_js $(LIBS)
>>>>>>> 02036fc... src dir & sb99 codes

$(OBJECTS): $(INCLUDES)
