#!/bin/bash

# Script to convert the content of the definitions.edzw/grib1
# directory to allow grib1 I/O with grib_api within COSMO software
# (including analysis files) by a centre other than DWD.  Tested with
# definitions for grib_api 1.12.3.
# Bash shell strictly required.
# To be run in the directory containing definitions.edzw/ subdirectory.
# Two command line arguments can be provided: the numeric code and the
# textual abbrevation of the non-DWD center respectively, default 80
# and cnmc for Italy if not provided.

from=78
to=${1:-80}
totext=${2:-cnmc}
if [ ! -d "definitions.edzw/" ]; then
    echo "Error, this script has to be executed in the directory containing"
    echo "definitions.edzw/ subdirectory"
    exit 1
fi

# fix odd file permissions
find definitions.edzw/ -type d -exec chmod 775 \{\} \;
find definitions.edzw/ -type f -exec chmod 664 \{\} \;
cp -a definitions.edzw/ definitions.$totext

cd definitions.$totext/grib1

set -x

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

# edit section.1.def, needed for 1.12.3
if grep -q "centre=$from;" section.1.def; then
    mv section.1.def section.1.def.$from
    sed -e "s/centre=$from;/centre=$to;/g" section.1.def.$from > section.1.def.$to
    ln -s section.1.def.$to section.1.def
fi


# cleanup localConcepts/ and local/
rm -rf localConcepts/$totext local/$totext

# replicate localConcepts/
if [ -f localConcepts/edzw/stepType.def ]; then
# since version 1.13.1 DWD stepType is (re)defined in localConcepts
# under condition centre==78, so we need to copy and edit
    cp -a localConcepts/edzw localConcepts/$totext
# maybe we can omit centre? to be tested
#    sed -e "s/centre=$from;//g" localConcepts/edzw/stepType.def > \
    sed -e "s/centre=$from;/centre=$to;/g" localConcepts/edzw/stepType.def > \
	localConcepts/$totext/stepType.def
else
    ln -s edzw localConcepts/$totext
fi
# replicate local/
if [ -d local ]; then
    ln -s edzw local/$totext
fi

cd -
echo "New definitions created in definitions.$totext"
