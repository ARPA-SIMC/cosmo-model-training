## Installing Arpae software ##

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

[up](README.md)
