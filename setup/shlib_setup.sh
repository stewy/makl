#!/bin/sh
#
# $Id: shlib_setup.sh,v 1.1 2006/06/26 07:20:10 tho Exp $

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

rsname=`uname -rs | tr [A-Z] [a-z] | sed -e 's/ //'`

# if the exact file to use is set in the environment, just pick it up
if [ "${MAKL_SHLIB}" ]; then
    shlib_file=${MAKL_SHLIB}
else
    # if we've been passed a specific platform, use it as a basename.
    if [ $# -ne 0 ]; then
        shlib_file=$MAKL_DIR/shlib/$1.mk
    else
        case ${rsname}
        in 
            freebsd*)
                platform="freebsd"
                ;;
            linux*)
                platform="linux"
                ;;
            darwin*)
                platform="darwin"
                ;;
            *)
                platform="default"
                ;;
        esac 

        shlib_file=${MAKL_DIR}/shlib/$platform.mk
    fi
fi

# if shlib file does not exist, install the default
if [ ! -f "${shlib_file}" ]; then
    shlib_file=${MAKL_DIR}/shlib/default.mk
fi

echo "MaKL: installing shlib file '$shlib_file'"
/bin/cp ${shlib_file} ${MAKL_DIR}/mk/shlib.mk
exit $?