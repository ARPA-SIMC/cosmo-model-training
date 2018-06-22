#!/bin/bash

# Script to convert the content of the definitions.edzw/grib1
# directory to allow grib1 I/O with grib_api within COSMO software
# (including analysis files) by a centre other than DWD.  Tested with
# definitions for grib_api 1.12.3.
# Bash shell strictly required.
# To be run in the directory containing definitions.edzw/ subdirectory.
# Two command line arguments can be provided: the numeric code and
# optionally the textual abbrevation of the non-DWD center
# respectively.

fix_grib1() {
    cd definitions.$totext/grib1

# localDefinitionNumber.$from.table can probably not be copied, taken
# care of in section1.def
# cleanup
    rm -f local.$to.def local.$to.253.def local.$to.254.def \
	localDefinitionNumber.$to.table
    for file in local.$from.def local.$from.253.def local.$from.254.def \
	localDefinitionNumber.$from.table; do
	ln -s $file ${file/$from/$to}
    done

# cleanup section.1.def
    rm -f section.1.def.$to
    [ -h section.1.def ] && rm -f section.1.def
    [ -f section.1.def.$from -a ! -f section.1.def ] && mv section.1.def.$from section.1.def

# edit section.1.def, needed for >=1.12.3
    if grep -q "centre=$from;" section.1.def; then
	mv section.1.def section.1.def.$from
	sed -e "s/centre=$from;/centre=$to;/g" section.1.def.$from > section.1.def.$to
	ln -s section.1.def.$to section.1.def
    fi

# cleanup localConcepts/ and local/
    rm -rf localConcepts/$totext
    rm -f local/$totext

# replicate localConcepts/
    if [ -f localConcepts/$fromtext/stepType.def ]; then
# since version 1.13.1 DWD stepType is (re)defined in localConcepts
# under condition centre==78, so we need to copy and edit
	cp -a localConcepts/$fromtext localConcepts/$totext
# maybe we can omit centre? to be tested
#    sed -e "s/centre=$from;//g" localConcepts/$fromtext/stepType.def > \
	sed -e "s/centre=$from;/centre=$to;/g" localConcepts/$fromtext/stepType.def > \
	    localConcepts/$totext/stepType.def
    else
	ln -s $fromtext localConcepts/$totext
    fi
# replicate local/
    if [ -d local ]; then
	ln -s $fromtext local/$totext
    fi

    cd -
}

fix_grib2() {
    cd definitions.$totext/grib2

    rm -f grib2LocalSectionNumber.$to.table local.$to.def tables/local/$totext \
	localConcepts/$totext
    ln -s grib2LocalSectionNumber.$from.table grib2LocalSectionNumber.$to.table
    ln -s local.$from.def local.$to.def
    ln -s $fromtext tables/local/$totext
    ln -s $fromtext localConcepts/$totext

    cd -
}


usage() {
    echo "Usage: `basename $0` <nationalcentre> [<textualcentre>]"
}

from=78
fromtext=edzw
#to=${1:-80}
to=$1
if [ -z "$to" ]; then
    echo "Error, numerical code of national centre not provided"
    usage
    exit 1
fi

if [ ! -d "definitions.$fromtext/" ]; then
    echo "Error, this script has to be executed in the directory containing"
    echo "definitions.$fromtext/ subdirectory"
    usage
    exit 1
fi

# detect textual name of center, is this the correct way?
totext=`awk "/^${to}/ {print \\$2}" definitions.$fromtext/grib2/local/2.0.table`
#totext=${2:-cnmc}
if [ -z "$totext" ]; then
    echo "Error, cannot detect automatically the textual code of national centre"
    echo "the numerical code $to will be used"
    totext=$to
fi
# fix odd file permissions
find definitions.$fromtext/ -type d -exec chmod 775 \{\} \;
find definitions.$fromtext/ -type f -exec chmod 664 \{\} \;

echo "Adapting $from ($fromtext) definitions to centre $to ($totext)..."

cp -a definitions.$fromtext/ definitions.$totext
fix_grib1
fix_grib2

echo "New definitions created in definitions.$totext."
echo "Definitions in definitions.$totext are still compatible"
echo "with original definitions for centre $from only for grib2, but not for grib1."
