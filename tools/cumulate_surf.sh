#!/bin/sh
# isolate instantaneous fields
grib_copy -w productDefinitionTemplateNumber=0 surf.grib surf2.grib
# isolate average and accumulated fields
grib_copy -w typeOfStatisticalProcessing=0/1,productDefinitionTemplateNumber=8 surf.grib surfavgcum.grib
# recumulate on 1h intervals with libsim
vg6d_transform --comp-stat-proc=0:0 --comp-step='0 01' surfavgcum.grib avg.grib
# reaverage on 1h intervals with libsim
vg6d_transform --comp-stat-proc=1:1 --comp-step='0 01' surfavgcum.grib cum.grib
# append to instantaneous fields
cat avg.grib cum.grib >> surf2.grib
