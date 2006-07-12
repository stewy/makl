#
# $Id: prog.mk,v 1.17 2006/07/12 20:16:48 tat Exp $
#
# User Variables:
# - USE_CXX     If defined use C++ compiler instead of C compiler
# - PROG        Program name.
# - OBJS        File objects that build the program.
# - LDADD       Library dependencies ...
# - LDFLAGS     ...
# - CLEANFILES  Additional clean files.
# - BIN(OWN,GRP,MODE,DIR) installation path and credentials ...
# - DESTDIR     Base installation directory.
#
# Applicable targets:
# - all, clean, install, uninstall.
#

include ../etc/map.mk

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS_c = $(SRCS:.c=.o)
OBJS_cpp = $(OBJS_c:.cpp=.o)
OBJS_cc = $(OBJS_cpp:.cc=.o)
OBJS_cxx = $(OBJS_cc:.cxx=.o)
OBJS_C = $(OBJS_cxx:.C=.o)
OBJS = $(OBJS_C)

LDS = $(PRE_LDADD) $(LDADD) $(POST_LDADD)

make$(PROG): before$(PROG) $(PROG) after$(PROG)

before$(PROG):

ifndef USE_CXX
$(PROG): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDS) $(LDFLAGS) 
else
$(PROG): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDS) $(LDFLAGS) 
endif

after$(PROG):

CLEANFILES += $(PROG) $(OBJS)

clean:
	rm -f $(CLEANFILES)

# build arguments list for '(before,real)install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip $(BINOWN)),)
    _CHOWN_ARGS = $(BINOWN)
    _INSTALL_ARGS = -o $(BINOWN)
endif
ifneq ($(strip $(BINGRP)),)
    _CHOWN_ARGS = $(join $(BINOWN), :$(BINGRP))
    _INSTALL_ARGS += -g $(BINGRP)
endif

beforeinstall:
	$(MKINSTALLDIRS) $(BINDIR)
ifneq ($(strip $(_CHOWN_ARGS)),)
	chown $(_CHOWN_ARGS) $(BINDIR)
endif

realinstall:
	$(INSTALL) $(INSTALL_COPY) $(INSTALL_STRIP) $(_INSTALL_ARGS) \
	    -m $(BINMODE) $(PROG) $(BINDIR)

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f $(BINDIR)/$(PROG)

include deps.mk
