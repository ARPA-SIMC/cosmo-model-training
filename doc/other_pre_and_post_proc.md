## Other useful pre- and post-processing operations ##

### Cutting out a subregion of a grid ###

It is often useful to cut out a subregion of a set of gridded fields
in a grib file, for example for reducing the size of a big external
dataset.

The libsim tools cab be used for this purpose, by means of a `zoom`
transformation, e.g.:

```
vg6d_transform --trans-mode='s' --trans-type=zoom --sub-type=coord  \
  --ilon=60. --ilat=-15. --flon=90. --flat=20. \
  cosmo_asia_0.0625_1921x1601.g1 cosmo_maldives_0.0625.g1
```

See `man vg6d_transform` for more options. The number of points on x
and y direction in the output grid can be obtained by inspecting the
output grib file e.g. with `grib_dump`. The following example does
this automatically with the help of `grib_get`:

```
ni=`grib_get -p Ni cosmo_maldives_0.0625.g1|head -1`
nj=`grib_get -p Nj cosmo_maldives_0.0625.g1|head -1`
# rename the file for ease of use in INPUT namelist
mv cosmo_maldives_0.0625.g1 cosmo_maldives_0.0625_${ni}x${nj}.g1
```

### Converting generic observations into BUFR ###

If it is desired to assimilate generic meteorological observations
into COSMO model, they have to be converted first into BUFR format
with a structure (template) suitable to the observation type
(e.g. surface, upper-air profile or upper-air single level). For this
purpose the Arpae software packages (Db-all.e in particular) can be
used.

First the observation should be written in a csv format similar to the
following:

```
Longitude,Latitude,Report,Date,Level1,L1,Level2,L2,Time range,P1,P2,Varcode,Value
12.052,44.027,synop,,,,,,,,,B01001,17
12.052,44.027,synop,,,,,,,,,B01002,0
12.052,44.027,synop,2013-03-15 06:00:00,1,,,,1,0,21600,B13011,0.2
12.052,44.027,synop,2013-03-15 06:00:00,103,2000,,,254,0,0,B12101,275.8
```

The columns `Longitude`, `Latitude` and `Date` have obvious meanings
(for the detailed interpretation of `Date`, see the explanation of
`Time range` and `Date` below); the `Report` column is just a hint to
the converter for choosing a suitable conversion template, so values
as `synop` and `temp` are acceptable.

Vertical levels in the csv file (columns `Level1,L1,Level2,L2`) are
coded according to tables mutuated from the WMO GRIB2 level coding:
Level1 and Level2 define a finite-thickness layer on which the
observation is valid, when the second level is missing the observation
is considered to be valid at a single level in the vertical; the next
table shows the most useful values for these codes.

Type of surface | code | unit
----------------|------|-----
Ground or water surface | 1 | 
Isobaric surface | 100 | Pa
Mean sea level | 101 | 
Specified altitude above mean sea level | 102 | mm
Specified height level above ground | 103 | mm
Depth below land surface | 106 | mm

Time ranges for statistical processing (columns `Time range,P1,P2`)
define a time interval and a possible statistical processing of the
observation on that interval; here too the coding style is mutuated
from GRIB2 tables. The values for `Time range` are indicated in the
following table, while `P1` (forecast time in seconds) should be 0 for
observations and `P2` is the length of the processing interval in
seconds.

Type of statistical processing | code (Time range)
-------------------------------|------------------
Average | 0
Acumulation | 1
Maximum | 2
Minimum | 3
Instantaneous | 254

The `Date` field indicates the so-called *verification time*, which,
for observations, is simply the time of the observation, while when
forecast data are to be coded in BUFR (although it is not the case
here), this is the time at which the datum is valid (for instantaneous
data) or at which the validity interval ends (for data on an
interval).

Codes for variables, i.e. physical quantities, indicated in the
`Varcode` column of the csv file, are derived from the BUFR table B of
WMO; the most useful values are listed in the following table and they
can be found in the installed file `/usr/share/wreport/dballe.txt`.

