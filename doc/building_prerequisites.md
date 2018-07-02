## Building prerequisites ##

### Building environment ###

The building environment required for COSMO model includes a minimum
of packages in addition to a typical basic operating system
environment, for example on CentOS/Fedora:

```
sudo yum install epel-release
sudo yum install gcc gcc-c++ gcc-gfortran wget make patch autoconf automake libtool
```

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
 --enable-align-memory --enable-vector --enable-static --disable-shared
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

[next](building_cosmo_code.md)

[up](README.md)