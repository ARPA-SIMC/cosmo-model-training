## Installing postprocessing software

### Installing grib_api from repository

We have already compiled the grib_api software specifically for Cosmo
in a [previous section](building_prerequisites.md), however it may be
useful to install also a standard grib_api package, if available in the
Linux distribution in use. For CentOS 7 this can be done simply by:

```
sudo yum install grib_api grib_api-devel
```

The use of the Cosmo-specific definition files as described in the
section [Preparing the environment for
grib_api](preparing_for_grib_api.md) is not strictly necessary for
working with grib_api unless the Cosmo-like values of `shortName` key
are desired. Moreover the definitions installed in [Preparing the
environment for grib_api](preparing_for_grib_api.md) are specific to a
version of grib_api (1.20 in our case) and may not be compatible with
a different version of grib_api.

If one is going to install Arpae-SIMC software form the repository on
a CentOS 7 system, as described in the next paragraph, it is better not
to install grib_api since it will be replaced by the newer eccodes
software which includes also grib_api functionalities.

### Installing Arpae software

Arpae-SIMC develops and distributes various free software packages
useful for processing numerical weather prediction data, their main
uses with COSMO are:

 * Creating observations in BUFR format from text files (DB-All.e
   package)
 * Converting BUFR files in netcdf for data assimilation with Cosmo
   model (bufr2netcdf package)
 * Postprocessing output model data e.g. for computing accumulated or
   averaged fields on different time intervals, interpolating on
   different grids, interpolating or aggregating on sparse points or
   areas (libsim).

The source code for these packages is available on the [github
site](https://www.github.com/ARPA-SIMC). Most of the packages are also
publicly distributed in precompiled form for common rpm-based
GNU/Linux distributions such as latest versions of Fedora and CentOS.

For installing on CentOS from the public repository the procedure is
the following:

```
# install the copr plugin for reaching additional rpm repositories
sudo yum install yum-plugin-copr
# enable ARPA-SIMC repository
sudo yum copr enable simc/stable epel-7
# install software
sudo yum install wreport bufr2netcdf dballe arkimet libsim
```

For other GNU/Linux distributions, an universal binary package can
also be downloaded from the [smnd project on
github](https://github.com/ARPA-SIMC/smnd).

[next](cosmo_in_grads.md)

[up](README.md)