Variable | code (`Varcode`) | unit (for `Value`)
---------|------------------|-------------------
WMO block number | B01001 |
WMO station number | B01002 |
Pressure | B10004 | Pa
Pressure reduced to mean sea level | B10051 | Pa
Wind direction | B11001 | Deg. true
Wind speed | B11002 | m/s
U component of wind | B11003 | m/s
V component of wind | B11004 | m/s
W component of wind | B11006 | m/s
Air temperature | B12101 | K
Dew-point temperature | B12103 | K
Specific humidity | B13001 | Kg/Kg
Relative humidity | B13003 | %
Total precipitation | B13011 | Kg/m^2 (mm of water)

The csv file can be converted into BUFR format by running the command:

```
dbamsg convert -t csv -d bufr --template=$BUFR_TEMPLATE \
 obs.csv > obs.bufr
```

where `$BUFR_TEMPLATE` is a suitable template for the observation
type, see `dbamsg convert --template=list` for a complete list of
available templates.

### Converting generic observations into GRIB ###

For latent heat nudging in Cosmo, the observations (typically radar
rain rate estimation) have to be provided in the form of gridded
fields in grib format.

Following a procedure similar to the one seen in the previous section,
we can write our rain rate observations in a format similar to the
following:

```
Longitude,Latitude,Report,Date,Level1,L1,Level2,L2,Time range,P1,P2,Varcode,Value
12.052,44.027,,2013-03-15 06:00:00,1,,,,254,0,0,B13011,0.2
13.040,44.310,,2013-03-15 06:00:00,1,,,,254,0,0,B13011,0.4
13.510,44.330,,2013-03-15 06:00:00,1,,,,254,0,0,B13011,0.0
12.052,44.027,,2013-03-15 06:30:00,1,,,,254,0,0,B13011,0.5
13.040,44.310,,2013-03-15 06:30:00,1,,,,254,0,0,B13011,1.8
13.510,44.330,,2013-03-15 06:30:00,1,,,,254,0,0,B13011,2.0
```

for every point where an observation is available in space and time,
taking care to specify an instantaneous time range and to code the
value in units of Kg/m^2/h (mm/h) regardless of the standard unit for
variable `B13011`.

After that, the csv file should be converted to BUFR and then gridded
on the same grid used for the model run. For gridding we need a model
grib file to be used as template for describing the grid (named
`model_grid_template.grib` in the example). The commands are thus the
following:

```
# convert to BUFR
dbamsg convert -t csv -d bufr --template=generic \
 obs.csv > obs.bufr
# grid to a GRIB file using libsim tool v7d_transform
v7d_transform --post-trans-type=boxinter:average \
 --input-format=BUFR --output-format=grib_api:model_grid_template.grib \
 obs.bufr obs.grib
```

The output file `obs.grib` will have to be renamed to the form
`yymmddhh.grib1`, according to Cosmo convention, before feeding it to
the Cosmo model.

### Converting BUFR observations into netcdf for data assimilation ###

Cosmo model requires observations for data assimilation (excluded
latent heat nudging) to be formatted in a particular netcdf
format. Conversion from standard BUFR to this netcdf format can be
performed with the `bufr2netcdf` command included in the Arpae
packages.

```
bufr2netcdf -o obs input.bufr
```

bufr2netcdf dispatches data in different files according to the
observation type (category, subcategory from WMO tables), afterwards
the files have to be renamed for Cosmo with special names as in the
following commands:

```
ln -s obs-0-0-13.nc cdfin_synop
ln -s obs-0-0-14.nc cdfin_synop_mob
ln -s obs-1-0-255.nc cdfin_ship
ln -s obs-2-4-255.nc cdfin_temp
ln -s obs-2-5-255.nc cdfin_tempship
# may not work at the moment, restore later
# ln -s obs-2-1-4.nc cdfin_pilot
ln -s obs-2-1-5.nc cdfin_pilot_p
ln -s obs-4-0-8.nc cdfin_amdar
ln -s obs-4-0-9.nc cdfin_acars
```

If any of the observations are afterwards not correctly assimilated in
Cosmo, it is possible to try a preliminary conversion of the BUFR
before bufr2netcdf:

```
dbamsg convert --bufr2netcdf-categories --template=wmo $1 > $2
```

[up](README.md)