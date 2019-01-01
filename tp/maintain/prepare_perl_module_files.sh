#! /bin/sh
# $Id$
# Regenerate lists of t/ files, used for make dist(check)
# and the Perl modules.
#
# Copyright 2011, 2012, 2013, 2014, 2015 Free Software Foundation, Inc.
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Originally written by Patrice Dumas.

set -e

# to get a reproducible locales independent sort.
LC_ALL=C; export LC_ALL

# Regenerate files required for perl

./maintain/change_perl_modules_version.sh auto

# This regenerate files in t/include_dir/
make
# regenerate the list of XSParagraph files
sed 's;^;Texinfo/Convert/XSParagraph/;' < Texinfo/Convert/XSParagraph/MANIFEST > maintain/MANIFEST_XSParagraph_files

PACKAGE=`grep '^PACKAGE = ' Makefile | sed 's/^PACKAGE = //'`
if test z"$PACKAGE" = 'z' ; then 
  exit 1
fi
# LocaleData are also generated through Makefile.docstr.  Here we want
# them to be generated by the Makefile in po*/ to test that it works.
rm -rf LocaleData

for dir in po po_document; do
  rm -rf $dir
  mkdir $dir
  cp maintain/Makefile_perl_po $dir/Makefile
  grep '^tp\/' ../$dir/POTFILES.in | sed -e 's/^tp/../' > $dir/POTFILES.in
  echo "# File automatically generated from texinfo files"
  echo "PACKAGE = $PACKAGE" > $dir/PACKAGE
  cat ../$dir/Makevars >> $dir/PACKAGE
  linguas_str=
  for lingua in `cat ../$dir/LINGUAS`; do
    linguas_str="$linguas_str $lingua"
    cp -p ../$dir/$lingua.po $dir
  done
  echo "LINGUAS = $linguas_str" >> $dir/PACKAGE

  (cd $dir && make all && make clean)
done

find LocaleData po_document po t/include_dir -type f | sort \
  > maintain/MANIFEST_generated_files
make MANIFEST
cp -p ../COPYING .
sed 's/\(my \$hardcoded_version = \).*/\1 undef;/' texi2any.pl > texi2any
chmod a+x texi2any
touch -r texi2any.pl texi2any
# We could imagine using an even more stripped down version, as
# the default paths should be ok in a standalone module.
cp -p Texinfo/ModulePath.pm.in Texinfo/ModulePath.pm