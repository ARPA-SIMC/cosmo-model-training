## COSMO data formats

Int2lm and COSMO have support for different formats in input and
output.

### Gridded data

Input and output gridded data can be read and written in WMO grib1,
grib2 (grib_api library) and netcdf following CF convention (netcdf
library) formats.

Meteorological centers tend to prefer grib format since it is the
standard established by WMO, while in research and climatological
environment netcdf is often preferred.

During this course we will treat mainly grib format. If there is no
particular reason for using the legacy grib1, the best choice is to
produce output in grib2 format which is more extended. (However grads
compatibility has to be checked).

For writing grib, the specific namelist entry `y*_form_write` should
be set to `grib1` or `grib2` depending on the desired flavor, while
for reading grib (either edition 1 or 2) `y*_form_read` should be set
to `apix`.

For netcdf the indicated entries should be set to `netcdf` both for
reading and writing.

### Point data (observations)

Observational data for data assimilation are read by COSMO in netcdf
format with a specific convention; these data can be converted from
the standard WMO BUFR format to netcdf with a specific program
[bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf) which will be
introduced in another part of the course.

[next](main_ingredients.md)

[up](README.md)
