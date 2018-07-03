#!/bin/sh
rm -f surf.grib o.tmp
# loop on output fields
for file in lfff0???0000; do
echo $file
# eliminate upper air and soil fields
grib_copy -w typeOfLevel!=generalVertical/generalVerticalLayer/depthBelowLandLayer/depthBelowLand $file o.tmp
# put all time ranges together
cat o.tmp >>surf.grib
rm -f o.tmp
done
