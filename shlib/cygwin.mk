# $Id: cygwin.mk,v 1.1 2008/10/31 02:10:12 tho Exp $
#
# import __LIB, OBJS, OBJFORMAT from lib.mk
# export SHLIB_NAME to lib.mk 
# export CPICFLAGS, SHLIB_MAJOR, SHLIB_MINOR, SONAME to userspace
# export {all,install,uninstall,clean}-shared targets to lib.mk

ifdef SHLIB

SHLIB_OBJS = $(OBJS)

##
## set library naming
##
SHLIB_NAME ?= lib$(__LIB).dll

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building $(__LIB) as dynamic linked library"
	rm -f $(SHLIB_NAME)
	$(CC) -shared -o $(SHLIB_NAME) -Wl,--out-implib=lib$(__LIB).a \
	    -Wl,--export-all-symbols -Wl,--enable-auto-import \
	    -Wl,--whole-archive `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` \
	    -Wl,--no-whole-archive $(LDADD) ${LDFLAGS} 

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)

endif
