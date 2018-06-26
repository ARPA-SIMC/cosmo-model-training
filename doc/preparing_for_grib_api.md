## Preparing the environment for grib_api ##

### Definition files ###

Grib_api software makes use of so-called definition files for
describing the binary structure of a grib file and for associating
named keys to the numerical information contained. In a normal
grib_api installation, the definition files are installed together
with the software. Grib_api commands and library look for these
definitions in the installation directory
(e.g. `/usr/share/grib_api/definitions`).

The implementation of grib_api in COSMO requires the integration of
the standard definition files with a set of customised definition
files that provide grib_api with additional information, in
particular, they allow some non standard use of grib format within
COSMO and they associate the names of physical variables used in COSMO
model (e.g. `T`, `T_2M` etc.) to entries in grib numerical parameter
table.

These additional definition files are provided in a subpackage inside
the int2lm package e.g. `int2lm_180226_2.05/1.20.0.tar.bz2`. The
subpackage contains both the original grib_api definitions and the
additional COSMO definitions.

In order to use the cutomised definition files together with the
original ones the environmental variable `GRIB_DEFINITION_PATH` has to
be exported, pointing to the base directories of the two sets of
definitions (the customised ones first, then the original ones).

Additionally, the subpackage distributed contains also "samples"
i.e. templates for generating grib files from zero, which are used
when producing grib in output, these also are to be fed to the COSMO
software through the variable `GRIB_SAMPLES_PATH`.

### Customisation of definition files for WMO centre ###

When these specific definition files are activated within grib_api,
their effect depends on the "emission centre" i.e. the National
Meteorological Centre (as defined in WMO tables) which is encoded
inside the grib file being used.

By using the default definitions provided with int2lm, grib_api will
apply the new definitions only to grib using the centre 78 (DWD), if a
different centre is to be used (e.g. Maldives=124, see [WMO
table](http://www.wmo.int/pages/prog/www/WMOCodes/WMO306_vI2/LatestVERSION/WMO306_vI2_CommonTable_en.pdf)
a script `convert_def.sh` can be applied to the DWD-provided
definitions in order to extend them to the desired centre, both for
grib1 and for grib2. The script can be found in this package, it has
been developed by Arpae and is experimental.

There is also a similar `link_cosmo_script.git` provided in the int2lm
code package, but it works only for grib2 and for a number of
predefined centres.

### Putting it all together ###

In order to prepare the grib_api definition the procedure is the
following (we will use version 1.20):

```
mkdir grib_api_edzw
cd grib_api_edzw
tar -xvf ../int2lm_180226_2.05/1.20.0.tar.bz2
cd 1.20.0
# customisation for centre 124 (optional, may vary)
../../tools/convert_def.sh 124
```

After running the procedure, the directory definitions.124/ has to be
used instead of definitions.edzw/ which would be used if we worked
with only centre=78 (DWD or edzw).

The environment variables to be exported when running COSMO software
would then be:

```
export GRIB_DEFINITION_PATH=$HOME/maldives/grib_api_edzw/1.20.0/definitions.124:$HOME/maldives/grib_api_edzw/1.20.0/definitions
export GRIB_SAMPLES_PATH=$HOME/maldives/grib_api_edzw/1.20.0/samples
```

It is very important to accurately set these environmental variables
when running int2lm and cosmo.

Hopefully with this environment setting it will be possible to manage
correctly grib edition 1 and 2 coded by both centers 78 (DWD) and 124
(Maldives) simultaneously.

[next](running_int2lm.md)

[up](README.md)