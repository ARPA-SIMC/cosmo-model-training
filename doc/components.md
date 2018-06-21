## Components of the COSMO software and external prerequisites ##

### COSMO code ###

 * Int2lm interpolation program that interpolates data from a global
   model or from COSMO model itself to the desired integration domain
 * Cosmo model *the meteorological model*

### External libraries ###

 * MPI - library for parallel computing
 * netcdf, netcdf-fortran - library for I/O of observations and other
   files
 * grib_api - library for I/O of mdel fields in grib format by ECMWF

### Other prerequisites ###

A Fortran compiler adhering to the full f95 standard and with at least
some basic support of f2003 features. Relatively recent versions of
open source gfortran compiler do the job.

Other commercial compilers, e.g. Intel, are known to produce faster
code, so it may be worth to pay for the license in exchange of a
smaller number of computing nodes, this has to be evaluated case by
case.

At hardware level, for real-time weather forecast it is necessary to
have a multinode distributed-memory parallel computing system. The
connection between nodes can be realised by standard ethernet hardware
(1Gb or 10Gb ethernet) but in order to make use of modern multi-core
architectures, a specific high performance connection for parallel
computing (e.g. Infiniband or Omnipath) supported by the MPI
implementation is strongly suggested.

The COSMO model can also take advantage of GPU accelerators with a
specific version of the code, but this will not be covered here.

[next](building_prerequisites.md)

[up](README.md)