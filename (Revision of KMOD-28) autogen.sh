#!/bin/sh                                                                                                                                                                                                                                                                                                
#
#     Revision in kmod-28 autogen.sh to armv7 Android. Now, attention because
#     the program change linking a anther libtool before to make and give error 
#     to aclocal.m4. Only change copping your bin libtool to kmod-28 folder.   
#     Now. About the FLAGS: The flags are another viruses type.
#     Please, no to program with FLAGS. The FLAGS must to have support.
#                                Fair play
#           Following (and you follow) the GNU General Public Licence.
#                       hl9000 - cotirrep@gmail.com
#

set -e 

oldpwd=$(pwd)
topdir=$(dirname $0)
cd $topdir

gtkdocize --docdir libkmod/docs || touch libkmod/docs/gtk-doc.make
autoreconf --make

libdir(){echo $(cd "$1/$(arm-linux-androideabi-gcc --print-multi-os-directory)"; pwd)
}

args="\
--prefix=/data/data/com.termux/files/usr \
--sysconfdir=/data/data/com.termux/files/usr/etc \
--libdir=$(libdir /data/data/com.termux/files/usr/lib) \
"

if [ -f "$topdir/.config.args" ]; then
    args="$args $(cat $topdir/.config.args)"
fi

if [ ! -L /bin ]; then
    args="$args \
        --with-rootprefix=/data/data/com.termux/files/usr \
        --with-rootlibdir=$(libdir /data/data/com.termux/files/usr/lib) \
        "
fi

cd $oldpwd

hackargs="\
--enable-debug \
--enable-python \
--with-zstd \
--with-xz \
--with-zlib \
--with-openssl \
"

if [ "x$1" = "xc" ]; then
        shift
        $topdir/configure $args $hackargs "$@"
        make clean
elif [ "x$1" = "xg" ]; then
        shift
        $topdir/configure $args "$@"
        make clean
elif [ "x$1" = "xl" ]; then
        shift
        $topdir/configure CC=clang CXX=clang++ $args "$@"
        make clean
elif [ "x$1" = "xa" ]; then
        shift
        $topdir/configure $args "$@"
        make clean
elif [ "x$1" = "xs" ]; then
        shift
        scan-build $topdir/configure $args "$@"
        scan-build make
else
        echo
        echo "----------------------------------------------------------------"
        echo "Initialized build system. For a common configuration please run:"
        echo "----------------------------------------------------------------"
        echo
        echo "$topdir/configure $args"
        echo
        echo If you are debugging or hacking on kmod, consider configuring
        echo like below:
        echo
        echo "$topdir/configure $args $hackargs"
fi
