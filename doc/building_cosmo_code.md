## Building COSMO code ##

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

[next](main_ingredients.md)

[up](README.md)