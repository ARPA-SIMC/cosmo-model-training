## Input constant data ##

Input constant data includes at least height of orography and fraction
of land associated to the input model data, on the same input
grid. Optionally, also the soil type field may be provided, as well as
other information, depending on the input model.

### ICON ###

For an operational Cosmo setup it is suggested to use ICON model
data. The ICON model has data defined on a nontrivial triangular grid
on a icosahedral pseudo-sphere, so several external files are needed
for it.

The external constant data consist of 3 files: grid file (`icon_grid`,
netcdf), external parameter file (`icon_extpar`, netcdf) and file with
definitions of vertical levels (`icon_hhl`, grib2), these are the
corresponding namelist entries for int2lm in `INPUT` file:

```
 &GRID_IN
...
  yicon_grid_lfn='icon_grid_xxxx_R03B07.nc',
  yicon_grid_cat='/path/to/constant/files',
...
 /END
 &DATA
...
  yinext_lfn='icon_extpar_xxxx_R03B07_20180103.nc',
  yin_hhl='icon_hhl_xxxx_R03B07.g2',
  yinext_cat='/path/to/constant/files',
  yinext_form_read='ncdf',
...
 /END

```

These 3 files are provided by DWD on the desired subdomain and updated
from time to time.

### IFS/ERA ###

Conversely, in a case-study setup it is confortable to use data from
ECMWF reanalysis (ERA), which is publicly distributed, in this case
the data are retrieved from ECMWF archive interpolated on a simple
lat/lon grid, so only one single file with external parameters in grib
format is needed:

```
 &DATA
...
  yinext_lfn='era_extpar.grib',
  yinext_cat='/path/to/constant/files',
  yinext_form_read='apix',
...
 /END
```

### COSMO ###

When nesting COSMO in itself, the direct output of COSMO constant
parameters on the coarse grid, output by default in the file
`lfff00000000c`, can be used as input to int2lm as input model
constant data

```
 &DATA
...
  yinext_lfn='lfff00000000c',
  yinext_cat='/path/to/coarse/run/files',
  yinext_form_read='apix',
...
 /END
```

[next](input_ic_bc.md)

[up](README.md)