## Installing grads

On Fedora/CentOS system grads and other related tools can be installed
from the standard repository:

```
sudo yum install grads wgrib wgrib2 perl
```

The tools for generating the grads ctl file from grib1 and grib2 are
not included and have to be downloaded from the NOAA server:

```
# for grib1
wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib.scripts/grib2ctl.pl
# for grib2
wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/g2ctl/g2ctl
# make them executables
chmod +x grib2ctl.pl g2ctl
```

See also the page on [NOAA web
site](http://www.cpc.ncep.noaa.gov/products/wesley/grib2ctl.html).

[next](installing_postprocessing_software.md)

[up](README.md)