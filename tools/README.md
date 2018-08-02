## Useful tools

This directory contains general-purpose tools performing the following
tasks:

 * `convert_def.sh` converts modified DWD grib_api definitions for use
   with a national center of emission different from 78 (DWD), both
   for grib1 and grib2. The resulting definitions maintain however
   compatibility with the DWD center. [See also "Preparing the
   environment for grib_api"](../doc/preparing_for_grib_api.md).
 * `era_for_cosmo.py` downloads ECMWF ERA-Interim or ERA5 reanalysis
   data in a format ready for running Cosmo model. ERA data can be
   freely downloaded also by non ECMWF members, a registration process
   is required. [See also "Retrieving ECMWF
   reanalysis"](../doc/retrieving_ecmwf_reanalysis.md)).
 * `make_surf.sh` extracts surface fields from Cosmo model output
   using grib_api tools, works both with grib edition 1 and 2.
 * `cumulate_surf.sh` accumulates and averages on hourly intervals all
   the fields produced by Cosmo (typically precipitation and fluxes)
   which are suitable for accumulation or averaging. It makes use of
   Arpae "libsim" tools. [See also "Importing Cosmo data in
   grads"](../doc/cosmo_in_grads.md#postprocessing-data-for-improving-grads-experience).
   
