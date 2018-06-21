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

## Installation ##

### MPI and netcdf ###

The suggested method for installing MPI and netcdf libraries is
through the own Linux distribution package management, since these
software packages are quite stable and, for MPI, there may be a strong
connection with the hardware. Different MPI installations (open source
and proprietary) may be available, here we use open source OpenMPI.

Example on CentOS/Fedora:

```
sudo yum install netcdf netcdf-devel netcdf-fortran-devel \
 openmpi openmpi-devel

```

on Debian/Ubuntu system this may look like

```
sudo apt-get install netcdf netcdf-dev netcdf-fortran-dev \
 openmpi openmpi-dev

```

In the following part we assume that the MPI implementation installed
has a Fortran interface that can be used in code compiled by the
desired compiler and that for compiling and linking MPI programs the
MPI implementation provides a "compiler wrapper" called `mpif90` which
adds the necessary command line switches to the basic Fortran
compiler.

On CentOS system with OpenMPI and gfortran this is the case, provided
that in your interactive session (or in the user's `.bash_profile`)
you execute `module load mpi/openmpi-x86_64`. This is required since
there is another open source MPI implementation available, called
`mpich`, the two implementations can be installed simultaneously and
are chosen by means of the `module` command.


Notice that if a different Fortran compiler, other than gfortran, is
used for COSMO code, then at least netcdf-fortran and grib_api (see
further) have to be compiled with the same Fortran compiler used for
compiling the COSMO code, because they make use of f90 modules which
are not portable between compilers. The MPI implementation, in some
cases, may be portable between different Fortran compilers having the
same C-calling convention.

### Grib_api ###

For grib_api, since COSMO requires a specific version which may not be
available in the distribution, it is suggested to compile it by
oneself.

First we need to install some prerequisites (compression libraries):

```
sudo yum install libpng-devel openjpeg-devel libquadmath-devel
```

Then we unpackage and build the grib_api version provided with COSMO,
at the moment `grib_api-1.20.0-Source.tar.gz`:

```
tar -xvf grib_api-1.20.0-Source.tar.gz
cd grib_api-1.20.0-Source
./configure --prefix=$HOME/maldives/install --enable-pthread \
 --enable-align-memory --enable-vector -enable-static enable_shared=no
make
...
make install
...
```

It is however possible to have at the same time grib_api (or the newer
equivalent package eccodes) installed from one own Linux distribution
repository without conflict.

Besides providing the I/O API to COSMO model, grib_api has an
invaluable set of tools for inspecting and modifying grib files, see
man pages of `grib_dump`, `grib_ls`, `grib_set`, `grib_filter`.

### Int2lm ###

Unpack the int2lm package `int2lm_180226_2.05.tar.bz2`, and enter the
corresponding directory `int2lm_180226_2.05`. Now we must edit the
`Fopts` file for specifying the build configuration, compiler and
compiler options, optimizations, libraries.

Cleaned up example  of `Fopts` for our environment:

```
# Fortran compiler
GRIBDIR      = $(HOME)/maldives/install
#
F90          = mpif90 -cpp -c -ffree-line-length-none \
               -ffpe-trap=invalid,zero,overflow -fbacktrace -fdump-core \
               -I/usr/lib64/gfortran/modules -I$(GRIBDIR)/include \
               -DGRIBAPI -DNETCDF
# linker
LDPAR        = mpif90 -g
LDSEQ        = gfortran
# standard binary
PROGRAM      = tstint2lm
# compile flags
COMFLG1      = -O2 -g
COMFLG2      = $(COMFLG1)
COMFLG3      = $(COMFLG1)
COMFLG4      = -O0 -g
#
LIB          = -L$(GRIBDIR)/lib -lnetcdff -lnetcdf -lgrib_api_f90 -lgrib_api \
               -lpng -lopenjpeg
```

After we type `make` and the end we should obtain the executable
`tstint2lm`.

Explanation of some necessary compiler switches (in case you use a
compiler other than gfortran or a different version of gfortran thay
may need to be translated):

 * `-cpp` enable preprocessing of `.f90` sources with the C
   preprocessor (lines containing `#ifdef` etc.)

 * `-ffree-line-length-none` allow lines longer than 132 characters
   (no limits on line length)

 * `-I/usr/lib64/gfortran/modules` try this directory when looking for
   f90 module files (`*.mod`) for netcdf libraries installed by the
   system administrator (may be different on other systems)

 * `-I$(GRIBDIR)/include` try this directory when looking for f90
   module files (`*.mod`) for grib_api that we have just installed

 * `-DGRIBAPI` `-DNETCDF` compile optional code performing I/O with
   these two libraries

 * `-DGRIBDWD` *do not use* although it is in the example Fopts file,
   since it enables I/O with the old DWD grib library which has been
   replaced by grib_api

Other switches are for debugging/optimization so they are not strictly
necessary for a successful compilation and run, but they are required
for running efficiently the code in oeprational mode.

### Cosmo ###

Similarly to int2lm we unpack `cosmo_180223_5.05.tar.bz2`, enter the
directory end edit `Fopts`:

```
# Fortran compiler
GRIBDIR      = $(HOME)/maldives/install
#
F90          = mpif90 -cpp -c -ffree-line-length-0 -fstack-protector-all \
               -ffpe-trap=invalid,zero,overflow -fbacktrace -fdump-core \
               -I/usr/include -I/usr/lib64/gfortran/modules -I$(GRIBDIR)/include \
               -D__COSMO__ -DGRIBAPI -DNETCDF -DNUDGING -DALLOC_WKARR
# linker
LDPAR        = mpif90 -g
LDSEQ        = gfortran
# standard binary
PROGRAM      = lmparbin
# compile flags
COMFLG1      = -O2 -g
COMFLG2      = $(COMFLG1)
COMFLG3      = $(COMFLG1)
COMFLG4      = -O0 -g
#
LIB          = -L$(GRIBDIR)/lib -lnetcdff -lnetcdf -lgrib_api_f90 -lgrib_api \
               -lpng -lopenjpeg
```

Notes: do not use `-DGRIBDWD` since it enables the use of the old DWD
grib library that we do not want to use since we use
grib_api. `-DSINGLEPRECISION` can be added in order to compile in
single-precision mode.

After `make` we should obtain the executable `tstint2lm`.

The same switches seen for int2lm apply here too, plus some more ones:

 * `-I/usr/include` try this directory when looking for netcdf include
   (not module) files
 
 * `-D__COSMO__` required because part of the code is in common with
   ICON model

 * `-DNUDGING` required if nudging assimilation code is desired

 * `-DALLOC_WKARR` new switch allowing static allocation of work
   arrays, optional, it may generate faster code but requiring more
   RAM

All the switches related to "RTTOV" concern a part of code for
generating synthetic satellite images, it requires a software library
licensed by [Eumetsat](http://www.eumetsat.org). For simplicity we
will ignore (disable) this part at the moment.

## Main ingredients for running the COSMO model ##

Once all the software is ready, we need the data for running the model
system:

 * input model data constant external parameters
 * input model data to be used as boundary and (possibly) initial
   conditions
 * COSMO model constant external parameters

### Input model data ###

#### Constant data ####

In our operational case they will be derived from the ICON global
model of DWD. This is the suggested approach for mosto COSMO users.

The ICON model has data defined on a nontrivial triangular grid on the
sphere, so several external files are needed for it.

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

Conversely, in our case-study setup we will use data from ECMWF
reanalysis (ERA), in this case the data are retrieved from ECMWF
archive interpolated on a simple lat/lon grid, so only one single file
with external parameters in grib format is needed:


```
 &DATA
...
  yinext_lfn='era_extpar.grib',
  yinext_cat='/path/to/constant/files',
  yinext_form_read='apix',
...
 /END
```

#### Initial and boundary conditions ####

Input model data to be used as initial and boundary conditions should
then be provided with a particular naming scheme depending on the input model.

If the input model is ICON, as specifiend in the int2lm `INPUT`
namelist:

```
 &CONTRL
...
  yinput_model='ICON',
...
 /END
```

the naming scheme is `igfffDDHH0000`, with `DD` equal to the number of
days of forecast and `HH` number of hours. For 3-hourly data up to 72
hours it will thus look like:

```
igfff00000000
igfff00030000
igfff00060000
...
igfff00180000
igfff01000000
igfff01030000
...
igfff03000000
```

It is suggested to get boundary data al least every 3 hours, however,
if you internet connection allows it, ICON can be retrieved also with
an hourly frequency.

If the input is ECMWF IFS model or ERA reanalysis we have

```
 &CONTRL
...
  yinput_model='IFS',
...
 /END
```

and the naming scheme is `igfffDDHH0000`, with `DD` equal to the number of
days of forecast and `HH` number of hours. For 3-hourly data up to 72
hours it will thus look like:
