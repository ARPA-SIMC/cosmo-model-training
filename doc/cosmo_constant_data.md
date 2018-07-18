## COSMO constant data ##

COSMO constant data comprises a much wider set of constant fields than
constant input model data, ranging from orography, fraction of land
and of lake, soil type, information about vegetation, climatology of
aerosols, etc.

Some of these fields are optional and are required only if particular
parameterisations or namelist swithes are activated.

These data are usually provided on request by DWD on an area which has
to be larger than the integration domain but with the same resolution
and geographical projection intended for the run.

Interpolation program will just cut, not interpolate, the desired
portion and use it for its internal computation and or pass it along
to COSMO together with the analysis file.

For our tests we will use a 7 km [unrotated](rotated_grid.md) dataset
covering a big part of Asia `extpar/cosmo_asia_0.0625_1921x1601.g1` in
grib format, the corresponding namelist settings will look like:

```
 &DATA
...
  ie_ext=1921, je_ext=1601,
  ylmext_lfn='cosmo_asia_0.0625_1921x1601.g1',
  ylmext_cat='/path/to/constant/files',
  ylmext_form_read='apix',
...
 /END
```

The necessary set of external parameters can be asked to DWD,
specifying the area (which should be bigger than the desired
integration doman) the grid step and the desired pole of rotation (for
tropical areas unrotated fields, i.e. with north pole of rotation
coinciding with the geographical North Pole, is a good choice).

[next](retrieving_ecmwf_reanalysis.md)

[up](README.md)