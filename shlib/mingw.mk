# $Id: mingw.mk,v 1.5 2008/11/07 11:15:44 tho Exp $
#
# import __LIB, OBJS, OBJFORMAT from lib.mk
# export SHLIB_NAME to lib.mk 
# export CPICFLAGS, SHLIB_MAJOR, SHLIB_MINOR, SONAME to userspace

ifdef SHLIB

SHLIB_OBJS = $(OBJS)

##
## set library naming vars
##
SHLIB_NAME ?= $(__LIB).dll
SHLIB_IMP ?= lib$(__LIB).dll.a

SHLIB_LDFLAGS += -shared 
# also create an import library in order to interface with objects 
# generated by other toolchains 
SHLIB_LDFLAGS += -Wl,--out-implib,$(SHLIB_IMP)
# the following makes useless adding dllimport or dllexport attributes 
# to the source code
SHLIB_LDFLAGS += -Wl,-no-undefined -Wl,--enable-runtime-pseudo-reloc

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@$(ECHO) "===> building dynamically linked library $(__LIB)"
	$(RM) -f $(SHLIB_NAME)
	$(__CC) $(SHLIB_LDFLAGS) -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) $(LDFLAGS) 

$(SHLIBDIR):
	$(MKINSTALLDIRS) "$(SHLIBDIR)"
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) "$(SHLIBDIR)"
endif

install-shared: $(SHLIBDIR)
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) "$(SHLIBDIR)"

uninstall-shared:
	$(RM) -f "$(SHLIBDIR)/$(SHLIB_NAME)"
	-rmdir "$(SHLIBDIR)" 2>/dev/null

clean-shared:
	$(RM) -f $(SHLIB_OBJS)
	$(RM) -f $(SHLIB_NAME)
	$(RM) -f $(SHLIB_IMP)

endif
