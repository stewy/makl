#
# $Id: incs.mk,v 1.19 2007/06/21 15:20:43 tho Exp $
#
# Only define the install and uninstall targets.
#
# - INCS        the list of header files to install.
#

include ../etc/map.mk

##
## all target (nothing but hooks)
##
ifndef NO_ALL
all: all-hook-pre all-hook-post
all-hook-pre all-hook-post:
else
all:
endif

##
## clean target (nothing but hooks)
##
ifndef NO_CLEAN
clean: clean-hook-pre clean-hook-post
clean-hook-pre clean-hook-post:
else
clean:
endif

##
## depend target (nothing but hooks)
##
ifndef NO_DEPEND
depend: depend-hook-pre depend-hook-post
depend-hook-pre depend-hook-post:
else
depend:
endif

##
## cleandepend target (nothing but hooks)
##
ifndef NO_CLEANDEPEND
cleandepend: cleandepend-hook-pre cleandepend-hook-post
cleandepend-hook-pre cleandepend-hook-post:
else
cleandepend:
endif

include priv/funcs.mk

##
## install target 
##
ifndef NO_INSTALL
install: install-hook-pre realinstall install-hook-post

install-hook-pre install-hook-post:

# build arguments list for 'realinstall' operation
__CHOWN_ARGS = $(call calc-chown-args, $(INCOWN), $(INCGRP))
__INSTALL_ARGS = $(call calc-install-args, $(INCOWN), $(INCGRP))
    
$(INCDIR):
	$(MKINSTALLDIRS) $(INCDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(INCDIR)
endif

realinstall: $(INCDIR)
	$(INSTALL) $(__INSTALL_ARGS) -m $(INCMODE) $(INCS) $(RELOC)/$(INCDIR)

else
install:
endif

##
## uninstall target 
##
ifndef NO_UNINSTALL
uninstall: uninstall-hook-pre realuninstall uninstall-hook-post

uninstall-hook-pre uninstall-hook-post:

realuninstall:
	for f in $(INCS); do \
	    rm -f $(INCDIR)/`basename $$f`; \
	done
	-rmdir $(INCDIR) 2>/dev/null

else
uninstall:
endif
