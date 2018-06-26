## Running Cosmo ##

Most of the instructions for running int2lm apply also to cosmo,
e.g. setting the `nprocx` and `nprocy` namelist variables according to
the number of mpi processes that are going to be started, using
`mpirun` to start the program and exporting grib_api environment.

The main result of the run are the gridded output data that are to be
found in the directory/ies specified in the `INPUT_IO` `gribout`
namelist(s).

Output data are split one per output time step and per type of
vertical level:

 * `lfffDDHH0000` data on surface, on subsurface levels and on upper
   air native model levels
 * `lfffDDHH0000p` upper air data vertically interpolated on the
   desired isobaric levels
 * `lfffDDHH0000z` upper air data vertically interpolated on the
   desired constant height levels

[up](README.md)