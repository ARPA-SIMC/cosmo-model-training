## Retrieving ECMWF reanalysis

Recent ECEMF reanalysis projects, namely ERA-Interim and ERA5, offer a
publicly accessible archive of atmospheric reanalysis data with a
relatively high spatial resolution and availability of fields,
suitable to be used as initial and boundary condition for experiments
with Cosmo model.

In order to get access to the data, the user must register and install
the ecmwf-api-client package as indicated in the [corresponding ECMWF
page](https://confluence.ecmwf.int//display/CKB/How+to+download+data+via+the+ECMWF+WebAPI).

### Use of the provided script for retriving data for Cosmo

This project provides a script `era_for_cosmo.py` which can be used to
perform data retrieval of ERA reanalysis data and produces the files
ready for a Cosmo run.

The script can retrieve both analysis and forecast, but it is
suggested to use analysis data for experiments. The typical use,
assuming we want to access analysis data in the interval 30/11/2017 -
2/12/2017 with 3-hour step and the external constant parameters, is
the following:

```
./era_for_cosmo.py --start-date=2017113000 --end-date=2017120200 \
 --dataset=era5 --input-type=a --analysis-step=3 --area=13/63/-7/83 \
 --extpardir=extpar
```

This will create files `eas2017113000`, `eas2017113003`, ...
`eas2017120200` with the analyses and a file `extpar/ec_ext.grib` with
the constant parameters. In order to run the desired model experiment
it is necessary to move the analysis files in the input model
directory, the constant file in the external parameter directory and
set the date of the run accordingly.

A more complete manual and list of options can be obtained by
executing `era_for_cosmo.py --help`.

[next](preparing_for_grib_api.md)

[up](README.md)