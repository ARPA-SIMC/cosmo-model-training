## Importing Cosmo data in grads ##

### Installing grads ###

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

### Importing Cosmo data in grads ###

The procedure for importing a single grib file consists in creating
the so-called *ctl* file, which contains the decription of the grib
content for grads, and indexing the grib file itself. For grib1 the
procedure, starting from a grib file named `lfff00000000` is:

```
./grib2ctl.pl lfff00000000p>lfff00000000p.ctl
gribmap -i lfff00000000p.ctl
```

After that, in grads we should open the file `lfff00000000p.ctl`, not
directly the grib file.

For grib2 it is similar but we have to use a different tool (and have
`wgrib2` command installed):

```
./g2ctl lfff00000000p>lfff00000000p.ctl
gribmap -i lfff00000000p.ctl
```

[next](installing_arpae_software.md)

[up](README.md)