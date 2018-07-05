#!/bin/sh
rm -f surf2.grib
# isolate instantaneous fields
grib_copy -w timeRangeIndicator=0/productDefinitionTemplateNumber=0 surf.grib surf2.grib
# isolate average and accumulated fields
rm -f surfavgcum.grib*
touch surfavgcum.grib1 surfavgcum.grib2
grib_copy -w editionNumber=1,timeRangeIndicator=3/4 surf.grib surfavgcum.grib1
grib_copy -w editionNumber=2,typeOfStatisticalProcessing=0/1,productDefinitionTemplateNumber=8 surf.grib surfavgcum.grib2
cat surfavgcum.grib1 surfavgcum.grib2 > surfavgcum.grib
# recumulate on 1h intervals with libsim
vg6d_transform --comp-stat-proc=0:0 --comp-step='0 01' surfavgcum.grib avg.grib
# reaverage on 1h intervals with libsim
vg6d_transform --comp-stat-proc=1:1 --comp-step='0 01' surfavgcum.grib cum.grib
# append to instantaneous fields
cat avg.grib cum.grib >> surf2.grib
rm -f surfavgcum.grib*
