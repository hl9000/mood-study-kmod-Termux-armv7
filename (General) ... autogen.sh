#!/bin/sh                                                                             
#
#                       changed 4 personal study use
#                        hl9000 - cotirrep@gmail.com                                  
#          **without: gstreamer autogen.sh & git sources, because fail. 
#                       Who know the autor, inform me.
#                                  Tnk u
#
# Run this to generate all the initial makefiles.
#                               
# was said that this file has been generated from
#                common/autogen.sh.in via common/update-autogen   
# 
#   This program is distributed in the hope that it will be useful,but
#   WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#   or FITNESS FOR A PARTICULAR PURPOSE.
#   Follow the GNU Lesser General Public License. See GNU-LGPL for more details.


test -n "$srcdir" || srcdir=`dirname "$0"`                                            
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"
                                                                                      
autogen_options $@

printf "+ check for build tools"
if test -z "$NOCHECK"; then
  echo

  printf "  checking for autoreconf ... "
  echo
  which "autoreconf" 2>/dev/null || {
    echo "not found! Please install the autoconf package."
    exit 1
  }

  printf "  checking for pkg-config ... "
  echo
  which "pkg-config" 2>/dev/null || {
    echo "not found! Please install pkg-config."
    exit 1
  }
else
  echo ": skipped version checks"
fi

# if no arguments specified then this will be printed
if test -z "$*" && test -z "$NOCONFIGURE"; then
  echo "+ checking for autogen.sh options"
  echo "  This autogen script will automatically run ./configure as:"
  echo "  ./configure $CONFIGURE_DEF_OPT"
  echo "  To pass any additional options, please specify them on the $0"
  echo "  command line."
fi

toplevel_check $srcfile

# autopoint
if test -d po && grep ^AM_GNU_GETTEXT_VERSION configure.ac >/dev/null ; then
  tool_run "autopoint" "--force"
fi

# aclocal
if test -f acinclude.m4; then rm acinclude.m4; fi

autoreconf --force --install || exit 1

test -n "$NOCONFIGURE" && {
  echo "+ skipping configure stage for package $package, as requested."
  echo "+ autogen.sh done."
  exit 0
}

cd "$olddir"

echo "+ running configure ... "
test ! -z "$CONFIGURE_DEF_OPT" && echo "  default flags:  $CONFIGURE_DEF_OPT"
test ! -z "$CONFIGURE_EXT_OPT" && echo "  external flags: $CONFIGURE_EXT_OPT"
echo

echo "$srcdir/configure" $CONFIGURE_DEF_OPT $CONFIGURE_EXT_OPT
"$srcdir/configure" $CONFIGURE_DEF_OPT $CONFIGURE_EXT_OPT || {
        echo "  configure failed"
        exit 1
}

echo "Now type 'make' to compile $package."
