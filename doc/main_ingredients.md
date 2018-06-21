## Main ingredients for running the COSMO model ##

Once all the software is ready, we need the data for running the model
system:

 * input model constant external parameters
 * input model data to be used as boundary and (possibly) initial
   conditions
 * COSMO model constant external parameters

In our operational test setup, input data will be derived from the
ICON global model of DWD.

This is the suggested approach for most COSMO users, however initial
and/or boundary conditions can also be provided by ECMWF IFS model (or
ERA opendata reanalysis which is equivalent to IFS in format) or by
COSMO itself typically when performing a nesting of COSMO in itself at
a higher resolution on a smaller region.

[next](input_constant_data.md)

[up](README.md)